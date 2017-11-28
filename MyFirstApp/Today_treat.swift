//
//  Today_treat.swift
//  MyFirstApp
//
//  Created by 조윤성 on 2017. 11. 20..
//  Copyright © 2017년 Joonsang Yoo. All rights reserved.
//

import Foundation
import UIKit

class Today_treat :UIViewController, XMLParserDelegate, UITableViewDataSource, UITableViewDelegate{
//     var activityindicator : UIActivityIndicatorView = UIActivityIndicatorView()
    
    var postString = ""
    var restime_LB : UILabel!
    var deptname_LB : UILabel!
    var main_TB : UITextView!
    var loc_LB : UILabel!
    var locmain_LB : UILabel!
    var reloadtime_LB : UILabel!
    var time_LB : UILabel!
    
    
    var st = ""                 // 스테이터스 값 변수
    var parser = XMLParser()        // 파서 객체
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        http_request(request_code: "today_treat")// 오늘 진료 request
        
        tableView.rowHeight = 155
        self.tableView.separatorColor = UIColor.white
        self.tableView.separatorStyle = .singleLineEtched
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.reloadData()
        self.tableView.tableFooterView = UIView()
        self.tableView.isHidden = false
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
            return xml
        }
    }
    
    func http_request(request_code: String){
//        activityindicator.center = self.view.center
//        activityindicator.hidesWhenStopped = true
//        activityindicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
//        view.addSubview(activityindicator)
//        activityindicator.startAnimating()
//        UIApplication.shared.endIgnoringInteractionEvents()
        
        if(request_code == "today_treat"){
            postString = xmlWriter(prtc: "todayschedule").xmlString()
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
                        self.tableView.dataSource = self
                        self.tableView.delegate = self
                        self.tableView.reloadData()
                        self.tableView.tableFooterView = UIView()
                        //self.tableView.isHidden = false
                    }
                } else if(self.st=="202"){         // 리스폰스 스테이터스 100이 아닐때 (ex: 200번(실패) 3~500번 등등 추가조건 구현가능)
                    DispatchQueue.main.async{
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
    //xml parser start tag
    public func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:])
    {
        
    }
    
    // 현재 테그에 담겨있는 문자열 전달
    public func parser(_ parser: XMLParser, foundCharacters string: String)
    {

    }
    public func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?)
    {
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Today_result_cell")!
        deptname_LB = cell.viewWithTag(46) as! UILabel
        
        cell.selectionStyle = .none
        
        
        return cell
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
}
