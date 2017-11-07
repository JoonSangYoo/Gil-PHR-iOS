//
//  Record.swift
//  MyFirstApp
//
//  Created by 劉俊相 on 2017. 9. 18..
//  Copyright © 2017년 Joonsang Yoo. All rights reserved.
//

import UIKit

class Record: UIViewController {
    
    
    @IBOutlet weak var img: UIImageView!
    
    struct ItemTrackingRequest {
        var trackingNumbers: [String]
        
        init(trackingNumbers: String...) {
            self.trackingNumbers = trackingNumbers
        }
        
        func xmlString() -> String {
            var xml = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
            xml += "<request>"
            xml += "<protocol>login</protocol>"
            xml += "<userid>wnstkd13</userid>"
            xml += "<pwd>test5782</pwd>"
            xml += "</request>"
            
      //      for number in self.trackingNumbers {
//                xml += "<TrackingNumber>\(number)</TrackingNumber>"
        //    }
            
            
            return xml
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //ㅁㄴㅇㅇㄴㅇㅁㅇㄴㅁㅇㅁㄴㅇㄴㅇㄴㅇ
        img.contentMode = .scaleAspectFit
        let image = Barcode.fromString(string: "11657673")
        img.image = image
        

        // Do any additional setup after loading the view, typically from a nib.
        var request = URLRequest(url: URL(string: "https://ucare.gilhospital.com/phr2/gateway.aspx")!)
        //let postString = "<?xml version=\"1.0\" encoding=\"UTF-8\"?><request><protocol>login</protocol><userid>nayana</userid><pwd>test5782</pwd></request>"
        
        let postString = ItemTrackingRequest(trackingNumbers: "SMT0000000628").xmlString()
        
        request.httpMethod = "POST"
        request.httpBody = postString.data(using: .utf8)
}
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
