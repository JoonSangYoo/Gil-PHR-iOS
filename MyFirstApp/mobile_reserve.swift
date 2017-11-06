//
//  mobile_reserve.swift
//  MyFirstApp
//
//  Created by 조윤성 on 2017. 10. 20..
//  Copyright © 2017년 Joonsang Yoo. All rights reserved.
//

import Foundation
import UIKit

var deptlist = [Reslist]() // 진료과 목록 조회
var recentItem = [recentlist]() //최근 진료기록


var check = "1"     //test
var reserve_index = 0

extension String {
    func tindex(from: Int) -> Index {
        return self.index(startIndex, offsetBy: from)
    }
    
    func tsubstring(from: Int) -> String {
        guard from < self.characters.count else { return "" }
        let fromIndex = index(from: from)
        return substring(from: fromIndex)
    }
    
    func tsubstring(to: Int) -> String {
        guard to < self.characters.count else { return "" }
        let toIndex = index(from: to)
        return substring(to: toIndex)
    }
    
    func tsubstring(with r: Range<Int>) -> String {
        let startIndex = index(from: r.lowerBound)
        let endIndex = index(from: r.upperBound)
        return substring(with: startIndex..<endIndex)
    }
}

class mobile_reserve : UIViewController, XMLParserDelegate, UITableViewDataSource, UITableViewDelegate{
    
    let ResTag = TagNumList.meTag
    
    @IBOutlet weak var resTable: UITableView!
    
    var parser = XMLParser()        // 파서 객체
    var test = "1"
    var currentElement = ""       // 현재 Element
    var rec202 = ""               //최근 진료 '내용없음'
    
    
    
    //진료과 조회
    var depts = String()        // 진료과들
    var dept = String()          // 진료과
    var deptcd = String()       // 진료과 코드
    var deptnm = String()       // 진료과명
    var deptdesc = String()     //진료과 설명
    
    
    //UserDefault.save(key: UserDefaultKey.UD_Key, value: self.loginData[0])
    //UserDefault.save(key: UserDefaultKey.UD_Ptntno, value: self.loginData[2])
    //최근 진료 기록
    var redeptcd = String() //w
    var date = String()     //진료일
    var docno = String()        //의사코드
    var docnm = String()        //의사명
    var esp = String()       // 특진 구분
    var main = String()        //진료분야
    
    var st = ""                 // 스테이터스 값 변수
    
    var deptnmLabel: UILabel!               //진료과 명
    var deptdesctextview: UITextView!
    
    var firstLabel : UILabel!
    var secondLabel : UILabel!
    
    
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
        recentItem = [recentlist]()
        
        let postString = xmlWriter(prtc: "reendept").xmlString()
        let secondpostString = xmlWriter(prtc: "lastopd").xmlString()
        
        HttpClient.requestXML(Xml: secondpostString){
            responseString in
            let dataXML = responseString.data(using: .utf8)
            
            self.parser = XMLParser(data: dataXML!)
            self.parser.delegate = self
            
            let success:Bool = self.parser.parse()
            
            if success {
                print("parse success!")
                
                if self.st == "100"{        // 리스폰스 스테이터스가 100(성공)일때
                    // DispatchQueue.main.async -> ui가 대기상태에서 특정 조건에서 화면전환시 멈추는 현상을 없애기 위한 명령어(비동기제어)
                    DispatchQueue.main.async{
                        self.resTable.dataSource = self
                        self.resTable.delegate = self
                        self.resTable.reloadData()
                        self.resTable.tableFooterView = UIView()
                        self.resTable.isHidden = false
                    }
                }
                else if self.st=="202"{         // 리스폰스 스테이터스 100이 아닐때 (ex: 200번(실패) 3~500번 등등 추가조건 구현가능)
                    DispatchQueue.main.async{
                        self.rec202 = "ok"
                    }
                }
            }
            else{
                print("parse failure!")
            }
        }
        
        
        HttpClient.requestXML(Xml: postString){
            responseString in
            let dataXML = responseString.data(using: .utf8)
            
            self.parser = XMLParser(data: dataXML!)
            self.parser.delegate = self
            
            let success:Bool = self.parser.parse()
            if success {
                print("parse success!")
                
                if self.st == "100"{        // 리스폰스 스테이터스가 100(성공)일때
                    // DispatchQueue.main.async -> ui가 대기상태에서 특정 조건에서 화면전환시 멈추는 현상을 없애기 위한 명령어(비동기제어)
                    DispatchQueue.main.async{
                        self.resTable.dataSource = self
                        self.resTable.delegate = self
                        self.resTable.reloadData()
                        self.resTable.tableFooterView = UIView()
                        self.resTable.isHidden = false
                    }
                } else{         // 리스폰스 스테이터스 100이 아닐때 (ex: 200번(실패) 3~500번 등등 추가조건 구현가능)
                    DispatchQueue.main.async{
                       
                    }
                }
            } else{
                print("parse failure!")
            }
        }
        
