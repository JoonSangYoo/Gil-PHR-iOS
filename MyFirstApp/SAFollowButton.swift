//
//  SAFollowButton.swift
//  ToggleButton
//
//  Created by Sean Allen on 6/21/17.
//  Copyright © 2017 Sean Allen. All rights reserved.
//

import UIKit

class SAFollowButton: UIButton {
    
    var isOn = false
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initButton()
    }
    
    func initButton() {
        layer.borderWidth = 2.0
        layer.borderColor = UIColor(red: 126/255.0, green: 158/255.0, blue: 220/255.0, alpha: 1.0).cgColor
        layer.cornerRadius = frame.size.height/2
        
        
        
        addTarget(self, action: #selector(SAFollowButton.buttonPressed), for: .touchUpInside)
    }
    
    func buttonPressed() {
        activateButton(bool: !isOn)
    }
    
    func activateButton(bool: Bool) {
        
        isOn = bool
        
        let color = bool ? UIColor(red: 126/255.0, green: 158/255.0, blue: 220/255.0, alpha: 1.0) : .clear
        let title = bool ? "알람 켜짐" : "알람 꺼짐"
        let titleColor = bool ? .white : UIColor(red: 126/255.0, green: 158/255.0, blue: 220/255.0, alpha: 1.0)
        
        setTitle(title, for: .normal)
        setTitleColor(titleColor, for: .normal)
        backgroundColor = color
    }

    
}
