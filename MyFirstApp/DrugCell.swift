//
//  DrugCell.swift
//  MyFirstApp
//
//  Created by 劉俊相 on 2017. 11. 23..
//  Copyright © 2017년 Joonsang Yoo. All rights reserved.
//

import Foundation


class DrugCell: UITableViewCell{
    
    let primaryColor = UIColor(red: 23.0/255.0, green: 70.0/255.0, blue: 142.0/255.0, alpha: 1.0)
    

    @IBOutlet weak var drugnmLabel: UILabel!
    @IBOutlet weak var qtyLabel: UILabel!
    @IBOutlet weak var unitLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    
    @IBOutlet weak var ordDate2Label: UILabel!
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
    
    
    
}
