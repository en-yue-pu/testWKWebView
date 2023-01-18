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

        let url = URL(string: "http://localhost:9999/web2.html")!
        let request = URLRequest(url: url)
        webView.load(request)
        webView.customUserAgent = "iPhone" //"Chrome/Firefox"//"iPad" iPhone //限定网页显示模式
        
        webView.navigationDelegate = self
        
        view.addSubview(webView)
                
        //native发送html代码给webView执行,取得数据打印(数据是全网也html)
//        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
//            self.webView.evaluateJavaScript("document.body.innerHTML") { result , error in
//                guard let html = result as? String, error == nil else { return }
//                print(html)
//            }
//        }
    }
}

extension ViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        /* 载入结束就
        native调用webview 里面的sayHello()函数,参数是一个string(native发送给webView)
         */
        webView.evaluateJavaScript("sayHello('native发送给webView')") { (result, err) in
            print("native > webview の　callback:", result, err)
        }
    }
    
    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge) {
        print("######")
    }
}

extension ViewController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        //接收webView发送的数据message.body
            if message.name == "hoge" {
                let str = message.body as! String
                // do something
                print("webView > native:", str)
                self.showToast(message: str)
            }
        }
}

extension ViewController {

func showToast(message : String, font: UIFont = .systemFont(ofSize: 12.0)) {

    let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-100, width: 150, height: 35))
    toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
    toastLabel.textColor = UIColor.white
    toastLabel.font = font
    toastLabel.textAlignment = .center;
    toastLabel.text = message
    toastLabel.alpha = 1.0
    toastLabel.layer.cornerRadius = 10;
    toastLabel.clipsToBounds  =  true
    self.view.addSubview(toastLabel)
    UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
         toastLabel.alpha = 0.0
    }, completion: {(isCompleted) in
        toastLabel.removeFromSuperview()
    })
} }
