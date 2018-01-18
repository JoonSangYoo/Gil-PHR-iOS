//
//  TodayCell.swift
//  MyFirstApp
//
//  Created by 劉俊相 on 2018. 1. 15..
//  Copyright © 2018년 Joonsang Yoo. All rights reserved.
//

import Foundation

class TodayCell: UITableViewCell{
    
    let primaryColor = UIColor(red: 23.0/255.0, green: 70.0/255.0, blue: 142.0/255.0, alpha: 1.0)
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var deptDocLabel: UILabel!
    
    @IBOutlet weak var docMajorLabel: UILabel!
    
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var guideLabel: UILabel!
    @IBOutlet weak var waitLabel: UILabel!
    @IBOutlet weak var refreshTimeLabel: UILabel!
    
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
