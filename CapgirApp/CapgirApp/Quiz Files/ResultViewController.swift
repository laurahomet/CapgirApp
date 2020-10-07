//
//  ResultViewController.swift
//  CapgirApp
//
//  Created by Laura Homet Garcia on 30/08/2020.
//  Copyright © 2020 LauraHomet. All rights reserved.
//

import UIKit

protocol ResultViewControllerProtocol {
    func dialogDismissed()
}

class ResultViewController: UIViewController {
    
    @IBOutlet weak var dimView: UIView!
    @IBOutlet weak var dialogView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dismissButton: UIButton!
    
    var titleText = ""
    var buttonText = ""
    
    var delegate:ResultViewControllerProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dialogView.layer.cornerRadius = 10
    }
    
    override func viewWillAppear(_ animated: Bool) {

        //Set the text
        titleLabel.text = titleText
        dismissButton.setTitle(buttonText, for: .normal)
        
        //Hide UI Elements
        dimView.alpha = 0
        titleLabel.alpha = 0
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        //Fade in UI Elements
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            self.dimView.alpha = 1
            self.titleLabel.alpha = 1
        }, completion: nil)
    }
    
    @IBAction func dismissTapped(_ sender: Any) {
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            self.dimView.alpha = 0
            self.titleLabel.alpha = 0
        }) { (completed) in
            self.dismiss(animated: true, completion: nil)
            self.delegate?.dialogDismissed()
        }
    
    }
}
