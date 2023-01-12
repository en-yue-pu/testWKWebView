//
//  ViewController.swift
//  testWKWebview
//
//  Created by PU YUE on 2023/01/12.
//

import UIKit
import WebKit

class ViewController: UIViewController {
    
    let webView = WKWebView(frame:UIScreen.main.bounds)

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let url = URL(string: "http://www.google.co.jp")!
        let request = URLRequest(url: url)
        webView.load(request)
        view.addSubview(webView)
        
        //native发送html代码给webView执行,取得数据打印(数据是全网也html)
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.webView.evaluateJavaScript("document.body.innerHTML") { result , error in
                guard let html = result as? String, error == nil else { return }
                print(html)
            }
        }
    }

}

