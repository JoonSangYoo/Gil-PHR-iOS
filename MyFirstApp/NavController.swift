//
//  NavController.swift
//  MyFirstApp
//
//  Created by 劉俊相 on 2017. 8. 30..
//  Copyright © 2017년 Joonsang Yoo. All rights reserved.
//

import UIKit

class NavController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let arrayStr = [ "진료기록", "진료예약", "복약알림", "건강검진", "개인정보", "오늘진료", "진료카드", "원내전화", "로그아웃"]
    let arrayImg = [#imageLiteral(resourceName: "navImg1"), #imageLiteral(resourceName: "ic_02"), #imageLiteral(resourceName: "ic_03"), #imageLiteral(resourceName: "ic_04"), #imageLiteral(resourceName: "ic_05"), #imageLiteral(resourceName: "ic_06"), #imageLiteral(resourceName: "ic_07"), #imageLiteral(resourceName: "ic_08"), #imageLiteral(resourceName: "ic_09") ]
    
    let arrayStr2 = [ "진료기록", "진료예약", "복약알림", "건강검진", "개인정보", "오늘진료", "진료카드", "로그아웃"]
    let arrayImg2 = [#imageLiteral(resourceName: "navImg1"), #imageLiteral(resourceName: "ic_02"), #imageLiteral(resourceName: "ic_03"), #imageLiteral(resourceName: "ic_04"), #imageLiteral(resourceName: "ic_05"), #imageLiteral(resourceName: "ic_06"), #imageLiteral(resourceName: "ic_07"), #imageLiteral(resourceName: "ic_09") ]
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.gilTap(sender:))))
       
    }
    
    func gilTap(sender : UITapGestureRecognizer) {
        // Do what you want

        dismiss(animated: true, completion: nil)
        
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if UserDefault.load(key: UserDefaultKey.UD_Staffyn) == "Y"{
            return arrayStr.count
        } else{
            return arrayStr2.count
        }
        
    }
    
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell1 = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as! CustomCell
        
        if UserDefault.load(key: UserDefaultKey.UD_Staffyn) == "Y"{
            cell1.name.text = arrayStr[indexPath.row]
            cell1.navImg.image = arrayImg[indexPath.row]
            
        } else{
            cell1.name.text = arrayStr2[indexPath.row]
            cell1.navImg.image = arrayImg2[indexPath.row]
            
        }

        
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 1))
        
        cell1.preservesSuperviewLayoutMargins = false
        cell1.separatorInset = UIEdgeInsets.zero
        cell1.layoutMargins = UIEdgeInsets.zero
        
        if indexPath.row != 5 {
            cell1.separatorInset = UIEdgeInsetsMake(0, cell1.bounds.width/2.0, 0, cell1.bounds.width/2.0)
        }

        return cell1
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationNavigation = segue.destination as! UINavigationController
        let destinationViewController = destinationNavigation.topViewController as! MainView
        
        destinationViewController.positionValue = arrayStr[self.tableView.indexPathForSelectedRow!.row]
    }
    
    
    
    
}

class CustomCell: UITableViewCell {
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var navImg: UIImageView!
    
}
