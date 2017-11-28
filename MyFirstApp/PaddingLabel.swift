//
//  PaddingLabel.swift
//  MyFirstApp
//
//  Created by 劉俊相 on 2017. 11. 15..
//  Copyright © 2017년 Joonsang Yoo. All rights reserved.
//

import Foundation

class PaddingLabel: UILabel {
    
    // paddingの値
    let padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    
    override func drawText(in rect: CGRect) {
        let newRect = UIEdgeInsetsInsetRect(rect, padding)
        super.drawText(in: newRect)
    }
    
    override func invalidateIntrinsicContentSize() {
        var intrinsicContentSize = super.intrinsicContentSize
        intrinsicContentSize.height += padding.top + padding.bottom
        intrinsicContentSize.width += padding.left + padding.right
    }
    

}
