//
//  RecordDetail.swift
//  MyFirstApp
//
//  Created by 劉俊相 on 2017. 11. 16..
//  Copyright © 2017년 Joonsang Yoo. All rights reserved.
//

import Foundation

class RecordDetail: UIViewController, XMLParserDelegate, UITableViewDataSource, UITableViewDelegate {
    
    
    let rcTag = TagNumList.rcTag
    
    
    @IBOutlet weak var tbData: UITableView!
    @IBOutlet weak var tbData2: UITableView!
    @IBOutlet weak var surveyButton: UIButton!
    
    var parser = XMLParser()        // 파서 객체
    
    var currentElement = ""       // 현재 Element
    
    var listItems = [RDlist]() // item Dictional Array
    var listItems2 = [RDlist]()
    var surveyData = [String]()

    
    var ordDate = String()
    var examCD = String()
    var examNM = String()
    var refVal = String()
    var resultVal = String()
    var lowHigh = String()
    
    
    var ordDate2 = String()
    var drugCD = String()
    var drugNM = String()
    var qty = String()
    var unit = String()
    var count = String()
    var day = String()
    
    
    var st = ""                 // 스테이터스 값 변수
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var sortLabel: PaddingLabel!
    @IBOutlet weak var dateLabel: PaddingLabel!
    @IBOutlet weak var deptLabel: PaddingLabel!
    
    @IBOutlet weak var leftView: UIView!
    
    @IBOutlet weak var drugTitleLabel: UILabel!
    @IBOutlet weak var drugInfoLabel: UILabel!
    
    @IBOutlet weak var drugTopView: UIView!
    
    
    let screenHeight = UIScreen.main.bounds.height
    let scrollViewContentHeight = 1200 as CGFloat
    
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
            xml += "<io>\(UserDefault.load(key: UserDefaultKey.UD_ClinicIo))</io>"
            xml += "<deptcd>\(UserDefault.load(key: UserDefaultKey.UD_ClinicDeptcd).replacingOccurrences(of: "\n      ", with: ""))</deptcd>"
            xml += "<docno>\(UserDefault.load(key: UserDefaultKey.UD_ClinicDocno).replacingOccurrences(of: "\n      ", with: ""))</docno>"
            xml += "<date>\(UserDefault.load(key: UserDefaultKey.UD_ClinicDate).replacingOccurrences(of: "\n      ", with: ""))</date>"
            xml += "</request>"
            
            //      for number in self.trackingNumbers {
            //                xml += "<TrackingNumber>\(number)</TrackingNumber>"
            //    }
            
            
            return xml
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBarController?.tabBar.isHidden = true
        
        
        // Do any additional setup after loading the view, typically from a nib.
        
        //let postString = "<?xml version=\"1.0\" encoding=\"UTF-8\"?><request><protocol>login</protocol><userid>nayana</userid><pwd>test5782</pwd></request>"
        
        let postString = xmlWriter(prtc: "clinicdata").xmlString()
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
                        self.tbDataSet()
                        self.tbData2Set()
                        self.scrollViewSet()
                        
                        if self.surveyData[0] == "Y"{
                            self.surveyButton.isHidden = false
                        } else{
                            self.surveyButton.isHidden = true
                        }
                        
                        
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
        self.navigationController?.navigationBar.barTintColor = UIColor.bgColor
        self.navigationController?.navigationBar.tintColor = UIColor.primaryColor
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        
        if UserDefault.load(key: UserDefaultKey.UD_ClinicIo) == "20" {
            self.sortLabel.text = "외래"
            self.dateLabel.text = weekdayForm(dateString: UserDefault.load(key: UserDefaultKey.UD_ClinicDate).replacingOccurrences(of: "\n      ", with: ""))
        } else{
            self.sortLabel.text = "입원"
            self.dateLabel.text = UserDefault.load(key: UserDefaultKey.UD_ClinicHdate)

        }
        
        self.deptLabel.text = UserDefault.load(key: UserDefaultKey.UD_ClinicDeptnm)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func surveyButtonEvent(_ sender: Any) {
        UIApplication.shared.open(URL(string: self.surveyData[2])!, options: [:], completionHandler: nil)
    }
    func tbDataSet() -> Void {
        self.tbData.dataSource = self
        self.tbData.delegate = self
        self.tbData.reloadData()
        self.tbData.tableFooterView = UIView()
        self.tbData.isHidden = false
        self.tbData.isScrollEnabled = false
        self.tbData.frame = CGRect(x: self.tbData.frame.origin.x, y: self.tbData.frame.origin.y, width: self.tbData.frame.width, height: CGFloat(Float(self.listItems.count) * 44))
    }
    
    func tbData2Set() -> Void {
        self.tbData2.dataSource = self
        self.tbData2.delegate = self
        self.tbData2.reloadData()
        self.tbData2.tableFooterView = UIView()
        self.tbData2.isHidden = false
        self.tbData2.isScrollEnabled = false
        
        self.drugTitleLabel.frame = CGRect(x: self.drugTitleLabel.frame.origin.x, y: self.drugTitleLabel.frame.origin.y + self.tbData.frame.height, width: self.drugTitleLabel.frame.width, height: self.drugTitleLabel.frame.height)
        
        self.drugInfoLabel.frame = CGRect(x: self.drugInfoLabel.frame.origin.x, y: self.drugInfoLabel.frame.origin.y + self.tbData.frame.height, width: self.drugInfoLabel.frame.width, height: self.drugInfoLabel.frame.height)
        
        self.drugTopView.frame = CGRect(x: self.drugTopView.frame.origin.x, y: self.drugTopView.frame.origin.y + self.tbData.frame.height, width: self.drugTopView.frame.width, height: self.drugTopView.frame.height)
        
        self.tbData2.frame = CGRect(x: self.tbData2.frame.origin.x, y: self.tbData2.frame.origin.y + self.tbData.frame.height, width: self.tbData2.frame.width, height: CGFloat(Float(self.listItems2.count) * 44))
        
    }
    
