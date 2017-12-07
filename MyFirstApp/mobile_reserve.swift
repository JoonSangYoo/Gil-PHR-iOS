//
//  mobile_reserve.swift
//  MyFirstApp
//
//  Created by 조윤성 on 2017. 10. 20..
//  Copyright © 2017년 Joonsang Yoo. All rights reserved.
//

import Foundation
import UIKit

var lastdeptcd = ""  //진료과코드
var lastdeptnm = ""   //진료과명
var lastdate = ""     //진료일
var lastdocno = ""    //의사코드
var lastdocnm = ""        //의사명
var lastesp = ""      // 특진 구분
var lastmain = ""        //진료분야

var deptlist = [Reslist]() // 진료과 목록 조회
var recentItem = [recentlist]() //최근 진료기록
var reserve_index = 0
var plag_mobileres = 0
var plag_rec = 0

class mobile_reserve : UIViewController, XMLParserDelegate, UITableViewDataSource, UITableViewDelegate{
    @IBOutlet weak var resTable: UITableView!
    var activityindicator : UIActivityIndicatorView = UIActivityIndicatorView()
    
    var check = "1"
    var parser = XMLParser()        // 파서 객체
    var test = "1"
    var currentElement = ""       // 현재 Element
    var rec202 = ""               //최근 진료 '내용없음'
    var pre_userid = ""           // 로그아웃 후 재로그인할경우 최근 진료목록
    var postString = ""
    
    //진료과 조회
    var depts = String()        // 진료과들
    var dept = String()          // 진료과
    var deptcd = String()       // 진료과 코드
    var deptnm = String()       // 진료과명
    var deptdesc = String()     //진료과 설명
    
