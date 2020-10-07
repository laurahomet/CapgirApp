//
//  QuizViewController.swift
//  CapgirApp
//
//  Created by Laura Homet Garcia on 29/08/2020.
//  Copyright © 2020 LauraHomet. All rights reserved.
//

import UIKit

class QuizViewController: UIViewController, QuizProtocol, UITableViewDelegate, UITableViewDataSource, ResultViewControllerProtocol {
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var quizTableView: UITableView!
    
    @IBOutlet weak var stackViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var stackViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var rootStackView: UIStackView!
    
    var model = QuizModel()
    var questions = [Question]()
    var currentQuestionIndex = 0
    var numCorrect = 0
    var dialogText = ""
    var dialogButtonText = "Següent"
    
    var resultDialog:ResultViewController?
    var menuView:MenuViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        quizTableView.delegate = self
        quizTableView.dataSource = self
        
        model.delegate = self
        model.getQuestions()
        
        instantiateResultView()
        resultDialog?.delegate = self
        
        instantiateMenuView()
    }
    
    func slideInQuestion() {
        //Set initial state
        stackViewLeadingConstraint.constant = -1000
        stackViewTrailingConstraint.constant = -1000
        view.layoutIfNeeded()
        
        //Animate
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            self.stackViewLeadingConstraint.constant = 0
            self.stackViewTrailingConstraint.constant = 0
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    func slideOutQuestion() {
        //Set initial state
        stackViewLeadingConstraint.constant = 0
        stackViewTrailingConstraint.constant = 0
        view.layoutIfNeeded()
        
        //Animate
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            self.stackViewLeadingConstraint.constant = -1000
            self.stackViewTrailingConstraint.constant = -1000
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    func displayQuestion() {
        //Check if there are questions and currentQuestionIndex is not aout of bounds
        guard questions.count > 0 && currentQuestionIndex < questions.count else {
            return
        }
        
        questionLabel.text = questions[currentQuestionIndex].question!
        
        //Reload tableView
        quizTableView.reloadData()
        
        //Slide in the next question
        slideInQuestion()
    }
    
    //--- MARK: Quiz Protocol Methods
    func questionsRetrieved(_ questions: [Question]){
        
        //Get a reference to the questions
        self.questions = questions
        
        //Check if we should restore the state before showing question 1
        let savedIndex = StateManager.retrieveValue(key: StateManager.questionIndexKey) as? Int
        
        if savedIndex != nil && savedIndex! < self.questions.count {
            
            currentQuestionIndex = savedIndex!
            
            let savedNumCorrect = StateManager.retrieveValue(key: StateManager.numCorrectKey) as? Int
            
            if savedNumCorrect != nil {
                numCorrect = savedNumCorrect!
            }
        }
        
        //Display question
        displayQuestion()
        
    }
    
    //--- MARK: Table View Protocol Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard questions.count > 0 else { return 0 }
        
        let currentQuestion = questions[currentQuestionIndex]
        
        if currentQuestion.answers != nil {
            return currentQuestion.answers!.count
        } else { return 0 }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = quizTableView.dequeueReusableCell(withIdentifier: "AnswerCell", for: indexPath)
        
        let label = cell.viewWithTag(1) as? UILabel
        
        if label != nil {
            //Set the answer text
            let question = questions[currentQuestionIndex]
            
            if question.answers != nil && indexPath.row < question.answers!.count {
                label!.text = question.answers![indexPath.row]
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let question = questions[currentQuestionIndex]
        
        if indexPath.row == question.correctAnswerIndex {
            //User got it right
            dialogText = "Correcte!"
            numCorrect += 1
        } else {
            //User got it wrong
            dialogText = "Incorrecte!"
            
        }
        
        //Slide out question (main thread)
        DispatchQueue.main.async { self.slideOutQuestion() }
        
        //Show the popup
        if resultDialog != nil {
            goToResultView()
        }
        
    }
    
    //--- MARK: Result View Controller Protocol Methods
    func dialogDismissed() {
        
        //Increment current question index
        currentQuestionIndex += 1
        
        if currentQuestionIndex == questions.count {
            //Show summary dialog
            dialogText = "Has encertat \(numCorrect) de \(questions.count) preguntes!"
            dialogButtonText = "Torna al menú principal"
            goToResultView()
            
        } else if (currentQuestionIndex > questions.count) {
            currentQuestionIndex = 0
            numCorrect = 0
            StateManager.clearState()
            goToMenuView()
            
        } else {
            //Display next question
            displayQuestion()
            
            //Save state
            StateManager.saveState(numCorrect: numCorrect, questionIndex: currentQuestionIndex)
        }
        
    }
    

}

//--- MARK: Path To Result View Controller
extension QuizViewController {
    
    //------ Path to Menu View
    func instantiateResultView(){
        resultDialog = storyboard?.instantiateViewController(identifier: "ResultVC") as? ResultViewController
        resultDialog?.modalPresentationStyle = .overCurrentContext
    }
    
    func goToResultView(){
        resultDialog!.titleText = dialogText
        resultDialog!.buttonText = dialogButtonText
        present(resultDialog!, animated: true, completion: nil)
    }
    
}

//--- MARK: Path To Menu View Controller
extension QuizViewController {
    
    //------ Path to Menu View
    func instantiateMenuView(){
        menuView = storyboard?.instantiateViewController(identifier: "MenuVC") as? MenuViewController
        menuView?.modalPresentationStyle = .fullScreen
    }
    
    func goToMenuView(){
        present(menuView!, animated: true, completion: nil)
    }
    
}