        resTable.rowHeight = UITableViewAutomaticDimension
        resTable.estimatedRowHeight = 100
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        resTable.layoutSubviews()
        self.tabBarController?.tabBar.isHidden = false
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
                
                date = String()
                deptcd = String()
                deptnm = String()
                docno = String()
                docnm = String()
                esp = String()
                main = String()
                
                
            }
        
       
            if (elementName == "dept") {
                deptcd = String()
                deptnm = String()
                deptdesc = String()
            }
        
    }
    
    // XML 파서가 종료 테그를 만나면 호출됨
    public func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?)
    {
        
        if (elementName == "dept") {
            let listItem = Reslist()
            
            listItem.deptcd = deptcd
            listItem.deptnm = deptnm
            listItem.deptdesc = deptdesc
            
            deptlist.append(listItem)
            check = "1"
        }
        else if(elementName == "response"){
            let recItem = recentlist()
            if(check=="1"){
                
                recItem.date = date
                recItem.deptcd = deptcd
                recItem.deptnm = deptnm
                recItem.docno = docno
                recItem.docnm = docnm
                recItem.esp = esp
                recItem.main = main
                
                recentItem.append(recItem)
                check = "2"
            }
        }
    }

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return deptlist.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReservCell")!
        
        //최근 진료 기록으로 예약
        if indexPath.row == 0 {
            deptnmLabel = cell.viewWithTag(31) as! UILabel
            deptdesctextview = cell.viewWithTag(32) as! UITextView
            if(rec202 == "ok"){
                deptnmLabel.text = "최근 진료내역으로 예약"
                deptdesctextview.text = "진료일 : 내역 없음 \n진료과 : 내역 없음\n"
                
            }
            else{
                
                let recitem = recentItem[0]
                let repdate: String = recitem.date.replacingOccurrences(of: "\n  ", with: "")
                let repdeptnm: String = recitem.deptnm.replacingOccurrences(of: "\n  ", with: "")
                let repdocnm: String = recitem.docnm.replacingOccurrences(of: "\n  ", with: "")
                
                
                deptnmLabel.text = "최근 진료내역으로 예약"
                deptdesctextview.text = "진료일 : \(weekdayForm(dateString: repdate)) \n진료과 : \(repdeptnm)  \(repdocnm) 교수\n"
                print(check)
            }
        }
        else {
            deptnmLabel = cell.viewWithTag(31) as! UILabel
            deptdesctextview = cell.viewWithTag(32) as! UITextView
            let listItem = deptlist[indexPath.row - 1]
            deptnmLabel.text = listItem.deptnm
            deptnmLabel.textColor = UIColor.black
            if(indexPath.row == 18)//외과
            {
                deptdesctextview.text = listItem.deptdesc.tsubstring(from: 1)
            }
            else{
                deptdesctextview.text = listItem.deptdesc
            }
            deptdesctextview.textColor = UIColor.black
            
            self.deptdesctextview.addGestureRecognizer(UITapGestureRecognizer(target: self, action:  #selector (self.checkAction(sender: ))))
            print(check)
        }
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    func checkAction(sender : UITapGestureRecognizer) {
        
        let tapLocation = sender.location(in: self.resTable)
        
        let test_indexPath = self.resTable.indexPathForRow(at: tapLocation)
        
        reserve_index = (test_indexPath?.row)!
        
        performSegue(withIdentifier: "Detail_doctor" , sender: self)
    }
    
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        reserve_index = indexPath.row
        
        if(reserve_index == 0){
            if(recentItem[0].esp == ""){
                let cell = tableView.dequeueReusableCell(withIdentifier: "ReservCell")!
                cell.selectionStyle = UITableViewCellSelectionStyle.none
            }else{
                performSegue(withIdentifier: "Recent_date" , sender: self)
            }
        }
        else{
            performSegue(withIdentifier: "Detail_doctor" , sender: self)
        }
    }
    
    // 현재 테그에 담겨있는 문자열 전달
    public func parser(_ parser: XMLParser, foundCharacters string: String)
    {
        
        switch currentElement {
        case "date":
            date = date + string
        case "docnm":
            docnm = docnm + string
        case "docno":
            docno = docno + string
        case "esp":
            esp = esp + string
        case "main":
            main = main + string
        case "deptcd":
            deptcd = deptcd + string
        case "deptnm":
            deptnm = deptnm + string
        case "deptdesc":
            deptdesc = deptdesc + string
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
