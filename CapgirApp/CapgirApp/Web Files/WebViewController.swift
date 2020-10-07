//
//  WebViewController.swift
//  CapgirApp
//
//  Created by Laura Homet Garcia on 29/08/2020.
//  Copyright © 2020 LauraHomet. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    
    @IBOutlet weak var webVIew: WKWebView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var webUrl:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webVIew.navigationDelegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //Check that there's a url
        if webUrl != "" {
            //Create URL object
            let url = URL(string: webUrl)
            guard url != nil else { return }
            
            //Create the URL Request object
            let request = URLRequest(url: url!)
            
            //Start spinning
            spinner.alpha = 1
            spinner.startAnimating()
            
            //Load it in the webview
            webVIew.load(request)
        }
    }
}

extension WebViewController: WKNavigationDelegate {

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        spinner.stopAnimating()
        spinner.alpha = 0
    }
}
