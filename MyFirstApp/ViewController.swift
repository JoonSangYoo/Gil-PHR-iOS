//
//  ViewController.swift
//  MyFirstApp
//
//  Created by 金学基 on 2017. 6. 28..
//  Copyright © 2017년 Joonsang Yoo. All rights reserved.
//

import UIKit
import DLRadioButton
import UserNotifications

extension UITextField {
    
    func addBorderBottom(height: CGFloat, color: UIColor) {
        let border = CALayer()
        border.frame = CGRect(x: 0, y: self.frame.height-height, width: self.frame.width, height: height)
        border.backgroundColor = color.cgColor
        self.layer.addSublayer(border)
    }
}

class ViewController: UIViewController, UITextFieldDelegate, XMLParserDelegate {
    
    let loginTag = TagNumList.loginTag
    
    var idField: UITextField!
    var pwField: UITextField!
    var parser = XMLParser()
    
    var currentElement = ""                // Element
    var loginData = [String]()
    var pubTitle = ""
    var contents = ""
    var st = ""
    
    var keyCD = String()
    var ptntNO = String()
    var ptntNM = String()
    var firstLogin = String()
    var ptntFound = String()
    var staffYN = String()
    var ptntURL = String()
    
    
    @IBOutlet weak var idCheck: DLRadioButton!
    
    
    func loginAttempt() -> Void {
        
        let postString = loginRequest(userid: idField.text!, pwd: pwField.text!).xmlString()
        
        _ = HttpClient.requestXML(Xml: postString){ responseString in
           // print(responseString)
            let dataXML = responseString.data(using: .utf8)
            
            self.parser = XMLParser(data: dataXML!)
            self.parser.delegate = self
            
            let success:Bool = self.parser.parse()
            if success {
                print("parse success!")

                if self.st == "100"{
                DispatchQueue.main.async{
                    print(self.ptntNM)
                    print(self.ptntNO)
                    print(self.staffYN)
                    print(self.ptntURL)
                    print(self.ptntFound)
                    UserDefault.save(key: UserDefaultKey.UD_Key, value: self.keyCD)
                    UserDefault.save(key: UserDefaultKey.UD_Ptntno, value: self.ptntNO)
                    UserDefault.save(key: UserDefaultKey.UD_Ptntnm, value: self.ptntNM)
                    UserDefault.save(key: UserDefaultKey.UD_Staffyn, value: self.staffYN)
                    UserDefault.save(key: UserDefaultKey.UD_id, value: self.idField.text!)
                    
                    if self.firstLogin == "N"{
                        self.performSegue(withIdentifier: "segMain", sender: self)

                    } else{
                        UIApplication.shared.open(URL(string: "https://www.gilhospital.com/phr/findptntno.html?id=\(UserDefault.load(key: UserDefaultKey.UD_id))&keycd=\(UserDefault.load(key: UserDefaultKey.UD_Key))")!, options: [:], completionHandler: nil)
                    }
                    self.loginData = [String]()
                    self.keyCD = String()
                    self.ptntNO = String()
                    self.ptntNM = String()
                    self.firstLogin = String()
                    self.ptntFound = String()
                    self.staffYN = String()
                    self.ptntURL = String()
                    
                    }
                } else{
                    DispatchQueue.main.async{

                    self.loginFail()
                    }
                }
            } else{
                print("parse failure!")
            }
            
        }
        
        
    }
    
    struct loginRequest {
        
        var userid: String
        var pwd: String
        
        init(userid: String, pwd: String) {
            self.userid = userid
            self.pwd = pwd
        }
        
        func xmlString() -> String {
            var xml = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
            xml += "<request>"
            xml += "<protocol>login</protocol>"
            xml += "<userid>\(userid)</userid>"
            xml += "<pwd>\(pwd)</pwd>"
            //xml += "<userid>wnstkd13</userid>"
            //xml += "<pwd>test5782</pwd>"
            xml += "</request>"
            
            
            return xml
        }
    }
    @IBAction func loginButton(_ sender: UIButton) {
        
    
        if (idField.text == "" || pwField.text! == "") {
            DispatchQueue.main.async{
                self.loginFail()
            }
        }else{
            DispatchQueue.main.async{
                self.loginAttempt()
            }
        }
    }
    
  
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.idCheck.isMultipleSelectionEnabled = true

