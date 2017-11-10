//
//  reserv_complete.swift
//  MyFirstApp
//
//  Created by 조윤성 on 2017. 11. 10..
//  Copyright © 2017년 Joonsang Yoo. All rights reserved.
//

import Foundation

class reserv_complete : UIViewController{
    
    @IBOutlet weak var deptnmLB: UITextField!
    @IBOutlet weak var dateLB: UITextField!
    @IBOutlet weak var docnmLB: UITextField!
    @IBOutlet weak var espLB: UITextField!
    @IBOutlet weak var mainLB: UITextField!
   
    @IBOutlet weak var lastview_tv: UITextView!
    override func viewDidLoad() {
        deptnmLB.addBorderBottom(height: 1.0, color: UIColor.lightGray)
        dateLB.addBorderBottom(height: 1.0, color: UIColor.lightGray)
        docnmLB.addBorderBottom(height: 1.0, color: UIColor.lightGray)
        espLB.addBorderBottom(height: 1.0, color: UIColor.lightGray)
        mainLB.addBorderBottom(height: 1.0, color: UIColor.lightGray)
        
        lastview_tv.text = "\n예약 취소 및 변경은 전화로만 가능합니다.\n전화연결 1577-2299"
        
        let _main = doctorlist[doctor_index].main.replacingOccurrences(of: "\n    ", with: "")
        let _erp = doctorlist[doctor_index].esp.replacingOccurrences(of: "\n     ", with: "")
        let _docnm = doctorlist[doctor_index].docnm
        let _date = select_Date
        let _deptnm = deptlist[reserve_index-1].deptnm
        
        deptnmLB.text = "  \(deptlist[reserve_index-1].deptnm)"
        dateLB.text = "  " + select_Date + "  " + timelist[time_index].hhmm
        docnmLB.text = "  \(doctorlist[doctor_index].docnm)교수"
        //10특진 20 일반
        var erp_txt = ""
        let rep_erp = doctorlist[doctor_index].esp.replacingOccurrences(of: "\n     ", with: "")
        if(rep_erp == "20"){ erp_txt = "일반진료" }
        else{ erp_txt = "선택진료" }
        espLB.text = "  " + erp_txt
        /////////
        mainLB.text = "  " + _main
    }
}

