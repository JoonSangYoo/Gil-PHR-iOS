//
//  tell_reservation.swift
//  MyFirstApp
//
//  Created by 조윤성 on 2017. 12. 8..
//  Copyright © 2017년 Joonsang Yoo. All rights reserved.
//

import Foundation
import UIKit

class tell_reservation : UIViewController{
    
    override func viewDidLoad() {
        
    }
    
    @IBAction func tell_btn(_ sender: Any) {
        
        if let url = URL(string: "tel://15772299"), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
      
    }
}
