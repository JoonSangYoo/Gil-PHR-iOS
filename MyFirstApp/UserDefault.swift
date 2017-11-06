//
//  UserDefault.swift
//  MyFirstApp
//
//  Created by 劉俊相 on 2017. 9. 21..
//  Copyright © 2017년 Joonsang Yoo. All rights reserved.
//

import Foundation

class UserDefault{
    class func save(key:String, value:String){
        let userDefaults = UserDefaults.standard
        userDefaults.setValue(value, forKey: key)
        userDefaults.synchronize()
    }
    
    class func load(key:String) -> String {
        let userDefaults = UserDefaults.standard
        if let value = userDefaults.value(forKey: key) as? String {
            return value
        } else {
            return ""
        }
    }
    
    class func delete(key:String) {
        let userDefaults = UserDefaults.standard
        userDefaults.removeObject(forKey: key)
    }
}
