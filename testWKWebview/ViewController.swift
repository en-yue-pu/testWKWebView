//
//  ViewController.swift
//  testWKWebview
//
//  Created by PU YUE on 2023/01/12.
//

import UIKit
import WebKit

class ViewController: UIViewController {
    
    var webView: WKWebView!


    override func viewDidLoad() {
        super.viewDidLoad()
        
        let webConfig: WKWebViewConfiguration = WKWebViewConfiguration()
        let userController: WKUserContentController = WKUserContentController()
        userController.add(self, name: "hoge")
        webConfig.userContentController = userController
        webView = WKWebView(frame:  UIScreen.main.bounds, configuration: webConfig)

        let url = URL(string: "http://localhost:9999/web1.html")!
        let request = URLRequest(url: url)
        webView.load(request)
        webView.customUserAgent = "iPhone" //"Chrome/Firefox"//"iPad" iPhone //限定网页显示模式
        
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

extension ViewController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
            if message.name == "hoge" {
                let str = message.body as! String
                // do something
                print("$$$$$$$$$$$", str)
            }
        }
}

