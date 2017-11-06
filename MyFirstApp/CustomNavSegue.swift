//
//  CustomNavSegue.swift
//  MyFirstApp
//
//  Created by 劉俊相 on 2017. 9. 7..
//  Copyright © 2017년 Joonsang Yoo. All rights reserved.
//

import UIKit

class CustomNavSegue: UIStoryboardSegue {
    override func perform() {
        
        let viewController : MainView = self.source as! MainView
        let destinationController : UIViewController = self.destination
        
        for view in (viewController.frameView!.subviews){
            view.removeFromSuperview()
        }
        
        let childView : UIView = destination.view
        viewController.currentViewController = destinationController
        viewController.frameView.addSubview(childView)
        
        childView.translatesAutoresizingMaskIntoConstraints = false
        childView.topAnchor.constraint(equalTo: viewController.frameView.topAnchor).isActive = true
        childView.bottomAnchor.constraint(equalTo: viewController.frameView.bottomAnchor).isActive = true
        childView.leftAnchor.constraint(equalTo: viewController.frameView.leftAnchor).isActive = true
        childView.rightAnchor.constraint(equalTo: viewController.frameView.rightAnchor).isActive = true

        
    }
}
