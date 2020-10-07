//
//  MenuViewController.swift
//  CapgirApp
//
//  Created by Laura Homet Garcia on 29/08/2020.
//  Copyright © 2020 LauraHomet. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
    
    @IBOutlet weak var menuTableView: UITableView!
    
    var model = MenuModel()
    var menuArray = [MenuOption]()
    
    var quizView:QuizViewController?
    var gameView:GameViewController?

    override func viewDidLoad() {
        super.viewDidLoad()

        //Set MenuViewController as the dataSource and delegate of the TableView
        menuTableView.delegate = self
        menuTableView.dataSource = self
        
        menuArray = model.getMenu()
        
        instantiateQuizView()
        instantiateGameView()
        
    }
    
    

}

//--- MARK: TableView Methods
extension MenuViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return menuArray.count+1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //Get a cell & customize it
        if indexPath.row < menuArray.count {
            let cell = menuTableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as! MenuTableViewCell
            
            cell.configureMenu(menu:menuArray[indexPath.row])
            
            return cell
            
        } else {
            let cell = menuTableView.dequeueReusableCell(withIdentifier: "WebCell", for: indexPath)
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 { goToQuizView() }
        else if indexPath.row == 1 { goToGameView() }
        //The path to web view is controlled by a segue
        
    }
    
}

//--- MARK: Paths To View Controllers
extension MenuViewController {
    
    //------ Path to Quiz View
    func instantiateQuizView(){
        quizView = storyboard?.instantiateViewController(identifier: "QuizVC") as? QuizViewController
        quizView?.modalPresentationStyle = .fullScreen
    }
    
    func goToQuizView(){
        present(quizView!, animated: true, completion: nil)
    }
    
    //------ Path to Game View
    func instantiateGameView(){
        gameView = storyboard?.instantiateViewController(identifier: "GameVC") as? GameViewController
        gameView?.modalPresentationStyle = .fullScreen
    }
    
    func goToGameView(){
        present(gameView!, animated: true, completion: nil)
    }
    
    //------ Path to Web View
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        let indexPath = menuTableView.indexPathForSelectedRow
        guard indexPath != nil else { return }
        
        if indexPath!.row == 2 {
            //Get a reference to the web view controller
            let webVC = segue.destination as! WebViewController
            
            //Pass the url to the web view controller
            webVC.webUrl = "http://capgirats.cat/"
        }
    }
}
