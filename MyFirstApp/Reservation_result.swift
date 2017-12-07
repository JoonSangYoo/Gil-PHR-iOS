//
//  Reservation_result.swift
//  MyFirstApp
//
//  Created by 조윤성 on 2017. 10. 23..
//  Copyright © 2017년 Joonsang Yoo. All rights reserved.
//

import Foundation
import UIKit

class Reservation_result: UIViewController, XMLParserDelegate, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet weak var ResultTB: UITableView!
    @IBOutlet weak var hiddenlabel: UILabel!
    let ResTag = TagNumList.meTag
    
    var parser = XMLParser()        // 파서 객체
    
    var currentElement = ""       // 현재 Element
    
    var listItems = [Resresult]() // 예약일 조회 출력 내용 array
    
    var date = String()           //예약일
    var time = String()        // 예약시간
    var deptcd = String()         // 진료과 코드
    var deptnm = String()       // 진료과명 / 검사종류 명
    var docno = String()        //의료진코드
    var docnm = String()        //의료진명 /상세 검사명
    
    var st = ""                 // 스테이터스 값 변수≈
    var dateLB: UILabel!
    var deptnmLB: UILabel!
    var docnmLB: UILabel!
    var date_V = ""
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
            return xml
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //let postString = "<?xml version=\"1.0\" encoding=\"UTF-8\"?><request><protocol>login</protocol><userid>nayana</userid><pwd>test5782</pwd></request>"
        
        let postString = xmlWriter(prtc: "reservelist").xmlString()
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
                        self.ResultTB.dataSource = self
                        self.ResultTB.delegate = self
                        self.ResultTB.reloadData()
                        self.ResultTB.tableFooterView = UIView()
                        self.ResultTB.isHidden = false
                        self.hiddenlabel.isHidden = true
                        
                    }
                    
                }
                else if self.st == "202"{
                    DispatchQueue.main.async{
                          self.ResultTB.isHidden = true
                          self.hiddenlabel.isHidden = false
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
        
        ResultTB.rowHeight = 100
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ResultTB.layoutSubviews()
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
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
        
        if (elementName == "reserve") {
            date = String()
            time = String()
            deptnm = String()
            docnm = String()
            
        }
        
    }
    
    // XML 파서가 종료 테그를 만나면 호출됨
    public func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?)
    {
        if (elementName == "reserve") {
            let resultItem = Resresult()
            
            resultItem.date = date
            resultItem.time = time
            resultItem.deptnm = deptnm
            resultItem.docnm = docnm
            
            listItems.append(resultItem)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResultCell")!
        
        dateLB = cell.viewWithTag(34) as! UILabel
        deptnmLB = cell.viewWithTag(33) as! UILabel
        docnmLB = cell.viewWithTag(35) as! UILabel
        
        let resultItem = listItems[indexPath.row]
        date_V = resultItem.date.substring(to: 8)
        dateLB.text = weekdayForm(dateString: date_V) + "    " + resultItem.time
        //dateLB.text = weekdayForm(dateString: date.substring(to: 8)) + "  " + time
        deptnmLB.text = resultItem.deptnm
        docnmLB.text = resultItem.docnm
        cell.selectionStyle = .none
        
        if(indexPath.row%2 != 0)
        {
            let color = UIColor(red: 238.0/255.0 , green: 238.0/255.0, blue:238.0/255.0 , alpha : 1.0).cgColor
            cell.backgroundColor = UIColor(cgColor:color)
        }
        return cell
    }
    
    
    
    
    // 현재 테그에 담겨있는 문자열 전달
    public func parser(_ parser: XMLParser, foundCharacters string: String)
    {
        
        switch currentElement {
        case "date":
            date = date + string
        case "deptnm":
            deptnm = deptnm + string
        case "docnm":
            docnm = docnm + string
        case "time":
            time = time + string
            
        default:break
            
        }
        
    }
    
    
    func weekdayForm(dateString: String) -> String {
        let df: DateFormatter = DateFormatter()
        df.dateFormat = "yyyyMMdd"
        var weekFormDate: String = ""
        let cal = Calendar(identifier: .gregorian)
        if dateString == "" {
            return ""
        }else{
            
            
            let formDate = df.date(from: dateString)
            var comps = cal.dateComponents([.weekday], from: formDate!)
            
            df.dateFormat = "yyyy-MM-dd"
            
            switch comps.weekday! {
                
            case 1:
                weekFormDate = "\(df.string(from: formDate!))(일)"
            case 2:
                weekFormDate = "\(df.string(from: formDate!))(월)"
            case 3:
                weekFormDate = "\(df.string(from: formDate!))(화)"
            case 4:
                weekFormDate = "\(df.string(from: formDate!))(수)"
            case 5:
                weekFormDate = "\(df.string(from: formDate!))(목)"
            case 6:
                weekFormDate = "\(df.string(from: formDate!))(금)"
            case 7:
                weekFormDate = "\(df.string(from: formDate!))(토)"
                
                
            default:break
            }
            
            
            return weekFormDate
        }
    }

}
