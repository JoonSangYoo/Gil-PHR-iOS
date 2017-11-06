//
//  Barcode.swift
//  MyFirstApp
//
//  Created by 劉俊相 on 2017. 9. 19..
//  Copyright © 2017년 Joonsang Yoo. All rights reserved.
//

import Foundation
import CoreImage

class Barcode {
    
    class func fromString(string : String) -> UIImage? {
        
        let data = string.data(using: .ascii)
        let filter = CIFilter(name: "CICode128BarcodeGenerator")
        filter?.setValue(data, forKey: "inputMessage")
        
        return UIImage(ciImage: (filter?.outputImage)!)
    }
    
}
