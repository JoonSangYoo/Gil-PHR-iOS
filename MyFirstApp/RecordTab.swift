//
//  RecordTab.swift
//  MyFirstApp
//
//  Created by 劉俊相 on 2017. 12. 7..
//  Copyright © 2017년 Joonsang Yoo. All rights reserved.
//

import Foundation


class RecordTab: UITabBarController {
    
    @IBOutlet weak var financialTabBar: UITabBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // I've added this line to viewDidLoad
        UIApplication.shared.statusBarFrame.size.height
        financialTabBar.frame = CGRect(x: 0, y:  financialTabBar.frame.size.height, width: financialTabBar.frame.size.width, height: financialTabBar.frame.size.height)
}
}
