//
//  reserve_main.swift
//  MyFirstApp
//
//  Created by 조윤성 on 2017. 10. 20..
//  Copyright © 2017년 Joonsang Yoo. All rights reserved.
//

import Foundation
import UIKit

class reservemain : UIViewController{
    
    override func viewDidLoad() {
        let maintab = storyboard?.instantiateViewController(withIdentifier: "MaintabController")as! MaintabController
        
        present(maintab, animated: true, completion: nil)
    }
}
