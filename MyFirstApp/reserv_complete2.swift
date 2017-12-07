//
//  reserv_complete2.swift
//  MyFirstApp
//
//  Created by 조윤성 on 2017. 12. 5..
//  Copyright © 2017년 Joonsang Yoo. All rights reserved.
//

import Foundation
import UIKit


var pt_deptcd  = ""
var pt_docno = ""
let pt_recdate = receive_date
let pt_rectime = receive_time.replacingOccurrences(of:"\n      ", with:"")

class reserv_complete2 : UIViewController, XMLParserDelegate {
    var parser = XMLParser()        // 파서 객체
    var currentElement = ""       // 현재 Element
    var st = "100"                 // 스테이터스 값 변수
    var postString = ""
    
    var rec_date = ""
    var rec_time = ""
    var rec_deptnm = ""
    var rec_docnm = ""
    
    var fail = 0
    
    @IBOutlet weak var succes_LB: UILabel!
    @IBOutlet weak var succes2_LB: UILabel!
    @IBOutlet weak var succes_IV: UIImageView!
    
    @IBOutlet weak var deptnm_LB: UILabel!
    @IBOutlet weak var deptnm_tv: UITextField!
    @IBOutlet weak var resdate_tv: UITextField!
    @IBOutlet weak var resdate_LB: UILabel!
    @IBOutlet weak var docnm_tv: UITextField!
    @IBOutlet weak var docnm_LB: UILabel!
    @IBOutlet weak var lastview: UITextView!
    @IBOutlet weak var gotohome: UIButton!
    
    
    
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
            xml += "<deptcd>\(pt_deptcd)</deptcd>"
            xml += "<yyyymmdd>\(pt_recdate)</yyyymmdd>"
            xml += "<hhmm>\(pt_rectime)</hhmm>"
            xml += "<docno>\(pt_docno)</docno>"
            xml += "</request>"
            return xml
        }
    }

    func http_request(request_code: String){
        postString = xmlWriter(prtc: request_code).xmlString()
        print(postString)
//        HttpClient.requestXML(Xml: postString){
//            responseString in
//            let dataXML = responseString.data(using: .utf8)
//            self.parser = XMLParser(data: dataXML!)
//            self.parser.delegate = self
//            let success:Bool = self.parser.parse()
//            if success {
//                print("parse success!")
//                if self.st == "100"{        // 리스폰스 스테이터스가 100(성공)일때
//                    // DispatchQueue.main.async -> ui가 대기상태에서 특정 조건에서 화면전환시 멈추는 현상을 없애기 위한 명령어(비동기제어)
//                    DispatchQueue.main.async{
//
//                    }
//                }
//                else{
//                    DispatchQueue.main.async{
//                        self.succes_LB.isHidden = true
//                        self.succes2_LB.isHidden = true
//                        self.succes_IV.isHidden = true
//                        self.gotohome.isHidden = true
//                        self.deptnm_tv.isHidden = true
//                        self.deptnm_LB.isHidden = true
//                        self.docnm_LB.isHidden = true
//                        self.docnm_tv.isHidden = true
//                        self.resdate_tv.isHidden = true
//                        self.resdate_LB.isHidden = true
//
//                        self.createAlert(title: "예약 실패", message: "예약을 실패했습니다.\n처음부터 다시 진행해 주세요.")
//                    }
//                }
//            } else{
//                print("parse failure!")
//            }
//        }
    }
    
    // XML 파서가 시작 테그를 만나면 호출됨
    public func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:])
    {
        currentElement = elementName
        if (elementName == "response"){
            st = attributeDict["status"]!
        }
    }
    
    override func viewDidLoad() {
        if(plag_rec == 1  && reserve_index == 0){
            pt_deptcd  = lastdeptcd.replacingOccurrences(of:"\n      ", with:"")
            pt_docno = lastdocno.replacingOccurrences(of: "\n", with: "")
        }
        else{
            pt_deptcd  = deptlist[reserve_index-1].deptcd.replacingOccurrences(of:"\n      ", with:"")
            pt_docno = doctorlist[doctor_index].docno.replacingOccurrences(of: "\n      ", with: "")
        }
        http_request(request_code: "reservesave")
        
        lastview.text = "\n예약 취소 및 변경은 전화로만 가능합니다.\n전화연결 1577-2299"
        self.navigationController?.isNavigationBarHidden = true
        deptnm_tv.isUserInteractionEnabled = false
        resdate_tv.isUserInteractionEnabled = false
        docnm_tv.isUserInteractionEnabled = false
        deptnm_tv.addBorderBottom(height: 1.0, color: UIColor.lightGray)
        resdate_tv.addBorderBottom(height: 1.0, color: UIColor.lightGray)
        docnm_tv.addBorderBottom(height: 1.0, color: UIColor.lightGray)
        
        
        if(plag_rec == 1  && reserve_index == 0){
            rec_deptnm = lastdeptnm.replacingOccurrences(of: "\n  ",with: "")
            rec_docnm = lastdocnm.replacingOccurrences(of:"\n  ", with:"")
        }
        else{
            rec_deptnm = deptlist[reserve_index-1].deptnm
            rec_docnm = doctorlist[doctor_index].docnm.replacingOccurrences(of:"\n     ", with:"")
        }
        
        
        
        deptnm_LB.text = rec_deptnm
        resdate_LB.text = self.weekdayForm(dateString: pt_recdate) + "   " + pt_rectime
        docnm_LB.text = rec_docnm
        
        super.viewDidLoad()
    }
    
    func createAlert(title:String, message:String){
        let alert = UIAlertController(title : title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "확인",style : UIAlertActionStyle.default, handler:alert_btn))
        self.present(alert, animated: true, completion: nil)
    }
    
    func alert_btn(action: UIAlertAction){
        self.navigationController?.isNavigationBarHidden = false
        self.dismiss(animated: true, completion: {});
        self.navigationController?.popToRootViewController(animated: true)
        rec_deptnm = ""
    }
    
    @IBAction func gotoback_btn(_ sender: Any) {
        self.dismiss(animated: true, completion: {});
        self.navigationController?.popToRootViewController(animated: true)
        rec_deptnm = ""
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
            
            df.dateFormat = "yyyy년 MM월 dd일"
            
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
