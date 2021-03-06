//
//  OutPatient.swift
//  MyFirstApp
//
//  Created by 劉俊相 on 2017. 11. 7..
//  Copyright © 2017년 Joonsang Yoo. All rights reserved.
//

import Foundation
import DLRadioButton

class OutPatient: UIViewController, XMLParserDelegate, UITableViewDataSource, UITableViewDelegate {
    
    
    let rcTag = TagNumList.rcTag
    
    @IBOutlet weak var tbData: UITableView!
    var parser = XMLParser()        // 파서 객체
    
    var currentElement = ""       // 현재 Element
    
    var listItems = [OPlist]() // item Dictional Array
    
    var opdDate = String()
    var deptCD = String()
    var deptNM = String()
    var docNO = String()
    var docNM = String()
    var esp = String()
    var main = String()
    
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
        
        let postString = xmlWriter(prtc: "clinicopd").xmlString()
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
    @IBAction func reserveButton(_ sender: Any) {
        if(UserDefault.load(key: UserDefaultKey.UD_ClinicFlag) == "0"){
            let alert = UIAlertController(title: "선택확인", message: "예약할 진료과 및 의사를 선택해주세요.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "확인", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }else{
            performSegue(withIdentifier: "OPtoR", sender: self)

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
        
        if (elementName == "data") {
            opdDate = String()
            deptCD = String()
            deptNM = String()
            docNO = String()
            docNM = String()
            esp = String()
            main = String()
            
        }
        
    }
    
    // XML 파서가 종료 테그를 만나면 호출됨
    public func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?)
    {
        if (elementName == "data") {
            let listItem = OPlist()
            
            
            listItem.opdDate = opdDate
            listItem.deptCD = deptCD
            listItem.deptNM = deptNM
            listItem.docNO = docNO
            listItem.docNM = docNM
            listItem.esp = esp
            listItem.main = main
            
            listItems.append(listItem)
        }
    }
    
    
    
    // 현재 테그에 담겨있는 문자열 전달
    public func parser(_ parser: XMLParser, foundCharacters string: String)
    {
        
        switch currentElement {
        case "opddate":
            opdDate = opdDate + string
        case "deptcd":
            deptCD = deptCD + string
        case "deptnm":
            deptNM = deptNM + string
        case "docno":
            docNO = docNO + string
        case "docnm":
            docNM = docNM + string
        case "esp":
            esp = esp + string
        case "main":
            main = main + string


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
        

        if let cell = tableView.dequeueReusableCell(withIdentifier: "opCell", for: indexPath) as? OPcell{
           
            let listItem = listItems[indexPath.row]


            cell.deptDocNameLabel.text = listItem.deptNM.replacingOccurrences(of: "\n      ", with: " ") + listItem.docNM
            cell.deptDocNameLabel.textColor = UIColor.black
            
            cell.opdDateLabel.text = weekdayForm(dateString: listItem.opdDate.replacingOccurrences(of: "\n      ", with: ""))
            cell.opdDateLabel.textColor = UIColor.black
            

            cell.radioButton.backgroundColor = UIColor.white
            cell.opdDateLabel.isUserInteractionEnabled = true
            cell.opdDateLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.expandButtonClicked(sender:))))
            cell.deptDocNameLabel.isUserInteractionEnabled = true
            cell.deptDocNameLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.expandButtonClicked(sender:))))
           // cell.addedTouchArea.add(150)
  
            //cell.radioButton.addTarget(self, action: #selector(self.expandButtonClicked(sender:)), for: UIControlEvents.touchUpInside)
            
            
//            cell.radioButton.iconColor = UIColor.gray
//            cell.radioButton.indicatorColor = primaryColor
//            otherButtons.append(cell.radioButton)
//            cell.radioButton.otherButtons = otherButtons
          //  cell.radioButton.isSelected = false
            cell.selectionStyle = .none
            print("if \(indexPath.row)" )
            return cell
        }
        

        return UITableViewCell()
    }
    

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let listItem = listItems[indexPath.row]

        UserDefault.save(key: UserDefaultKey.UD_ClinicIo, value: "20")
        UserDefault.save(key: UserDefaultKey.UD_ClinicDeptcd, value: listItem.deptCD.replacingOccurrences(of: "\n      ", with: ""))
        UserDefault.save(key: UserDefaultKey.UD_ClinicDeptnm, value: listItem.deptNM.replacingOccurrences(of: "\n      ", with: ""))
        UserDefault.save(key: UserDefaultKey.UD_ClinicDocno, value: listItem.docNO.replacingOccurrences(of: "\n      ", with: ""))
        UserDefault.save(key: UserDefaultKey.UD_ClinicMain, value: listItem.main)
        UserDefault.save(key: UserDefaultKey.UD_ClinicDate, value: listItem.opdDate)
        UserDefault.save(key: UserDefaultKey.UD_ClinicEsp, value: listItem.esp)
        UserDefault.save(key: UserDefaultKey.UD_ClinicDocnm, value: listItem.docNM.replacingOccurrences(of: "\n      ", with: ""))
        UserDefault.save(key: UserDefaultKey.UD_ClinicFlag, value: "1")
        print("라디오버튼 이벤트: \(indexPath.row)")
   
    }
    
    func expandButtonClicked(sender: UITapGestureRecognizer) {
        let tapLocation = sender.location(in: self.tbData)
        
        let indexPath = self.tbData.indexPathForRow(at: tapLocation)!
        let listItem = listItems[indexPath.row]
        
        print("상세화면이동 이벤트 \(listItem.deptNM)")
        UserDefault.save(key: UserDefaultKey.UD_ClinicIo, value: "20")
        UserDefault.save(key: UserDefaultKey.UD_ClinicDeptcd, value: listItem.deptCD)
        UserDefault.save(key: UserDefaultKey.UD_ClinicDeptnm, value: listItem.deptNM.replacingOccurrences(of: "\n      ", with: " ") + listItem.docNM)
        UserDefault.save(key: UserDefaultKey.UD_ClinicDocno, value: listItem.docNO)
        UserDefault.save(key: UserDefaultKey.UD_ClinicMain, value: listItem.main)
        UserDefault.save(key: UserDefaultKey.UD_ClinicDate, value: listItem.opdDate)
  
        self.performSegue(withIdentifier: "OPtoD", sender: self)

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

extension UIColor{

    static let primaryColor = UIColor(red: 23.0/255.0, green: 70.0/255.0, blue: 142.0/255.0, alpha: 1.0)
    static let bgColor = UIColor(red: 217.0/255.0, green: 220.0/255.0, blue: 232.0/255.0, alpha: 1.0)
    static let primaryColor2 = UIColor(red: 40.0/255.0, green: 55.0/255.0, blue: 115.0/255.0, alpha: 1.0)
    static let silver = UIColor(red: 239.0/255.0, green: 239.0/255.0, blue: 236.0/255.0, alpha: 1.0)

}
