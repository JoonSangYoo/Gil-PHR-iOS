//
//  HttpClient.swift
//  MyFirstApp
//
//  Created by 劉俊相 on 2017. 9. 21..
//  Copyright © 2017년 Joonsang Yoo. All rights reserved.
//

import Foundation

class HttpClient {
    var responseString: String = ""

    class func requestXML(Xml: String, completion:  @escaping (String) -> ()) {
    
        var request = URLRequest(url: URL(string: "https://ucare.gilhospital.com/phr2/gateway.aspx")!)
        var responseString: String = "ㄴㄴㄴ"
        
        request.httpMethod = "POST"
        request.httpBody = Xml.data(using: .utf8)
        print(String(Xml)!)
        
        let task = URLSession.shared.dataTask(with: request) {
            data, response, error in
            guard let data = data, error == nil else {
                // check for fundamental networking error
                print("error=\(error)")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
               print("response = \(response)")

            }else{
                responseString = String(data: data, encoding: .utf8)!
               print("responseString = \(responseString)")
                completion(responseString)
            }


        }
        task.resume()
        

    }
    
    
}


