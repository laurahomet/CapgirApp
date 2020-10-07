//
//  ViewController.swift
//  CapgirApp
//
//  Created by Laura Homet Garcia on 29/08/2020.
//  Copyright © 2020 LauraHomet. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var somhiButton: UIButton!
    
    var menuView:MenuViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        somhiButton.layer.cornerRadius = 10
        instantiateMenuView()
    }
    
    
    @IBAction func somhiTapped(_ sender: Any) {
        //When user taps button, go to menu view
        if menuView != nil { goToMenuView() }
    }

}

//--- MARK: Path To Menu View Controller
extension ViewController {
    
    //------ Path to Menu View
    func instantiateMenuView(){
        menuView = storyboard?.instantiateViewController(identifier: "MenuVC") as? MenuViewController
        menuView?.modalPresentationStyle = .fullScreen
    }
    
    func goToMenuView(){
        present(menuView!, animated: true, completion: nil)
    }
    
}
