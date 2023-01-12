//
//  ViewController.swift
//  testWKWebview
//
//  Created by PU YUE on 2023/01/12.
//

import UIKit
import WebKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let webView = WKWebView(frame:UIScreen.main.bounds)
        let url = URL(string: "http://www.google.co.jp")!
        let request = URLRequest(url: url)
        webView.load(request)
        view.addSubview(webView)
    }


}

