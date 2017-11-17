//
//  OPcell.swift
//  MyFirstApp
//
//  Created by 劉俊相 on 2017. 11. 10..
//  Copyright © 2017년 Joonsang Yoo. All rights reserved.
//

import Foundation
import DLRadioButton

class OPcell: UITableViewCell{
    
    let primaryColor = UIColor(red: 23.0/255.0, green: 70.0/255.0, blue: 142.0/255.0, alpha: 1.0)

    
    @IBOutlet weak var opdDateLabel: UILabel!
    @IBOutlet weak var deptDocNameLabel: UILabel!
    

    @IBOutlet weak var radioButton: LTHRadioButton!
    

    
//
//    func update(with color: UIColor) {
//        
//        backgroundColor = color
//        self.radioButton.selectedColor   = color == .darkGray ? .white : selectedColor
//        self.radioButton.deselectedColor = color == .darkGray ? .lightGray : deselectedColor
//    }

    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let newBound = CGRect(
            x: self.bounds.origin.x,
            y: self.bounds.origin.y,
            width: self.bounds.width,
            height: self.bounds.height
        )
        return newBound.contains(point)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            return self.radioButton.select(animated: animated)
        }
        
        self.radioButton.deselect(animated: animated)
    }

    
    
}