    func scrollViewSet() -> Void {
        
        self.scrollView.contentSize = CGSize(width: self.scrollView.frame.width, height: CGFloat(Float(self.listItems.count) * 44) + CGFloat(Float(self.listItems2.count) * 44) + self.scrollView.frame.height)
        //print(scrollView.frame.width)
        //print(scrollViewContentHeight)
        self.scrollView.delegate = self
        self.scrollView.bounces = false
    }
    // XML 파서가 시작 테그를 만나면 호출됨
    public func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:])
    {
        currentElement = elementName
        
        
        if (elementName == "response") {
            st = attributeDict["status"]!
            
        }
        
        if (elementName == "result") {
            ordDate = String()
            examCD = String()
            examNM = String()
            refVal = String()
            resultVal = String()
            lowHigh = String()
            
        }
        if (elementName == "drug"){
            ordDate2 = String()
            drugCD = String()
            drugNM = String()
            qty = String()
            unit = String()
            count = String()
            day = String()
            
        }

        
    }
    
    // XML 파서가 종료 테그를 만나면 호출됨
    public func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?)
    {
        if (elementName == "result") {
            
            let listItem = RDlist()
            
            listItem.ordDate = ordDate
            listItem.examCD = examCD
            listItem.examNM = examNM
            listItem.refVal = refVal
            listItem.resultVal = resultVal
            listItem.lowHigh = lowHigh
            
            listItems.append(listItem)
            
        }
        if (elementName == "drug"){
            
            let listItem = RDlist()
            
            listItem.ordDate2 = ordDate2
            listItem.drugCD = drugCD
            listItem.drugNM = drugNM
            listItem.qty = qty
            listItem.unit = unit
            listItem.count = count
            listItem.day = day
            
            listItems2.append(listItem)
            
        }
    }
    
    
    
    // 현재 테그에 담겨있는 문자열 전달
    public func parser(_ parser: XMLParser, foundCharacters string: String)
    {
        
        switch currentElement {
            
            case "orddate":
                ordDate = ordDate + string
                ordDate2 = ordDate2 + string
            case "exmcd":
                examCD = examCD + string
            case "exmnm":
                examNM = examNM + string
            case "refval":
                refVal = refVal + string
            case "resultval":
                resultVal = resultVal + string
            case "lowhigh":
                lowHigh = lowHigh + string
            case "drugcd":
                drugCD = drugCD + string
            case "drugnm":
                drugNM = drugNM + string
            case "qty":
                qty = qty + string
            case "unit":
                unit = unit + string
            case "count":
                count = count + string
            case "day":
                day = day + string
            case "surveyyn":
                surveyData.append(string)
            case "surveyurl":
                surveyData.append(string)
            
            default:break
            
        }
        
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var countItem: Int?
        
        if tableView == self.tbData{
            countItem = listItems.count
        }
        
        if tableView == self.tbData2{
            countItem = listItems2.count
        }
        
        // #warning Incomplete implementation, return the number of rows
        return countItem!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if tableView == self.tbData{
            if let cell = tableView.dequeueReusableCell(withIdentifier: "examCell", for: indexPath) as? ExamCell{
                
                let listItem = listItems[indexPath.row]
                
                
                cell.ordDateLabel.text = weekdayForm(dateString: listItem.ordDate.replacingOccurrences(of: "\n      ", with: ""))
                cell.exmnmLabel.text = listItem.examNM
                cell.refValueLabel.text = listItem.refVal
                cell.resultValueLabel.text = listItem.resultVal

                if listItem.lowHigh.replacingOccurrences(of: "\n    ", with: "") == "1" {
                    cell.lowHighView.image = UIImage(named: "arrow_down")

                } else if listItem.lowHigh.replacingOccurrences(of: "\n    ", with: "") == "2" {
                    cell.lowHighView.image = UIImage(named: "arrow_up")

                }
                
                cell.selectionStyle = .none
                return cell
            }
        }
       
        if tableView == self.tbData2{
            if let cell = tableView.dequeueReusableCell(withIdentifier: "drugCell", for: indexPath) as? DrugCell{
                
                let listItem = listItems2[indexPath.row]
                
                
                cell.ordDate2Label.text = weekdayForm(dateString: listItem.ordDate2.replacingOccurrences(of: "\n      ", with: ""))
                cell.drugnmLabel.text = listItem.drugNM
                cell.qtyLabel.text = listItem.qty
                cell.unitLabel.text = listItem.unit
                cell.countLabel.text = listItem.count
                cell.dayLabel.text = listItem.day
                
                cell.selectionStyle = .none
                return cell
            }
        }

        

        
        
        return UITableViewCell()
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        

        
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

extension UILabel {
    
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
}




