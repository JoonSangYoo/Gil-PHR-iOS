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
    
    var parser = XMLParser()        // 파서 객체
    
    var currentElement = ""       // 현재 Element
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        let doctor = doctorlist[doctor_index]
        let rep_deptnm: String = deptlist[reserve_index-1].deptnm.replacingOccurrences(of: "\n      ",with: "")
        let rep_docnm: String = doctor.docnm.replacingOccurrences(of:"\n      ", with:"")
        let rep_main: String = doctor.main.replacingOccurrences(of:"\n    ", with:"")
        
        deptname.text = "   " + rep_deptnm + " " + rep_docnm + " 교수"
        deptdetail.text = "   " + rep_main
        calendar.appearance.headerDateFormat = "MMM"
        calendar.appearance.borderRadius = 0
        calendar.delegate = self
        calendar.dataSource = self
        
    }
    
    func calendar(calendar: FSCalendar, subtitleForDate date: NSDate) -> String? {
        return "W"
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date) {
        print(date)
    }
    
}
