//
//  File.swift
//  MyFirstApp
//
//  Created by 劉俊相 on 2017. 8. 10..
//  Copyright © 2017년 Joonsang Yoo. All rights reserved.
//

import Foundation


class CellCharacter: UICollectionViewCell, SlotableCell {
    
    
    var slotParams: [String : Any] = [:]
    
    func load() {
        let paramRace = slotParams["race"] as? String
        
        switch paramRace {
        case "undead"?:
            image.image = UIImage(named: "undead")!
        case "elves"?:
            image.image = UIImage(named: "elves")!
        case "troll"?:
            image.image = UIImage(named: "troll")!
        default:
            print("invalid race: \(paramRace ?? "nil")")
        }
    }
}
