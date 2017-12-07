//
//  PsnSave.swift
//  MyFirstApp
//
//  Created by 劉俊相 on 2017. 12. 5..
//  Copyright © 2017년 Joonsang Yoo. All rights reserved.
//

import Foundation

class PsnSave: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, XMLParserDelegate {
    

    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var heightField: UITextField!
    @IBOutlet weak var weightField: UITextField!
    @IBOutlet weak var algView: UITextView!
    @IBOutlet weak var drugView: UITextView!
    
    var parser = XMLParser()        // 파서 객체
    var currentElement = ""       // 현재 Element
    var st = ""                 // 스테이터스 값 변수
    var psnData = [String]()
   
    var blood = String()
    var height = String()
    var weight = String()
    var alg = String()
    var drug = String()
    

    let bloodType = ["A", "B", "O", "AB", "A(Rh-)", "B(Rh-)", "O(Rh-)", "AB(Rh-)"]
    

    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
  
            return bloodType[row]
        }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return bloodType.count

    }

    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(bloodType[row])
        
        
    }
    
    struct xmlWriter {             // xml 작성을 위한 구조체
        var prtc: String
        
        init(prtc: String) {
            self.prtc = prtc
        }
        
        func xmlString() -> String {
            
            var xml = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
            xml += "<request>"
            xml += "<protocol>\(self.prtc)</protocol>"
            xml += "<userid>\(UserDefault.load(key: UserDefaultKey.UD_id))</userid>"
            xml += "<keycd>\(UserDefault.load(key: UserDefaultKey.UD_Key))</keycd>"
            xml += "</request>"
            
            //      for number in self.trackingNumbers {
            //                xml += "<TrackingNumber>\(number)</TrackingNumber>"
            //    }
            
            
            return xml
        }
    }
    
    struct xmlWriter2 {             // xml 작성을 위한 구조체
        var prtc: String
        var bloodType: String
        var height: String
        var weight: String
        var alg: String
        var drug: String
        
        init(prtc: String, bloodType: String, height: String, weight: String, alg: String, drug: String) {
            self.prtc = prtc
            self.bloodType = bloodType
            self.height = height
            self.weight = weight
            self.alg = alg
            self.drug = drug
        }
        
        func xmlString() -> String {
            
            var xml = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
            xml += "<request>"
            xml += "<protocol>\(self.prtc)</protocol>"
            xml += "<userid>\(UserDefault.load(key: UserDefaultKey.UD_id))</userid>"
            xml += "<keycd>\(UserDefault.load(key: UserDefaultKey.UD_Key))</keycd>"
            xml += "<bloodtype>\(self.bloodType)</bloodtype>"
            xml += "<height>\(self.height)</height>"
            xml += "<weight>\(self.weight)</weight>"
            xml += "<alg>\(self.alg)</alg>"
            xml += "<drug>\(self.drug)</drug>"
            xml += "</request>"
     
            
            return xml
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBarController?.tabBar.isHidden = true
        
        
        // Do any additional setup after loading the view, typically from a nib.
        
        let postString = xmlWriter(prtc: "getphr").xmlString()
        _ = HttpClient.requestXML(Xml: postString){ responseString in
            // print(responseString)
            let dataXML = responseString.data(using: .utf8)
            
            self.parser = XMLParser(data: dataXML!)
            self.parser.delegate = self
            
            let success:Bool = self.parser.parse()
            if success {
                print("parse success!")
                
                if self.st == "100"{        // 리스폰스 스테이터스가 100(성공)일때
                    // DispatchQueue.main.async -> ui가 대기상태에서 특정 조건에서 화면전환시 멈추는 현상을 없애기 위한 명령어(비동기제어)
                    DispatchQueue.main.async{
                        print(self.psnData.count)
                        self.pickerView.selectRow(Int(self.blood)!, inComponent: 0, animated: true)
//                        if self.psnData.count>5{
//                            self.heightField.text = self.psnData[2]
//                        }
//                        if self.psnData.count>6{
//                            self.weightField.text = self.psnData[4]
//                        }
//                        if self.psnData.count>7{
//                             self.algView.text = self.psnData[6]
//                        }
//                        if self.psnData.count>8{
//                            self.drugView.text = self.psnData[8]
//                        }
                        self.heightField.text = self.height
                        self.weightField.text = self.weight
                        self.algView.text = self.alg
                        self.drugView.text = self.drug
                        print(self.drug.index(of: "\n"))
                        

                     
                    }
                } else{         // 리스폰스 스테이터스 100이 아닐때 (ex: 200번(실패) 3~500번 등등 추가조건 구현가능)
                    DispatchQueue.main.async{
                        
                    }
                }
            } else{
                print("parse failure!")
            }
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveButton(_ sender: Any) {
        print(bloodType[pickerView.selectedRow(inComponent: 0)])
        print(self.heightField.text)
        print(self.weightField.text)
        print(self.algView.text)
        print(self.drugView.text)
        
        
        let postString = xmlWriter2(prtc: "setphr", bloodType: String(pickerView.selectedRow(inComponent: 0)), height: self.heightField.text!, weight: self.weightField.text!, alg: self.algView.text, drug: self.drugView.text).xmlString()
        _ = HttpClient.requestXML(Xml: postString){ responseString in
            // print(responseString)
            let dataXML = responseString.data(using: .utf8)
            
            self.parser = XMLParser(data: dataXML!)
            self.parser.delegate = self
            
            let success:Bool = self.parser.parse()
            if success {
                print("parse success!")
                
                if self.st == "100"{        // 리스폰스 스테이터스가 100(성공)일때
                    // DispatchQueue.main.async -> ui가 대기상태에서 특정 조건에서 화면전환시 멈추는 현상을 없애기 위한 명령어(비동기제어)
                    DispatchQueue.main.async{
                        let alert = UIAlertController(title: "저장 성공", message: "정보가 저장되었습니다!", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "닫기", style: UIAlertActionStyle.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                        
                    }
                } else{         // 리스폰스 스테이터스 100이 아닐때 (ex: 200번(실패) 3~500번 등등 추가조건 구현가능)
                    DispatchQueue.main.async{
                    }
                }
            } else{
                print("parse failure!")
            }
        }
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Hide the navigation bar on the this view controller
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.tintColor = UIColor.primaryColor
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
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
            
        case "bloodtype":
            if string != "\n  "{
                blood = string
                psnData.append(string)
            }

        case "height":
            if string != "\n  "{
            height = string
            psnData.append(string)
            }
        case "weight":
            if string != "\n  "{
            weight = string
            psnData.append(string)
            }
        case "alg":
            if string != "\n  "{
            alg = string
            psnData.append(string)
            }

        case "drug":
            if string != "\n"{
            drug = string
            psnData.append(string)
            }
        default:break
            
        }
        
        
    }

}

extension String {
    public func index(of char: Character) -> Int? {
        if let idx = characters.index(of: char) {
            return characters.distance(from: startIndex, to: idx)
        }
        return nil
    }
}

