//
//  Hospitalization.swift
//  MyFirstApp
//
//  Created by 劉俊相 on 2017. 11. 14..
//  Copyright © 2017년 Joonsang Yoo. All rights reserved.
//

import Foundation


class Hospitalization: UIViewController, XMLParserDelegate, UITableViewDataSource, UITableViewDelegate {
    
    
    let rcTag = TagNumList.rcTag
    
    @IBOutlet weak var tbData: UITableView!
    var parser = XMLParser()        // 파서 객체
    
    var currentElement = ""       // 현재 Element
    
    var listItems = [HTlist]() // item Dictional Array
    
    var admDate = String()
    var outDate = String()
    var deptCD = String()
    var deptNM = String()
    var docNO = String()
    var docNM = String()
    
    var st = ""                 // 스테이터스 값 변수
    
    @IBOutlet weak var emptyLabel: UILabel!
    
    
    let primaryColor = UIColor(red: 23.0/255.0, green: 70.0/255.0, blue: 142.0/255.0, alpha: 1.0)
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Do any additional setup after loading the view, typically from a nib.
        
        //let postString = "<?xml version=\"1.0\" encoding=\"UTF-8\"?><request><protocol>login</protocol><userid>nayana</userid><pwd>test5782</pwd></request>"
        
        let postString = xmlWriter(prtc: "clinicadm").xmlString()
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
                        
                        self.emptyLabel.isHidden = true
                        
                        self.tbData.dataSource = self
                        self.tbData.delegate = self
                        self.tbData.reloadData()
                        self.tbData.tableFooterView = UIView()
                        self.tbData.isHidden = false
                        
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
        tabBarController?.tabBar.isHidden = false

        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        self.navigationController?.navigationBar.isTranslucent = false

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
        
        if (elementName == "data") {
            admDate = String()
            outDate = String()
            deptCD = String()
            deptNM = String()
            docNO = String()
            docNM = String()
            
        }
        
    }
    
    // XML 파서가 종료 테그를 만나면 호출됨
    public func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?)
    {
        if (elementName == "data") {
            let listItem = HTlist()
            
            
            listItem.admDate = admDate
            listItem.outDate = outDate
            listItem.deptCD = deptCD
            listItem.deptNM = deptNM
            listItem.docNO = docNO
            listItem.docNM = docNM
            
            listItems.append(listItem)
        }
    }
    
    
    
    // 현재 테그에 담겨있는 문자열 전달
    public func parser(_ parser: XMLParser, foundCharacters string: String)
    {
        
        switch currentElement {
        case "admdate":
            admDate = admDate + string
        case "outdate":
            outDate = outDate + string
        case "deptcd":
            deptCD = deptCD + string
        case "deptnm":
            deptNM = deptNM + string
        case "docno":
            docNO = docNO + string
        case "docnm":
            docNM = docNM + string

            
            
        default:break
            
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return listItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "htCell", for: indexPath) as? HTcell{
            
            let listItem = listItems[indexPath.row]
            
            
            cell.deptDocLabel.text = listItem.deptNM.replacingOccurrences(of: "\n      ", with: " ") + listItem.docNM
            cell.deptDocLabel.textColor = UIColor.black
            
            cell.dateLabel.text = weekdayForm(dateString: listItem.admDate.replacingOccurrences(of: "\n      ", with: ""))
            cell.dateLabel.textColor = UIColor.black
            cell.dateLabel2.text = "~ \(weekdayForm(dateString: listItem.outDate.replacingOccurrences(of: "\n      ", with: "")))"
            cell.dateLabel2.textColor = UIColor.black
            
           

            cell.selectionStyle = .none
            print("if \(indexPath.row)" )
            return cell
        }
        
        
        return UITableViewCell()
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     
        let listItem = listItems[indexPath.row]

        UserDefault.save(key: UserDefaultKey.UD_ClinicIo, value: "10")
        UserDefault.save(key: UserDefaultKey.UD_ClinicDeptcd, value: listItem.deptCD)
        UserDefault.save(key: UserDefaultKey.UD_ClinicDocno, value: listItem.docNO)
        UserDefault.save(key: UserDefaultKey.UD_ClinicDate, value: listItem.admDate)
        UserDefault.save(key: UserDefaultKey.UD_ClinicHdate, value: weekdayForm(dateString: listItem.admDate.replacingOccurrences(of: "\n      ", with: "")) + " ~ \(weekdayForm(dateString: listItem.outDate.replacingOccurrences(of: "\n      ", with: "")))")
        UserDefault.save(key: UserDefaultKey.UD_ClinicDeptnm, value: listItem.deptNM.replacingOccurrences(of: "\n      ", with: " ") + listItem.docNM)
        self.performSegue(withIdentifier: "HTtoD", sender: self)

        
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
