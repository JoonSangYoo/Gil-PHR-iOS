//
//  Record.swift
//  MyFirstApp
//
//  Created by 劉俊相 on 2017. 9. 18..
//  Copyright © 2017년 Joonsang Yoo. All rights reserved.
//

import UIKit

class Record: UITabBarController {
    

    @IBOutlet weak var RecordTab: UITabBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let screenSize: CGRect = UIScreen.main.bounds
        RecordTab.frame = CGRect(x: 0, y: screenSize.height * 0.25, width: self.RecordTab.frame.width, height: self.RecordTab.frame.height)
        
        let primaryColor = UIColor(red: 23.0/255.0, green: 70.0/255.0, blue: 142.0/255.0, alpha: 1.0)
        let appearance = UITabBarItem.appearance()

        appearance.setTitleTextAttributes([NSFontAttributeName:UIFont.boldSystemFont(ofSize: 16), NSForegroundColorAttributeName: UIColor.gray], for: .normal)
        appearance.setTitleTextAttributes([NSFontAttributeName:UIFont.boldSystemFont(ofSize: 16), NSForegroundColorAttributeName: primaryColor], for: .selected)
        
        let tabBar = RecordTab
        tabBar?.selectionIndicatorImage = UIImage().createSelectionIndicator(color: primaryColor, size: CGSize(width: (tabBar?.frame.width)!/CGFloat((tabBar?.items!.count)!), height: (tabBar?.frame.height)!), lineWidth: 4.0)
        
        tabBar?.layer.borderWidth = 0.50
        tabBar?.layer.borderColor = UIColor.gray.cgColor
        tabBar?.clipsToBounds = true
}
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let screenSize: CGRect = UIScreen.main.bounds

        var tabFrame:CGRect = self.tabBar.frame
        tabFrame.origin.y = screenSize.height * 0.16
        self.tabBar.frame = tabFrame
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Hide the navigation bar on the this view controller
//        let screenSize: CGRect = UIScreen.main.bounds
//        RecordTab.frame = CGRect(x: 0, y: screenSize.height * 0.25, width: self.RecordTab.frame.width, height: self.RecordTab.frame.height)

        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
