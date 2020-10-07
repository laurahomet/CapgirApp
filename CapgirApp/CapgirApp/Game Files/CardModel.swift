//
//  CardModel.swift
//  MatchApp
//
//  Created by Laura Homet Garcia on 14/05/2020.
//  Copyright © 2020 LauraHomet. All rights reserved.
//

import Foundation

class CardModel {
    
    func getCards() -> [Card] {
        
        // Declare an empty array
        var generatedCards = [Card]()
        var generatedRandomNumbers = [Int]()
        
        // Randomly generate 8 pairs of cards
        while generatedRandomNumbers.count < 8 {
            
            // Generate a random number
            let randomNumber = Int.random(in: 1...16)
            
            // Create two new card objects
            let cardOne = Card()
            let cardTwo = Card()
            
            // Set their image names
            cardOne.imageName = "card\(randomNumber)"
            cardTwo.imageName = "card\(randomNumber)"
            
            // Check if the cards are already in the array
            if !generatedRandomNumbers.contains(randomNumber) {
                // Add the cards to the generatedCards array
                generatedCards += [cardOne, cardTwo]
                
                // Add the randomNumber to the generatedRandomNumbers array
                generatedRandomNumbers.append(randomNumber)
            }
        }
        
        // Randomize the cards within the array
        generatedCards.shuffle()
        
        // Return the array
        return generatedCards
    }
    
}