    //최근 진료 기록
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
    
    
    func http_request(request_code: String){
        activityindicator.center = self.view.center
        activityindicator.hidesWhenStopped = true
        activityindicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(activityindicator)
        activityindicator.startAnimating()
        UIApplication.shared.endIgnoringInteractionEvents()
        if(request_code == "deptlist_search"){
            postString = xmlWriter(prtc: "reendept").xmlString()
        }
        else if(request_code == "lastopd_search"){
            plag_mobileres=1
            postString = xmlWriter(prtc: "lastopd").xmlString()
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
                } else if(self.st=="202" && request_code == "lastopd_search"){         // 리스폰스 스테이터스 100이 아닐때 (ex: 200번(실패) 3~500번 등등 추가조건 구현가능)
                    DispatchQueue.main.async{
                        self.http_request(request_code: "deptlist_search")
                        if(request_code == "lastopd_search"){
                            self.deptnmLabel.text = "최근 진료내역으로 예약"
                            self.deptdesctextview.text = "진료일 : 내역 없음 \n진료과 : 내역 없음\n"
                            lastdeptcd = ""  //진료과코드
                            lastdeptnm = ""   //진료과명
                            lastdate = ""     //진료일
                            lastdocno = ""    //의사코드
                            lastdocnm = ""        //의사명
                            lastesp = ""      // 특진 구분
                            lastmain = ""        //진료분야
                            plag_rec = 0
                        }
                        print(lastdate)
                        self.rec202 = "ok"
                    }
                }
                else{
                    DispatchQueue.main.async{
                    }
                }
            } else{
                print("parse failure!")
            }
            
            
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(deptlist.count==0){
            http_request(request_code: "deptlist_search")
            
        }
        else{
            self.resTable.dataSource = self
            self.resTable.delegate = self
            self.resTable.reloadData()
            self.resTable.tableFooterView = UIView()
            self.resTable.isHidden = false
        }
        http_request(request_code: "lastopd_search")
        resTable.rowHeight = UITableViewAutomaticDimension
        resTable.estimatedRowHeight = 100

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        resTable.layoutSubviews()
        self.tabBarController?.tabBar.isHidden = false
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        self.navigationController?.navigationBar.topItem?.title = ""
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // XML 파서가 시작 테그를 만나면 호출됨
    public func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:])
    {
        
        
        currentElement = elementName
        if (elementName == "response"){
            st = attributeDict["status"]!
        }
        if(elementName == "date"){
            lastdate = String()
        }
        if(elementName == "deptcd"){
            lastdeptcd = String()
        }
        if(elementName == "deptnm"){
            lastdeptnm = String()
        }
        if(elementName == "docno"){
            lastdocno = String()
        }
        if(elementName == "docnm"){
            lastdocnm = String()
        }
        if(elementName == "esp"){
            lastesp = String()
        }
        if(elementName == "main"){
            lastmain = String()
        }
        
        if (elementName == "dept") {
            deptcd = String()
            deptnm = String()
            deptdesc = String()
        }
        if(elementName == "depts"){
            deptlist = Array<Reslist>()
        }
    }
    // 현재 테그에 담겨있는 문자열 전달
    public func parser(_ parser: XMLParser, foundCharacters string: String)
    {
        switch currentElement
        {
        case "date":
            if(plag_mobileres == 1){
                lastdate = lastdate + string
            }
        case "deptcd":
            deptcd = deptcd + string
            if(plag_mobileres == 1){
                lastdeptcd = lastdeptcd + string
            }
        case "deptnm":
            deptnm = deptnm + string
            if(plag_mobileres == 1){
                lastdeptnm = lastdeptnm + string
            }
        case "docno":
            if(plag_mobileres == 1){
                lastdocno = lastdocno + string
            }
        case "docnm":
            if(plag_mobileres == 1){
                lastdocnm = lastdocnm + string
            }
        case "esp":
            if(plag_mobileres == 1){
                lastesp = lastesp + string
            }
        case "main":
            if(plag_mobileres == 1){
                lastmain = lastmain + string
            }
        case "deptdesc":
            deptdesc = deptdesc + string
        default:break
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
        activityindicator.stopAnimating()
        UIApplication.shared.endIgnoringInteractionEvents()
        deptnmLabel = cell.viewWithTag(31) as! UILabel
        deptdesctextview = cell.viewWithTag(32) as! UITextView
        
        //최근 진료 기록으로 예약
        if indexPath.row == 0 {
            if(lastdate == ""){
                deptnmLabel.text = "최근 진료내역으로 예약"
                deptdesctextview.text = "진료일 : 내역 없음 \n진료과 : 내역 없음\n"
            }
            else{
                let repdate: String = lastdate.replacingOccurrences(of: "\n  ", with: "")
                let repdeptnm: String = lastdeptnm.replacingOccurrences(of: "\n  ", with: "")
                let repdocnm: String = lastdocnm.replacingOccurrences(of: "\n  ", with: "")
                deptnmLabel.text = "최근 진료내역으로 예약"
                deptdesctextview.text = "진료일 : \(weekdayForm(dateString: repdate)) \n진료과 : \(repdeptnm)  \(repdocnm) 교수\n"
                self.deptdesctextview.addGestureRecognizer(UITapGestureRecognizer(target: self, action:  #selector (self.checkAction(sender: ))))
                plag_rec = 1
            }
        }
        else {
           
            let listItem = deptlist[indexPath.row - 1]
            deptnmLabel.text = listItem.deptnm
            deptnmLabel.textColor = UIColor.black
            if(indexPath.row == 18){
                deptdesctextview.text = listItem.deptdesc.tsubstring(from: 1)
            }
            else{
                deptdesctextview.text = listItem.deptdesc
            }
            deptdesctextview.textColor = UIColor.black
            self.deptdesctextview.addGestureRecognizer(UITapGestureRecognizer(target: self, action:  #selector (self.checkAction(sender: ))))
        }
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    func checkAction(sender : UITapGestureRecognizer) {
        
        let tapLocation = sender.location(in: self.resTable)
        
        let test_indexPath = self.resTable.indexPathForRow(at: tapLocation)
        
        reserve_index = (test_indexPath?.row)!
        let cell = resTable.dequeueReusableCell(withIdentifier: "Reservcell")
        
        if(reserve_index == 0){
            cell?.selectionStyle = .none
            if(lastdate != ""){
                performSegue(withIdentifier: "Recent_date" , sender: self)
                plag_rec = 1
            }
        }
        else{
            performSegue(withIdentifier: "Detail_doctor" , sender: self)
        }
    }

    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        reserve_index = indexPath.row
        
        
        let cell = resTable.dequeueReusableCell(withIdentifier: "Reservcell")
        if(reserve_index == 0){
            cell?.selectionStyle = .none
            if(lastdate != ""){
                performSegue(withIdentifier: "Recent_date" , sender: self)
            }
        }
        else{
            performSegue(withIdentifier: "Detail_doctor" , sender: self)
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
