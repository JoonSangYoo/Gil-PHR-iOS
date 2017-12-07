//
//  reserv_complete.swift
//  MyFirstApp
//
//  Created by 조윤성 on 2017. 11. 10..
//  Copyright © 2017년 Joonsang Yoo. All rights reserved.
//
import Foundation
var receive_time = ""
var receive_date = ""

class reserv_complete : UIViewController{
    
    @IBOutlet weak var deptnmLB: UITextField!
    @IBOutlet weak var dateLB: UITextField!
    @IBOutlet weak var docnmLB: UITextField!
    @IBOutlet weak var espLB: UITextField!
    @IBOutlet weak var mainLB: UITextField!
    @IBOutlet weak var lastview_tv: UITextView!
    

    
    fileprivate let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    fileprivate let formatter2: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.navigationController?.isNavigationBarHidden = true   //네비게이션 바 숨기기
        deptnmLB.isUserInteractionEnabled = false
        dateLB.isUserInteractionEnabled = false
        docnmLB.isUserInteractionEnabled = false
        espLB.isUserInteractionEnabled = false
        mainLB.isUserInteractionEnabled = false
        deptnmLB.addBorderBottom(height: 1.0, color: UIColor.lightGray)
        dateLB.addBorderBottom(height: 1.0, color: UIColor.lightGray)
        docnmLB.addBorderBottom(height: 1.0, color: UIColor.lightGray)
        espLB.addBorderBottom(height: 1.0, color: UIColor.lightGray)
        mainLB.addBorderBottom(height: 1.0, color: UIColor.lightGray)
        
        var lb_main = ""
        var lb_esp = ""
        var lb_docnm =  ""
        
        var lb_deptnm = ""
        
        lastview_tv.text = "\n예약 취소 및 변경은 전화로만 가능합니다.\n전화연결 1577-2299"
        if(plag_rec == 1  && reserve_index == 0){
            lb_deptnm = lastdeptnm.replacingOccurrences(of: "\n  ",with: "")
            lb_docnm = lastdocnm.replacingOccurrences(of:"\n  ", with:"")
            lb_main = lastmain.replacingOccurrences(of:"\n", with:"")
            lb_esp = lastesp.replacingOccurrences(of:"\n"  , with:"")
        }
        else{
            lb_main = doctorlist[doctor_index].main.replacingOccurrences(of: "\n    ", with: "")
            lb_esp = doctorlist[doctor_index].esp.replacingOccurrences(of: "\n      ", with: "")
            lb_docnm = doctorlist[doctor_index].docnm.replacingOccurrences(of:"\n     ", with:"")
            lb_deptnm = deptlist[reserve_index-1].deptnm
            print(lb_esp)
        }
        
        deptnmLB.text = "    \(lb_deptnm)"
        dateLB.text = "    " + select_Date + "  " + timelist[time_index].hhmm
        docnmLB.text = "    \(lb_docnm) 교수"
        //10특진 20 일반
        var erp_txt = ""
        if(lb_esp == "20"){
            erp_txt = "일반진료"
        }else{
            erp_txt = "선택진료"
        }
        espLB.text = "    " + erp_txt
        /////////
        mainLB.text = "    " + lb_main
        
        receive_time = timelist[time_index].hhmm
        receive_date = formatter2.string(from: temp_date)
        
    }
    
    @IBAction func complete_btn(_ sender: Any) {
        createAlert(title: "예약 확정", message: "해당 진료로 예약을 하시겠습니까?")
    }
    
    
    func createAlert(title:String, message:String){
        let alert = UIAlertController(title : title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "확인",style : UIAlertActionStyle.default, handler:ok_btn))
        alert.addAction(UIAlertAction(title: "취소",style : UIAlertActionStyle.default, handler:{(action)in alert.dismiss(animated: false, completion: nil)}))
        self.present(alert, animated: true, completion: nil)
    }
    
    func ok_btn(action: UIAlertAction) {
        performSegue(withIdentifier: "complete_seg" , sender: self)
    }
}

