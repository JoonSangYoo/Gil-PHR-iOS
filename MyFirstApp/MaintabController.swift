//
//  MaintabController.swift
//  MyFirstApp
//
//  Created by 조윤성 on 2017. 10. 20..
//  Copyright © 2017년 Joonsang Yoo. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    func createSelectionIndicator(color: UIColor, size: CGSize, lineWidth: CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(CGRect(origin: CGPoint(x: 0,y :size.height - lineWidth), size: CGSize(width: size.width, height: lineWidth)))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}

class MaintabController : UITabBarController{
    @IBOutlet weak var resTab: UITabBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        let appearance = UITabBarItem.appearance()
        let attributes: [String: AnyObject] = [NSFontAttributeName:UIFont.boldSystemFont(ofSize: 14.0)]
        appearance.setTitleTextAttributes(attributes, for: .normal)
        
        let primaryColor = UIColor(red: 23.0/255.0, green: 70.0/255.0, blue: 142.0/255.0, alpha: 1.0)
        
        let tabBar = resTab
        tabBar?.selectionIndicatorImage = UIImage().createSelectionIndicator(color: primaryColor, size: CGSize(width: (tabBar?.frame.width)!/CGFloat((tabBar?.items!.count)!), height: (tabBar?.frame.height)!), lineWidth: 4.0)
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        var tabFrame:CGRect = self.tabBar.frame
        tabFrame.origin.y = self.view.frame.origin.y// + UIScreen.main.bounds.size.height/3
        self.tabBar.frame = tabFrame
    }
}
