//
//  MedicalExam.swift
//  MyFirstApp
//
//  Created by 劉俊相 on 2017. 9. 28..
//  Copyright © 2017년 Joonsang Yoo. All rights reserved.
//

import Foundation


extension String {
    func index(from: Int) -> Index {
        
        return self.index(startIndex, offsetBy: from)
    }
    
    func substring(from: Int) -> String {
        guard from < self.characters.count else { return "" }
        let fromIndex = index(from: from)
        return substring(from: fromIndex)
    }
    
    func substring(to: Int) -> String {
        guard to < self.characters.count else { return "" }

        let toIndex = index(from: to)
        return substring(to: toIndex)
    }
    
    func substring(with r: Range<Int>) -> String {
        let startIndex = index(from: r.lowerBound)
        let endIndex = index(from: r.upperBound)
        return substring(with: startIndex..<endIndex)
    }
}

class MedicalExam: UIViewController, XMLParserDelegate, UITableViewDataSource, UITableViewDelegate{
    
    let meTag = TagNumList.meTag

    @IBOutlet weak var tbData: UITableView!
    var parser = XMLParser()        // 파서 객체
    
    var currentElement = ""       // 현재 Element
    
    var listItems = [MElist]() // item Dictional Array
    
    var examDate = String()           // 검진일
    var counselDate = String()        // 상담일
    var resultCode = String()         // 조회가능 여부 1, 0 (1:가능)
    var reqURL = String()            // 요청 URL
    
    var st = ""                 // 스테이터스 값 변수

    var examDateLabel: UILabel!
    var counselDateLabel: UILabel!
    var button: UIButton!
   
    @IBOutlet weak var emptyLabel: UILabel!
  

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
        
        let postString = xmlWriter(prtc: "medicalexamlist").xmlString()
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

                        self.tbData.isHidden = false
                        self.tbData.dataSource = self
                        self.tbData.delegate = self
                        self.tbData.reloadData()
                        self.tbData.tableFooterView = UIView()
                        
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
        
        if (elementName == "list") {
            examDate = String()
            counselDate = String()
            resultCode = String()
            reqURL = String()

        }
        
    }
    
    // XML 파서가 종료 테그를 만나면 호출됨
    public func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?)
    {
        if (elementName == "list") {
            let listItem = MElist()
            
            
            listItem.examDate = weekdayForm(dateString: examDate.substring(to: 8))
            listItem.counseldate = weekdayForm(dateString: counselDate.substring(to: 8))
            listItem.resultCode = resultCode
            listItem.reqURL = reqURL
            
            listItems.append(listItem)
        }
    }
    
    
    
    // 현재 테그에 담겨있는 문자열 전달
    public func parser(_ parser: XMLParser, foundCharacters string: String)
    {
        
        switch currentElement {
        case "examdate":
            examDate = examDate + string
            //print(examDate)
        case "counseldate":
            counselDate = counselDate + string
         //   print(counselDate)
        case "resultcd":
            resultCode = resultCode + string
        //    print(resultCode)
        case "requrl":
            reqURL = reqURL + string
        //    print(reqURL)
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "examCell", for: indexPath)
        let button = self.view.viewWithTag(meTag + 3) as? UIButton
        
        button?.tag = indexPath.row
        button?.addTarget(self, action: #selector(self.expandButtonClicked(sender:)), for: UIControlEvents.touchUpInside)


        examDateLabel = self.view.viewWithTag(meTag + 1) as? UILabel
        counselDateLabel = self.view.viewWithTag(meTag + 2) as? UILabel
        // Configure the cell...
        let listItem = listItems[indexPath.row]
        examDateLabel.text = listItem.examDate
        examDateLabel.textColor = UIColor.black
        counselDateLabel.text = listItem.counseldate
        counselDateLabel.textColor = UIColor.black
        cell.selectionStyle = .none

        return cell
    }
    
    func expandButtonClicked(sender: UIButton) {
        let btnTag = sender.tag
        let listItem = listItems[btnTag]
        UserDefault.save(key: UserDefaultKey.UD_tempURL , value: listItem.reqURL)
        print(UserDefault.load(key: UserDefaultKey.UD_tempURL))
        performSegue(withIdentifier: "segExam", sender: self)
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
