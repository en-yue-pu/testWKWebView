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
        // Do any additional setup after loading the view.
        let webView = WKWebView(frame:UIScreen.main.bounds)
        let url = URL(string: "http://www.google.co.jp")!
        let request = URLRequest(url: url)
        webView.load(request)
        self.webView = webView
        view.addSubview(webView)
        
        //native发送html代码给webView执行,取得数据打印(数据是全网也html)
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            //这里有个小坑,要用self.webView不能用webView因为viewDidLoad()函数执行完了实例消失,闭包里面是弱引用,所以webView会消失,事先传到到外界的webView因为class级别的引用还在所以没事
            //DispatchQueue在专用线程上不会消失
            self.webView.evaluateJavaScript("document.body.innerHTML") { result , error in
                guard let html = result as? String, error == nil else { return }
                print(html)
            }
        }
    }

}

