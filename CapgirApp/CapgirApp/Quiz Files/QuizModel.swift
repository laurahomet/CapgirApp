//
//  QuizModel.swift
//  CapgirApp
//
//  Created by Laura Homet Garcia on 29/08/2020.
//  Copyright © 2020 LauraHomet. All rights reserved.
//

import Foundation

protocol QuizProtocol {
    //Requirements
    func questionsRetrieved(_ question:[Question])
}

class QuizModel {
    
    var delegate:QuizProtocol?
    
    func getQuestions() {
        
        //Fetch the questions
        getLocalJsonFile()
        
    }
    
    func getLocalJsonFile() {
        
        //Get bundle path to json file
        let path = Bundle.main.path(forResource: "Questionari", ofType: "json")
        guard path != nil else { return }
        
        //Create URL object from the path
        let url = URL(fileURLWithPath: path!)
        
        do {
            //Get the data from the URL
            let data = try Data(contentsOf: url)
            
            //Try to decode the data into objects
            let decoder = JSONDecoder()
            let array = try decoder.decode([Question].self, from: data)
            
            //Notify delegate
            delegate?.questionsRetrieved(array)
            
        } catch {
            //Error: Couldn´t download the data at that URL
        }
    }
}
