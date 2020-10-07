//
//  StateManager.swift
//  CapgirApp
//
//  Created by Laura Homet Garcia on 30/08/2020.
//  Copyright © 2020 LauraHomet. All rights reserved.
//

import Foundation

class StateManager {
    
    static var numCorrectKey = "NumberCorrectKey"
    static var questionIndexKey = "QuestionIndexKey"
    
    static func saveState(numCorrect:Int, questionIndex:Int) {
        
       let defaults = UserDefaults.standard
       
       defaults.set(numCorrect, forKey: numCorrectKey)
       defaults.set(questionIndex, forKey: questionIndexKey)
    }
    
    static func retrieveValue(key:String) -> Any? {
        let defaults = UserDefaults.standard
        return defaults.value(forKey: key)
    }
    
    static func clearState() {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: numCorrectKey)
        defaults.removeObject(forKey: questionIndexKey)
    }
    
}
