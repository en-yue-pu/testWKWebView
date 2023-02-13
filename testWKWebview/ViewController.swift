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
        let url = URL(string: "http://169.254.179.138:9999/web5.html")!//这个ip是当前我mac的本地ip
        let request = URLRequest(url: url)
        webView.load(request)

        webView.customUserAgent = "iPhone" //"Chrome/Firefox"//"iPad" iPhone //限定网页显示模式
        webView.navigationDelegate = self
        view.addSubview(webView)
                
        //5秒后 native发送html代码给webView执行,执行结果能取得所有html数据   取得数据打印
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.webView.evaluateJavaScript("document.body.innerHTML") { result , error in
//                guard let self = self else { return }
                guard let html = result as? String, error == nil else { return }
                print(html)//这里包括写在html中的sayHello()函数
//                let newURL = URL(string: "http://localhost:9999/")!
//                let newRequest = URLRequest(url: newURL)
//                self.webView.load(newRequest)
//                self.webView.reload()
//                print("yue webView.stopLoading()执行前", self.webView.isLoading)
//                self.webView.stopLoading()
//                print("yue webView.stopLoading()执行后", self.webView.isLoading)
            }
        }
    }
}

extension ViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("yue webView加载完成", self.webView.isLoading)

        //native 调用webview中间sayHello函数(无参数)
        webView.evaluateJavaScript("sayHello()") { (result, err) in
            //接收到webview中间sayHello函数的return值 (格式是any 有可能error)
            print("native收到webview中sayHello函数的返回值:", result, err)
            self.showToast(message: result as! String)
        }
        
        //native 调用webview中间sayHello函数(包含参数)
        webView.evaluateJavaScript("sayHello2('AAAAAAAAAAAAA')") { (result, err) in
            print("native收到webview中sayHello2函数的返回值:", result, err)
            self.showToast(message: result as! String)
        }
    }

}

extension ViewController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        //看门狗用于接收webView发送的数据message
            if message.name == "hoge" { //筛选message 名称是 hoge的数据
                let str = message.body as! String
                // do something
                print("native收到webView主动发送的message", str)
                self.showToast(message: str)
            }
        }
}

extension ViewController {

func showToast(message : String, font: UIFont = .systemFont(ofSize: 12.0)) {

    let toastLabel = UILabel(frame: CGRect(x: 20, y: self.view.frame.size.height-100, width: self.view.frame.size.width-40, height: 35))
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
