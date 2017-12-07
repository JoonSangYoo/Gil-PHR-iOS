//
//  PsnChange.swift
//  MyFirstApp
//
//  Created by 劉俊相 on 2017. 12. 4..
//  Copyright © 2017년 Joonsang Yoo. All rights reserved.
//

import Foundation


class PsnChange: UIViewController {
    
    @IBOutlet weak var HomeURL: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        HomeURL.attributedText = NSAttributedString(string: "www.gilhospital.com", attributes:
            [NSUnderlineStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue])
        
        self.HomeURL.addGestureRecognizer(UITapGestureRecognizer(target: self, action:  #selector (self.checkAction(sender:))))
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Hide the navigation bar on the this view controller
        self.navigationController?.navigationBar.barTintColor = UIColor.primaryColor
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    func checkAction(sender : UITapGestureRecognizer) {
        performSegue(withIdentifier: "gilHome", sender: self)
    }
    
}
