//
//  ExamWebView.swift
//  MyFirstApp
//
//  Created by 劉俊相 on 2017. 10. 17..
//  Copyright © 2017년 Joonsang Yoo. All rights reserved.
//

import Foundation
import UIKit
class ExamWebView: UIViewController {
    
    @IBOutlet weak var ExamView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let backColor =  UIColor(red: 17.0/255.0, green: 54.0/255.0, blue: 109.0/255.0, alpha: 1.0).cgColor

        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        self.navigationController?.navigationBar.tintColor = UIColor(cgColor: backColor)
        
        // Do any additional setup after loading the view, typically from a nib.
        let tempUrl: String = UserDefault.load(key: UserDefaultKey.UD_tempURL)
        let blankRemove: String = tempUrl.replacingOccurrences(of: "\n    ", with: "")
        let testUrl = URL(string: blankRemove)	// 접속할 링크 주소
        let urq = URLRequest(url: testUrl!)
        // 커맨드+시프트+4(스크린샷)
        //webView.stringByEvaluatingJavaScript(from: <#T##String#>)		// 페이지가 안뜰시 자바스크립트 관련 메소드 (관련설명 링크: http://gorakgarak.tistory.com/805)
        ExamView.loadRequest(urq)
    }
 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