        recentItem = [recentlist]()
        idField = self.view.viewWithTag(loginTag + 1) as? UITextField
        pwField = self.view.viewWithTag(loginTag + 2) as? UITextField
        
        idField?.addBorderBottom(height: 1.0, color: UIColor.lightGray)
        idField?.placeholder = "아이디"
        idField.delegate = self
        
        pwField?.addBorderBottom(height: 1.0, color: UIColor.lightGray)
        pwField?.placeholder = "비밀번호"
        pwField.delegate = self
        

        // Do any additional setup after loading the view, typically from a nib.
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        self.idField?.text = ""
        self.pwField?.text = ""
        if UserDefault.load(key: UserDefaultKey.UD_IDcheck) == "1"{
            if self.idCheck.isSelected == false{
                self.idCheck.isSelected = true
            }
            idField?.text = UserDefault.load(key: UserDefaultKey.UD_id)
            pwField?.becomeFirstResponder()
        } else {
            idField?.becomeFirstResponder()
            
        }
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if  textField == self.idField { // Switch focus to other text field
            self.pwField.becomeFirstResponder()
            self.view.frame.origin.y = -150 // Move view 150 points upward

            
        } else if textField == self.pwField{
            self.view.frame.origin.y = 0 // Move view to original position
            loginAttempt()

        }
        return true
    }
    // XML 파서가 시작 테그를 만나면 호출됨
    public func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:])
    {
        currentElement = elementName
    
        if (elementName == "response") {
            st = attributeDict["status"]!
            
        }
    }
    
    
    // 현재 테그에 담겨있는 문자열 전달
    public func parser(_ parser: XMLParser, foundCharacters string: String)
    {
        switch currentElement {
        case "keycd":
            if string != "\n  "{
                keyCD = string
            }
            loginData.append(string)
        case "ptntno":
            if string != "\n  "{
                ptntNO = string
            }
            loginData.append(string)
        case "ptntnm":
            if string != "\n  "{
                ptntNM = string
            }
            loginData.append(string)
        case "firstlogin":
            if string != "\n  "{
                firstLogin = string
            }
            loginData.append(string)
        case "ptntnofound":
            if string != "\n  "{
                ptntFound = string
            }
            loginData.append(string)
        case "emplyn":
            if string != "\n  "{
                staffYN = string
            }
            loginData.append(string)
        case "ptntnofindurl":
            if string != "\n  "{
                ptntURL = string
            }
            loginData.append(string)

        default:break
        }
    }
    
    
    func loginFail() -> Void {
        let alert = UIAlertController(title: "로그인 실패", message: "아이디와 비밀번호를 확인해주세요.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "닫기", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func idFind(_ sender: Any) {
        UIApplication.shared.open(URL(string: "https://www.gilhospital.com/phr/find_id.html")!, options: [:], completionHandler: nil)
    }
   
    @IBAction func pwFind(_ sender: Any) {
        UIApplication.shared.open(URL(string: "https://www.gilhospital.com/phr/findpw_mail.html")!, options: [:], completionHandler: nil)
    }
    
    @IBAction func join(_ sender: Any) {
         UIApplication.shared.open(URL(string: "https://www.gilhospital.com/phr/member_gubun.html")!, options: [:], completionHandler: nil)
    }
    
    @IBAction func idCheck(_ sender: Any) {
        if self.idCheck.isSelected{
            UserDefault.save(key: UserDefaultKey.UD_IDcheck, value: "1")
        } else {
            UserDefault.save(key: UserDefaultKey.UD_IDcheck, value: "0")

        }
    }

}

