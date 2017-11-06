//
//  InfoWebView.swift
//  MyFirstApp
//
//  Created by 劉俊相 on 2017. 9. 4..
//  Copyright © 2017년 Joonsang Yoo. All rights reserved.
//


import UIKit

class InfoWebView: UIViewController {
    
    
    
    @IBOutlet weak var webView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let testUrl = URL(string: "http://www.gilhospital.com/phr/guide.html?id=")	// 접속할 링크 주소
        let urq = URLRequest(url: testUrl!)
        // 커맨드+시프트+4(스크린샷)
        //webView.stringByEvaluatingJavaScript(from: <#T##String#>)		// 페이지가 안뜰시 자바스크립트 관련 메소드 (관련설명 링크: http://gorakgarak.tistory.com/805)
        webView.loadRequest(urq)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

