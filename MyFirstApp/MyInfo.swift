//
//  MyInfo.swift
//  MyFirstApp
//
//  Created by 劉俊相 on 2017. 12. 1..
//  Copyright © 2017년 Joonsang Yoo. All rights reserved.
//

import Foundation


class MyInfo: UIViewController {
    
    let tag = TagNumList.miTag
    
    @IBOutlet weak var ptntNumView: UIView!

    @IBOutlet weak var phrView: UIView!

    @IBOutlet weak var changeView: UIView!
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.ptntNumView.addGestureRecognizer(UITapGestureRecognizer(target: self, action:  #selector (self.checkAction(sender:))))
        self.phrView.addGestureRecognizer(UITapGestureRecognizer(target: self, action:  #selector (self.checkAction(sender:))))
        self.changeView.addGestureRecognizer(UITapGestureRecognizer(target: self, action:  #selector (self.checkAction(sender:))))

        
    }
    
    func checkAction(sender : UITapGestureRecognizer) {
        let tag = sender.view!.tag
        switch tag {
        case 71:
                
            
            print("ptnt")
        case 72:
            print("phr")
            performSegue(withIdentifier: "psnSave", sender: self)
        case 73:
            print("change")
            performSegue(withIdentifier: "psnChange", sender: self)

        default:
            break
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)

        
    }
    
}

