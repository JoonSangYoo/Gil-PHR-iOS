 //
 //  Detail_doctor.swift
 //  MyFirstApp
 //
 //  Created by 조윤성 on 2017. 10. 30..
 //  Copyright © 2017년 Joonsang Yoo. All rights reserved.
 //
 
 import Foundation
 import UIKit
 
 var doctor_index = 0

 var doctorlist = [doctorList]() // 의사 목록 출력 내용 array
 
 class Detail_doctor : UIViewController, XMLParserDelegate, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var DoctorTB: UITableView!
    
    var parser = XMLParser()        // 파서 객체
    
    var currentElement = ""       // 현재 Element
    
    
    var docs = String()           //의사목록
    var doc = String()        // 의사
    var docno = String()         // 의사직원코드
    var docnm = String()       // 의사 이름
    var esp = String()        //특진구분
    var main = String()        //진료분야
    
    var st = ""                 // 스테이터스 값 변수≈
    var docnmLB: UILabel!
    var espLB: UILabel!
    var mainLB: UILabel!
    var doc_pic: UIImageView!
    
    override func viewDidLoad() {
//        if(plag_rec == 1  && reserve_index == 0){
//            performSegue(withIdentifier: "Detail_date" , sender: self)
//        }
        self.navigationController?.navigationBar.isHidden = true
        super.viewDidLoad()
        doctorlist = [doctorList]()
        self.title = deptlist[reserve_index-1].deptnm
        let postString = xmlWriter(prtc: "deptdocs").xmlString()
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
                        self.DoctorTB.dataSource = self
                        self.DoctorTB.delegate = self
                        self.DoctorTB.reloadData()
                        self.DoctorTB.tableFooterView = UIView()
                        
                    }
                    
                }
                else if self.st == "202"{
                    DispatchQueue.main.async{
                        //self.DoctorTB.isHidden = true
                    }
                }
                else{         // 리스폰스 스테이터스 100이 아닐때 (ex: 200번(실패) 3~500번 등등 추가조건 구현가능)
                    DispatchQueue.main.async{
                        
                    }
                }
            } else{
                print("parse failure!")
            }
        }
        DoctorTB.rowHeight = 140
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.tabBarController?.tabBar.isHidden = true
        //self.navigationController?.navigationBar.isHidden = true
        let background_color =  UIColor(red: 204/255.0, green: 221/255.0, blue: 252/255.0, alpha: 1.0).cgColor
        self.navigationController?.navigationBar.backgroundColor = UIColor(cgColor: background_color)
        self.navigationController?.navigationBar.tintColor = UIColor .black
    }
    
    struct xmlWriter {             // xml 작성을 위한 구조체
        var prtc: String
        
        init(prtc: String) {
            self.prtc = prtc
        }
        
        func xmlString() -> String {
            let xml_deptcd: String = deptlist[reserve_index-1].deptcd.replacingOccurrences(of: "\n  ", with: "")
            var xml = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
            xml += "<request>"
            xml += "<protocol>\(self.prtc)</protocol>"
            xml += "<userid>\(UserDefault.load(key: UserDefaultKey.UD_id))</userid>"
            xml += "<keycd>\(UserDefault.load(key: UserDefaultKey.UD_Key))</keycd>"
            xml += "<deptcd>\(xml_deptcd)</deptcd>"
            xml += "</request>"
            return xml
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // XML 파서가 시작 테그를 만나면 호출됨
    public func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:])
    {
        currentElement = elementName
        
        if (elementName == "response") {
            st = attributeDict["status"]!
            
        }
        
        if (elementName == "doc") {           //의사목록
            //doc = String()        // 의사
            docno = String()         // 의사직원코드
            docnm = String()       // 의사 이름
            esp = String()        //특진구분
            main = String()        //진료분야
            
        }
        
    }
    
    // XML 파서가 종료 테그를 만나면 호출됨
    public func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?)
    {
        if (elementName == "doc") {
            let DocItem = doctorList()
            
            DocItem.docno = docno       // 의사직원코드
            DocItem.docnm = docnm     // 의사 이름
            DocItem.esp = esp      //특진구분
            DocItem.main = main      //진료분야
            
            doctorlist.append(DocItem)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return doctorlist.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "docCell")!
        var esp_Text = ""
        docnmLB = cell.viewWithTag(37) as! UILabel
        espLB = cell.viewWithTag(38) as! UILabel
        mainLB = cell.viewWithTag(39) as! UILabel
        doc_pic = cell.viewWithTag(40) as! UIImageView
        
        let doctoritem = doctorlist[indexPath.row]
        
        let rep_esp: String = doctoritem.esp.replacingOccurrences(of: "\n      ", with: "")
        let rep_main: String = doctoritem.main.replacingOccurrences(of: "\n", with: "")
        let rep_docno: String = "d"+doctoritem.docno.replacingOccurrences(of: "\n      ", with: "")
        let rep_docnm: String = doctoritem.docnm.replacingOccurrences(of: "\n      ", with: "")
        
        if(UIImage(named: rep_docno) == nil){
            doc_pic.image = UIImage(named: "drpic")
        }
        else{
            doc_pic.image = UIImage(named: rep_docno)
        }
        
        docnmLB.text = rep_docnm
        if(rep_esp == "20"){
            esp_Text = "일반"
        }
        else if(rep_esp == "10"){
            esp_Text = "특진"
        }
        espLB.text = esp_Text
        mainLB.text = rep_main
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        doctor_index = indexPath.row
        performSegue(withIdentifier: "Detail_date" , sender: self)
    }
    
    
    // 현재 테그에 담겨있는 문자열 전달
    public func parser(_ parser: XMLParser, foundCharacters string: String)
    {
        
        switch currentElement {
        case "docs":
            docs = docs + string
        case "doc":
            doc = doc + string
        case "docno":
            docno = docno + string
        case "docnm":
            docnm = docnm + string
        case "esp":
            esp = esp + string
        case "main":
            main = main + string
        default:break
            
        }
    }
 }
 

