//
//  MenuModel.swift
//  CapgirApp
//
//  Created by Laura Homet Garcia on 29/08/2020.
//  Copyright © 2020 LauraHomet. All rights reserved.
//

import Foundation

class MenuModel {
    
    func getMenu() -> [MenuOption] {
        
        let quiz = MenuOption()
        let game = MenuOption()
        
        quiz.imageName = "QuizIcon"
        quiz.text = "Qüestionari"
        
        game.imageName = "GameIcon"
        game.text = "Joc"
        
        return [quiz,game]
        
    }
    
}
