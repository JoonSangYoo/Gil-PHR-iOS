//
//  MyInfo.swift
//  MyFirstApp
//
//  Created by 劉俊相 on 2017. 12. 1..
//  Copyright © 2017년 Joonsang Yoo. All rights reserved.
//

import Foundation


class MyInfo: UIViewController {
    
    let tag = TagNumList.miTag
    
    @IBOutlet weak var ptntNumView: UIView!
    @IBOutlet weak var phrView: UIView!
    @IBOutlet weak var changeView: UIView!
  
    @IBOutlet weak var ptntLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.ptntNumView.addGestureRecognizer(UITapGestureRecognizer(target: self, action:  #selector (self.checkAction(sender:))))
        self.phrView.addGestureRecognizer(UITapGestureRecognizer(target: self, action:  #selector (self.checkAction(sender:))))
        self.changeView.addGestureRecognizer(UITapGestureRecognizer(target: self, action:  #selector (self.checkAction(sender:))))
        
        if UserDefault.load(key: UserDefaultKey.UD_Ptntno) == "\n  " || UserDefault.load(key: UserDefaultKey.UD_Ptntno) == ""{
            self.ptntLabel.text = "병원등록번호 찾기 (재로그인 필요)"
        }else{
            self.ptntLabel.text = "병원등록번호  \(UserDefault.load(key: UserDefaultKey.UD_Ptntno))"
        }
        
    }
    
    func checkAction(sender : UITapGestureRecognizer) {
        let tag = sender.view!.tag
        switch tag {
        case 71:
            if UserDefault.load(key: UserDefaultKey.UD_Ptntno) == "\n  " || UserDefault.load(key: UserDefaultKey.UD_Ptntno) == ""
            {
                UIApplication.shared.open(URL(string: "https://www.gilhospital.com/phr/findptntno.html?id=\(UserDefault.load(key: UserDefaultKey.UD_id))&keycd=\(UserDefault.load(key: UserDefaultKey.UD_Key))")!, options: [:], completionHandler: nil)
            }else{
                let alert = UIAlertController(title: "병원등록번호", message: "환자번호가 이미 있습니다.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "닫기", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        case 72:
            print("phr")
            performSegue(withIdentifier: "psnSave", sender: self)
        case 73:
            print("change")
            performSegue(withIdentifier: "psnChange", sender: self)

        default:
            break
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)

        
    }
    
}

