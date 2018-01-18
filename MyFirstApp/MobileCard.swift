//
//  MobileCard.swift
//  MyFirstApp
//
//  Created by 劉俊相 on 2017. 11. 7..
//  Copyright © 2017년 Joonsang Yoo. All rights reserved.
//

import UIKit

class MobileCard: UIViewController {
    
    
    
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var ptntNumLabel: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()


        ptntNumLabel.text = "환자번호  \(UserDefault.load(key: UserDefaultKey.UD_Ptntno))"
        img.contentMode = .scaleAspectFit
        let image = Barcode.fromString(string: UserDefault.load(key: UserDefaultKey.UD_Ptntno))
        img.image = image
            
        img.transform = img.transform.rotated(by: CGFloat(M_PI_2))
        ptntNumLabel.transform = ptntNumLabel.transform.rotated(by: CGFloat(M_PI_2))

        
        // Do any additional setup after loading the view, typically from a nib.
       
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
