//
//  Detail_date.swift
//  MyFirstApp
//
//  Created by 조윤성 on 2017. 11. 3..
//  Copyright © 2017년 Joonsang Yoo. All rights reserved.
//

import Foundation
import FSCalendar

class Detail_date : UIViewController, FSCalendarDelegate, FSCalendarDataSource, XMLParserDelegate{
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var deptname: UILabel!
    @IBOutlet weak var deptdetail: UILabel!
    @IBOutlet weak var time_tb: UITableView!
    
    fileprivate let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter
    }()
    
    var parser = XMLParser()        // 파서 객체
    var currentElement = ""       // 현재 Element
    var st = ""                   //statuscode 구분
    var search_month = ""
    var datesWithEvent: [String] = []
    var temp_month = ""
    
    override func viewDidLoad() {
        event_dot()
        print(datesWithEvent)
        
        let doctor = doctorlist[doctor_index]
        let rep_deptnm: String = deptlist[reserve_index-1].deptnm.replacingOccurrences(of: "\n      ",with: "")
        let rep_docnm: String = doctor.docnm.replacingOccurrences(of:"\n      ", with:"")
        let rep_main: String = doctor.main.replacingOccurrences(of:"\n    ", with:"")
        deptname.text = "   " + rep_deptnm + " " + rep_docnm + " 교수"
        deptdetail.text = "   " + rep_main
        ///////////////////theme-----------------------------------------
        self.calendar.appearance.weekdayTextColor = UIColor.blue
        self.calendar.appearance.headerTitleColor = UIColor.darkGray
        self.calendar.appearance.selectionColor = UIColor.gray
        self.calendar.appearance.headerDateFormat = "yyyy-MM";
        self.calendar.appearance.todayColor = UIColor.red
        self.calendar.appearance.headerMinimumDissolvedAlpha = 0.0
        let now = NSDate()
        let dateFormat_now = DateFormatter()
        dateFormat_now.dateFormat = "yyyy/MM/dd"
        calendar.select(self.formatter.date(from: dateFormat_now.string(from: now as Date)))
        ///////////////////theme-----------------------------------------end
        
        self.calendar.appearance.caseOptions = [.headerUsesUpperCase,.weekdayUsesSingleUpperCase]
        self.view.addSubview(self.calendar)
        super.viewDidLoad()
    }
    
    //날짜 선택
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print("calendar did select date \(self.formatter.string(from: date))")
        if monthPosition == .previous || monthPosition == .next {
            calendar.setCurrentPage(date, animated: true)
        }
    }
    
    //페이지 전환
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        event_dot()
    }
    
    //  event처리
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        let dateString = self.formatter.string(from: date)
        if self.datesWithEvent.contains(dateString) {
            return 1
        }
        return 0
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventColorFor date: Date) -> UIColor? {
        return UIColor.purple
    }
    
    //xml parsing start
    public func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:])
    {
        currentElement = elementName
        if (elementName == "response") {
            st = attributeDict["status"]!
            //datesWithEvent = Array<String>()
        }
    }
    
    // string array add
    public func parser(_ parser: XMLParser, foundCharacters string: String)
    {
        search_month = self.formatter.string(from: calendar.currentPage)
        let index = search_month.index(search_month.startIndex, offsetBy: 8)
        temp_month = search_month.substring(to: index)
        
        switch currentElement {
        case "d1":
            if(string == "Y"){
                datesWithEvent.append(temp_month+"01")
            }
        case "d2":
            if(string == "Y"){
                datesWithEvent.append(temp_month+"02")
            }
        case "d3":
            if(string == "Y"){
                datesWithEvent.append(temp_month+"03")
            }
        case "d4":
            if(string == "Y"){
                datesWithEvent.append(temp_month+"04")
            }
        case "d5":
            if(string == "Y"){
                datesWithEvent.append(temp_month+"05")
            }
        case "d6":
            if(string == "Y"){
                datesWithEvent.append(temp_month+"06")
            }
        case "d7":
            if(string == "Y"){
                datesWithEvent.append(temp_month+"07")
            }
        case "d8":
            if(string == "Y"){
                datesWithEvent.append(temp_month+"08")
            }
        case "d9":
            if(string == "Y"){
                datesWithEvent.append(temp_month+"09")
            }
        case "d10":
            if(string == "Y"){
                datesWithEvent.append(temp_month+"10")
            }
        case "d11":
            if(string == "Y"){
                datesWithEvent.append(temp_month+"11")
            }
        case "d12":
            if(string == "Y"){
                datesWithEvent.append(temp_month+"12")
            }
        case "d13":
            if(string == "Y"){
                datesWithEvent.append(temp_month+"13")
            }
        case "d14":
            if(string == "Y"){
                datesWithEvent.append(temp_month+"14")
            }
        case "d15":
            if(string == "Y"){
                datesWithEvent.append(temp_month+"15")
            }
        case "d16":
            if(string == "Y"){
                datesWithEvent.append(temp_month+"16")
            }
        case "d17":
            if(string == "Y"){
                datesWithEvent.append(temp_month+"17")
            }
        case "d18":
            if(string == "Y"){
                datesWithEvent.append(temp_month+"18")
            }
        case "d19":
            if(string == "Y"){
                datesWithEvent.append(temp_month+"19")
            }
        case "d20":
            if(string == "Y"){
                datesWithEvent.append(temp_month+"20")
            }
        case "d21":
            if(string == "Y"){
                datesWithEvent.append(temp_month+"21")
            }
        case "d22":
            if(string == "Y"){
                datesWithEvent.append(temp_month+"22")
            }
        case "d23":
            if(string == "Y"){
                datesWithEvent.append(temp_month+"23")
            }
        case "d24":
            if(string == "Y"){
                datesWithEvent.append(temp_month+"24")
            }
        case "d25":
            if(string == "Y"){
                datesWithEvent.append(temp_month+"25")
            }
        case "d26":
            if(string == "Y"){
                datesWithEvent.append(temp_month+"26")
            }
        case "d27":
            if(string == "Y"){
                datesWithEvent.append(temp_month+"27")
            }
        case "d23":
            if(string == "Y"){
                datesWithEvent.append(temp_month+"28")
            }
        case "d29":
            if(string == "Y"){
                datesWithEvent.append(temp_month+"29")
            }
        case "d30":
            if(string == "Y"){
                datesWithEvent.append(temp_month+"30")
            }
        case "d31":
            if(string == "Y"){
                datesWithEvent.append(temp_month+"31")
            }
        default:break
        }
    }
    
    struct xmlWriter {             // xml 작성을 위한 구조체
        var prtc: String
        
        init(prtc: String) {
            self.prtc = prtc
        }
        
        func xmlString() -> String {
            let xml_deptcd: String = deptlist[reserve_index-1].deptcd.replacingOccurrences(of: "\n  ", with: "")
            let xml_docnm: String = doctorlist[doctor_index].docno
            /////2017.11.09
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
    
    func event_dot(){
        /////////////특정날짜 dot표시
        let xml_deptcd: String = deptlist[reserve_index-1].deptcd.replacingOccurrences(of: "\n      ", with: "")
        let xml_doctor: String = doctorlist[doctor_index].docno.replacingOccurrences(of: "\n      ", with: "")
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMM"
        var dateString = dateFormatter.string(from: calendar.currentPage)
        
        var postString = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
        postString += "<request>"
        postString += "<protocol>reserveday</protocol>"
        postString += "<userid>\(UserDefault.load(key: UserDefaultKey.UD_id))</userid>"
        postString += "<keycd>\(UserDefault.load(key: UserDefaultKey.UD_Key))</keycd>"
        postString += "<deptcd>\(xml_deptcd)</deptcd>"
        postString += "<docno>\(xml_doctor)</docno>"
        postString += "<yyyymm>"+dateString+"</yyyymm>"
        postString += "</request>"
        
        HttpClient.requestXML(Xml: postString){ responseString in
            let dataXML = responseString.data(using: .utf8)
            
            self.parser = XMLParser(data: dataXML!)
            self.parser.delegate = self
            
            let success:Bool = self.parser.parse()
            if success {
                print("parse success!")
                
                if self.st == "100"{        // 리스폰스 스테이터스가gfd 100(성공)일때
                    DispatchQueue.main.async{
                        self.calendar.dataSource = self
                        self.calendar.delegate = self
                        self.calendar.reloadData()
                    }
                }
                else if self.st == "202"{
                    DispatchQueue.main.async{
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
        
        print(datesWithEvent)
    }
    
    
}


