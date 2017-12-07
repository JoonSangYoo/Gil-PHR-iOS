//
//  ViewController.swift
//  MyFirstApp
//
//  Created by 金学基 on 2017. 6. 28..
//  Copyright © 2017년 Joonsang Yoo. All rights reserved.
//

import UIKit
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
                    UserDefault.save(key: UserDefaultKey.UD_Key, value: self.loginData[0])
                    UserDefault.save(key: UserDefaultKey.UD_Ptntno, value: self.loginData[2])
                    UserDefault.save(key: UserDefaultKey.UD_Ptntnm, value: self.loginData[4])
                    UserDefault.save(key: UserDefaultKey.UD_Staffyn, value: self.loginData[6])
                    UserDefault.save(key: UserDefaultKey.UD_id, value: self.idField.text!)
                    self.loginData = [String]()
                    self.performSegue(withIdentifier: "segMain", sender: self)
                    
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
        
        //최근 진료내역 초기화
        lastdeptcd = ""  //진료과코드
        lastdeptnm = ""   //진료과명
        lastdate = ""     //진료일
        lastdocno = ""    //의사코드
        lastdocnm = ""        //의사명
        lastesp = ""      // 특진 구분
        lastmain = ""        //진료분야
        plag_rec = 0
        //알림 권한 허용
        let app = UIApplication.shared
        
        let notificationSettings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
        
        app.registerUserNotificationSettings(notificationSettings)
        //----
        recentItem = [recentlist]()
        idField = self.view.viewWithTag(loginTag + 1) as? UITextField
        pwField = self.view.viewWithTag(loginTag + 2) as? UITextField
        
        idField?.addBorderBottom(height: 1.0, color: UIColor.lightGray)
        idField?.placeholder = "아이디"
        idField?.becomeFirstResponder()
        idField.delegate = self
        
        pwField?.addBorderBottom(height: 1.0, color: UIColor.lightGray)
        pwField?.placeholder = "비밀번호"
        pwField.delegate = self
        //border.borderColor = UIColor( red: 32.0/255, green: 53.0/255, blue:88.0/255, alpha: 1.0 ).CGColo
        
        // Do any additional setup after loading the view, typically from a nib.
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
            loginData.append(string)
        case "ptntno":
            loginData.append(string)
        case "ptntnm":
            loginData.append(string)
        case "emplyn":
            loginData.append(string)
        default:break
        }
    }
    
    
    func loginFail() -> Void {
        let alert = UIAlertController(title: "로그인 실패", message: "아이디와 비밀번호를 확인해주세요.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "닫기", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
   
    /*
    func myTargetEditingDidBeginFunction(textField: UITextField) {
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        // do your stuff
    }

    
    func keyboardWillShow(notification: NSNotification) {
        //if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= 100
          //  }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        //if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += 100
         //   }
        }
    }
 
 */
   
}

