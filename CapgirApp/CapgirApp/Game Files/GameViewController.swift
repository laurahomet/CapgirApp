//
//  GameViewController.swift
//  CapgirApp
//
//  Created by Laura Homet Garcia on 29/08/2020.
//  Copyright © 2020 LauraHomet. All rights reserved.
//

import UIKit

class GameViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    // ======================================================
    // MARK: - Connections to UI
    // ======================================================
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var timerLabel: UILabel!
    
    
    // ======================================================
    // MARK: - Variables of ViewController
    // ======================================================
    
    let model = CardModel()
    var cardsArray = [Card]()
    var firstFlippedCardIndex:IndexPath? //Optional. If nil, card has not been selected. If !nil, one card has been selsected
    
    var timer:Timer? // Optional, nil at first.
    var milliseconds:Int = 40 * 1000
    
    var soundPlayer = SoundManager()
    
    var menuView:MenuViewController?
    
    // ======================================================
    // MARK: - Setup
    // ======================================================
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        cardsArray = model.getCards()
        
        // Set the view controller as the datasource and delegate of the collection view
        collectionView.dataSource = self
        collectionView.delegate = self
        
        //Initialize the timer
        timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(timerFired), userInfo: nil, repeats: true)
        
        // Make the timer a background task
        RunLoop.main.add(timer!, forMode: .common)
        
        instantiateMenuView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // Play shuffle sound
        soundPlayer.playSound(effect: .shuffle)
    }
  
    // ======================================================
    // MARK: - Timer Methods
    // ======================================================
    
    @objc func timerFired() {
    //@objc (Objective-C) is because of the legacy.
    //The syntax like this (#selector) is a functionailty that Objective-C used
        
        // Decrement the counter
        milliseconds -= 1
        
        // Update the label
        let seconds:Double = Double(milliseconds)/1000.0
        timerLabel.text = String(format: "Temps restant: %.2f", seconds)
        
        // Stop the timer if it reaches zero
        if milliseconds == 0 {
            timerLabel.textColor = UIColor.red
            timer?.invalidate()
            
            // Check if the user has cleared all the pairs
            checkForGameEnd()
        }
        
        
        
    }
    
    
    // ======================================================
    // MARK: - Collection View Delegate Methods
    // ======================================================
    
    // ------------------------------------
    // ------ numberOfItemsInSection ------
    // ------------------------------------
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cardsArray.count
    }
    
    // ------------------------------------
    // ---------- cellForItemAt -----------
    // ------------------------------------
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Get a cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as! CardCollectionViewCell
        
        // Return it
        return cell
    }
    
    // ------------------------------------
    // ----------- willDisplay ------------
    // ------------------------------------
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        // Configure the state of the cell based on the properties of the Card that it represents
        let cardCell = cell as? CardCollectionViewCell
        
        let card = cardsArray[indexPath.row]
        
        cardCell?.configureCell(card: card)
    }
    
    // ------------------------------------
    // --------- didSelectItemAt ----------
    // ------------------------------------
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // Check if there's any time remaining. Don´t let the user interact if the time is 0
        if milliseconds <= 0 {
            return
        }
        
        // Get a reference to the cell that was tapped
        let cell = collectionView.cellForItem(at: indexPath) as? CardCollectionViewCell
        
        // Check the status of the card to determine how to flip it
        if cell?.card?.isFlipped == false && cell?.card?.isMatched == false {
            
            // Flip the card up
            cell?.flipUp() // If it is not nil, perform flipUp
            
            // Play flip sound
            soundPlayer.playSound(effect: .flip)
            
            // Check if this is the first card that was flipped or the second one
            if firstFlippedCardIndex == nil {
                
                // This is the first card flipped over
                firstFlippedCardIndex = indexPath
            }
            else {
                
                // Second card that is flipped
                // Run the comparison logic
                checkForMatch(indexPath)
            }
        }
        
    }
    
    
    // ======================================================
    // MARK: - Game logic Methods
    // ======================================================
    
    // ------------------------------------
    // ---------- checkForMatch -----------
    // ------------------------------------
    func checkForMatch(_ secondFlippedCardIndex:IndexPath) {
        
        // Get the two card objects for the two indices and see if they match
        let cardOne = cardsArray[firstFlippedCardIndex!.row]
        let cardTwo = cardsArray[secondFlippedCardIndex.row]
        
        // Get the two collection view cells that represent card one and two
        let cardOneCell = collectionView.cellForItem(at: firstFlippedCardIndex!) as? CardCollectionViewCell
        let cardTwoCell = collectionView.cellForItem(at: secondFlippedCardIndex) as? CardCollectionViewCell
        
        // Compare the two cards
        if cardOne.imageName == cardTwo.imageName {
            
            // It´s a match
            
            // Play match sound
            soundPlayer.playSound(effect: .match)
            
            // Set the status and remove them
            cardOne.isMatched = true
            cardTwo.isMatched = true
            
            cardOneCell?.remove()
            cardTwoCell?.remove()
            
            // Was that the last pair?
            checkForGameEnd()
        }
            
        else {
    
            // It´s not a match
            
            // Play no match sound
            soundPlayer.playSound(effect: .nomatch)
            
            cardOne.isFlipped = false
            cardTwo.isFlipped = false
            
            // Flip them back over
            cardOneCell?.flipDown()
            cardTwoCell?.flipDown()
        }
        
        // Reset the firstFlippedCardIndex property
        firstFlippedCardIndex = nil
        
    }
    
    // ------------------------------------
    // -------- checkForGameEnd -----------
    // ------------------------------------
    func checkForGameEnd () {
        
        // Check if all there's any card that is unmatched
        
        // Assume the user has won, loop through all the cards to see if all of them are matched
        var hasWon = true
        
        for card in cardsArray {
            
            if card.isMatched == false {
                // We've found a card that is unmatched
                hasWon = false
                break
            }
            
        }
        
        if hasWon {
            
            // User has won, show an alert
            showAlert(title: "Felicitats!", message: "Has guanyat!")
            
        }
        else {
            
            // User hasn't won yet, check if there´s any time left
            if milliseconds <= 0 {
                showAlert(title: "Temps!", message: "Llàstima, sort per la propera!")
            }
            
        }
        
    }
    
    
    // ------------------------------------
    // ----------- showAlert --------------
    // ------------------------------------
    func showAlert(title:String, message:String) {
        
        // Create the alert
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        // Add a button for the user to dismiss it
        let okAction = UIAlertAction(title: "Ok", style: .default) { (tapped) in
            self.goToMenuView()
        }
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
        
    }
}

//--- MARK: Path To Menu View Controller
extension GameViewController {
    
    //------ Path to Menu View
    func instantiateMenuView(){
        menuView = storyboard?.instantiateViewController(identifier: "MenuVC") as? MenuViewController
        menuView?.modalPresentationStyle = .fullScreen
    }
    
    func goToMenuView(){
        present(menuView!, animated: true, completion: nil)
    }
    
}
