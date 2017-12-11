//
//  MainView.swift
//  MyFirstApp
//
//  Created by 劉俊相 on 2017. 8. 8..
//  Copyright © 2017년 Joonsang Yoo. All rights reserved.
//


import UIKit


class MainView : UIViewController, XMLParserDelegate{
    
    var parser = XMLParser()        // 파서 객체
    
    var currentElement = ""       // 현재 Element
    var st = ""                 // 스테이터스 값 변수
    var countData = [String]()


    var frameView: UIView!
    var currentViewController:UIViewController?
    
    var positionValue :String?
    
    @IBOutlet weak var FirstView: UIView!
    @IBOutlet weak var menu1: UIView!
    @IBOutlet weak var menu2: UIView!
    @IBOutlet weak var menu3: UIView!
    @IBOutlet weak var menu4: UIView!
    @IBOutlet weak var menu5: UIView!
    @IBOutlet weak var menu6: UIView!
    @IBOutlet weak var menu7: UIView!
    
    @IBOutlet weak var menuImage1: UIImageView!
    @IBOutlet weak var menuImage2: UIImageView!
    @IBOutlet weak var menuImage3: UIImageView!
    @IBOutlet weak var menuImage4: UIImageView!
    @IBOutlet weak var menuImage5: UIImageView!
    @IBOutlet weak var menuImage6: UIImageView!
    @IBOutlet weak var menuImage7: UIImageView!
    
    @IBOutlet weak var rsvCorner: UIImageView!
    @IBOutlet weak var alarmCorner: UIImageView!
    @IBOutlet weak var todayCorner: UIImageView!
    
    @IBOutlet weak var rsvCount: UILabel!
    @IBOutlet weak var todayCount: UILabel!
    
    var webView: UIWebView!
    
    func setGradientBackground() {
        
        let colorTop =  UIColor(red: 17.0/255.0, green: 54.0/255.0, blue: 109.0/255.0, alpha: 1.0).cgColor
        
        let colorBottom = UIColor(red: 23.0/255.0, green: 70.0/255.0, blue: 142.0/255.0, alpha: 1.0).cgColor
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [ colorTop, colorBottom]
        gradientLayer.locations = [ 0.0, 1.0]
        gradientLayer.frame = self.view.bounds
        
        self.view.layer.addSublayer(gradientLayer)
    }
    
    
    struct xmlWriter {             // xml 작성을 위한 구조체
        var prtc: String
        
        init(prtc: String) {
            self.prtc = prtc
        }
        
        func xmlString() -> String {
            
            var xml = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
            xml += "<request>"
            xml += "<protocol>\(self.prtc)</protocol>"
            xml += "<userid>\(UserDefault.load(key: UserDefaultKey.UD_id))</userid>"
            xml += "<keycd>\(UserDefault.load(key: UserDefaultKey.UD_Key))</keycd>"
            xml += "</request>"
            
            //      for number in self.trackingNumbers {
            //                xml += "<TrackingNumber>\(number)</TrackingNumber>"
            //    }
            
            
            return xml
        }
    }

    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        //setGradientBackground()
        
        let supportView = UIView(frame: CGRect(x: 0, y: 0, width: 152, height: 32))
        supportView.contentMode = .scaleAspectFit
        
        let logo = UIImageView(image: UIImage(named: "gilLogo") ) //UIImage(named: "SelectAnAlbumTitleLettering")
        logo.frame = CGRect(x: 0, y: 0, width: supportView.frame.size.width, height: supportView.frame.size.height)
        supportView.addSubview(logo)
        supportView.contentMode = .center
        navigationItem.titleView = supportView
        
//        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
//        imageView.contentMode = .scaleAspectFit
//        let image = UIImage(named: "gilLogo")
//        imageView.image = image
//        navigationItem.titleView = imageView
        
        menuImage1.image = UIImage(named: "menuImage1")
        menuImage2.image = UIImage(named: "menuImage2")
        menuImage3.image = UIImage(named: "menuImage3")
        menuImage4.image = UIImage(named: "menuImage4")
        menuImage5.image = UIImage(named: "menuImage5")
        menuImage6.image = UIImage(named: "menuImage6")
        menuImage7.image = UIImage(named: "menuImage7")

        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named:"SideMenu"), style: .plain, target: self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)))
        navigationItem.leftBarButtonItem?.tintColor = UIColor.white
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named:"SideInfo"), style: .plain, target: self, action: #selector(infoButtonTapped(sender:)))
        navigationItem.rightBarButtonItem?.tintColor = UIColor.white
        

        
        menu1.layer.borderColor = UIColor.lightGray.cgColor
        menu1.layer.borderWidth = 0.5
        menu2.layer.borderColor = UIColor.lightGray.cgColor
        menu2.layer.borderWidth = 0.5
        menu3.layer.borderColor = UIColor.lightGray.cgColor
        menu3.layer.borderWidth = 0.5
        menu4.layer.borderColor = UIColor.lightGray.cgColor
        menu4.layer.borderWidth = 0.5
        menu5.layer.borderColor = UIColor.lightGray.cgColor
        menu5.layer.borderWidth = 0.5
        menu6.layer.borderColor = UIColor.lightGray.cgColor
        menu6.layer.borderWidth = 0.5
        
        let gesture = UITapGestureRecognizer(target: self, action:  #selector (self.checkAction(sender:)))
        
        
        self.menu1.addGestureRecognizer(UITapGestureRecognizer(target: self, action:  #selector (self.checkAction(sender:))))
        self.menu2.addGestureRecognizer(UITapGestureRecognizer(target: self, action:  #selector (self.checkAction(sender:))))
        self.menu3.addGestureRecognizer(UITapGestureRecognizer(target: self, action:  #selector (self.checkAction(sender:))))
        self.menu4.addGestureRecognizer(UITapGestureRecognizer(target: self, action:  #selector (self.checkAction(sender:))))
        self.menu5.addGestureRecognizer(UITapGestureRecognizer(target: self, action:  #selector (self.checkAction(sender:))))
        self.menu6.addGestureRecognizer(UITapGestureRecognizer(target: self, action:  #selector (self.checkAction(sender:))))
        self.menu7.addGestureRecognizer(UITapGestureRecognizer(target: self, action:  #selector (self.checkAction(sender:))))

       
        switch UIDevice().type {
        case .iPhoneSE:
            menu7.layer.cornerRadius = 40
            
        default:
            menu7.layer.cornerRadius = 45
        }
                
        if(positionValue == "로그아웃"){
            UserDefault.save(key: UserDefaultKey.UD_Ptntno, value: "0")
            dismiss(animated: true, completion: nil)

        }else if(positionValue != nil){
            let screenSize: CGRect = UIScreen.main.bounds

            frameView = UIView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height-64))
            frameView.tag = 84
            
            let textView = UILabel(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
            
            textView.contentMode = .scaleAspectFit
            textView.text = positionValue
            textView.textColor = UIColor.white
            textView.font = UIFont.boldSystemFont(ofSize: 20.0)
            navigationItem.titleView = textView
            
            print(screenSize.height)
            print(navigationController?.navigationBar.frame.height)
            view.addSubview(frameView)
            
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named:"SideHome"), style: .plain, target: self, action: #selector(infoButtonTapped(sender:)))
            navigationItem.rightBarButtonItem?.tintColor = UIColor.white

            if UserDefault.load(key: UserDefaultKey.UD_Staffyn) != "Y"{
                if positionValue == "원내전화"{
                    UserDefault.save(key: UserDefaultKey.UD_Ptntno, value: "0")
                    dismiss(animated: true, completion: nil)
                }else{
                    performSegue(withIdentifier: positionValue!, sender: nil)
                }
            }else{
                performSegue(withIdentifier: positionValue!, sender: nil)

            }
            
        }
        
        else{
          //  performSegue(withIdentifier: "메인화면", sender: nil)

        }
        // view.addSubview(parentView)
        // setColor()
        // setLayout()
    
}
    
    func checkAction(sender : UITapGestureRecognizer) {
        // Do what you want
        let tag = sender.view!.tag
        
        switch tag {
        case 1:
            let screenSize: CGRect = UIScreen.main.bounds
            
            frameView = UIView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height-64))
            frameView.tag = 84
            
            let textView = UILabel(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
            
            textView.contentMode = .scaleAspectFit
            textView.text = "진료기록"
            textView.textColor = UIColor.white
            textView.font = UIFont.boldSystemFont(ofSize: 20.0)
            navigationItem.titleView = textView
            
            print(screenSize.height)
            print(navigationController?.navigationBar.frame.height)
            view.addSubview(frameView)
            
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named:"SideHome"), style: .plain, target: self, action: #selector(infoButtonTapped(sender:)))
            navigationItem.rightBarButtonItem?.tintColor = UIColor.white

            performSegue(withIdentifier: "진료기록", sender: nil)
        case 2:
            //------------------------------------------------------------------//navibgation control
            let screenSize: CGRect = UIScreen.main.bounds
            
            frameView = UIView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height-64))
            frameView.tag = 84
            
            let textView = UILabel(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
            
            textView.contentMode = .scaleAspectFit
            textView.text = "진료예약"
            textView.textColor = UIColor.white
            textView.font = UIFont.boldSystemFont(ofSize: 20.0)
            navigationItem.titleView = textView
            
            print(screenSize.height)
            print(navigationController?.navigationBar.frame.height)
            view.addSubview(frameView)
            
            
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named:"SideHome"), style: .plain, target: self, action: #selector(infoButtonTapped(sender:)))
            navigationItem.rightBarButtonItem?.tintColor = UIColor.white
            //------------------------------------------------------------------//navibgation control
            
            performSegue(withIdentifier: "진료예약", sender: nil)
        case 3:
            let screenSize: CGRect = UIScreen.main.bounds
            
            frameView = UIView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height-64))
            frameView.tag = 84
            
            let textView = UILabel(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
            
            textView.contentMode = .scaleAspectFit
            textView.text = "복약알림"
            textView.textColor = UIColor.white
            textView.font = UIFont.boldSystemFont(ofSize: 20.0)
            navigationItem.titleView = textView
            
            print(screenSize.height)
            print(navigationController?.navigationBar.frame.height)
            view.addSubview(frameView)
            
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named:"SideHome"), style: .plain, target: self, action: #selector(infoButtonTapped(sender:)))
            navigationItem.rightBarButtonItem?.tintColor = UIColor.white

            performSegue(withIdentifier: "복약알림", sender: nil)
        case 4:
            let screenSize: CGRect = UIScreen.main.bounds
            
            frameView = UIView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height-64))
            frameView.tag = 84
            
            let textView = UILabel(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
            
            textView.contentMode = .scaleAspectFit
            textView.text = "건강검진"
            textView.textColor = UIColor.white
            textView.font = UIFont.boldSystemFont(ofSize: 20.0)
            navigationItem.titleView = textView
            
            print(screenSize.height)
            print(navigationController?.navigationBar.frame.height)
            view.addSubview(frameView)
            
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named:"SideHome"), style: .plain, target: self, action: #selector(infoButtonTapped(sender:)))
            navigationItem.rightBarButtonItem?.tintColor = UIColor.white


            performSegue(withIdentifier: "건강검진", sender: nil)
        case 5:
            let screenSize: CGRect = UIScreen.main.bounds
            
            frameView = UIView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height-64))
            frameView.tag = 84
            
            let textView = UILabel(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
            
            textView.contentMode = .scaleAspectFit
            textView.text = "개인정보"
            textView.textColor = UIColor.white
            textView.font = UIFont.boldSystemFont(ofSize: 20.0)
            navigationItem.titleView = textView
            
            print(screenSize.height)
            print(navigationController?.navigationBar.frame.height)
            view.addSubview(frameView)
            
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named:"SideHome"), style: .plain, target: self, action: #selector(infoButtonTapped(sender:)))
            navigationItem.rightBarButtonItem?.tintColor = UIColor.white

            performSegue(withIdentifier: "개인정보", sender: nil)
        case 6:
            let screenSize: CGRect = UIScreen.main.bounds
            
            frameView = UIView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height-64))
            frameView.tag = 84
            
            let textView = UILabel(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
            
            textView.contentMode = .scaleAspectFit
            textView.text = "오늘진료"
            textView.textColor = UIColor.white
            textView.font = UIFont.boldSystemFont(ofSize: 20.0)
            navigationItem.titleView = textView
            
            print(screenSize.height)
            print(navigationController?.navigationBar.frame.height)
            view.addSubview(frameView)
            
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named:"SideHome"), style: .plain, target: self, action: #selector(infoButtonTapped(sender:)))
            navigationItem.rightBarButtonItem?.tintColor = UIColor.white


            performSegue(withIdentifier: "오늘진료", sender: nil)
        case 7:
            let screenSize: CGRect = UIScreen.main.bounds
            
            frameView = UIView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height-64))
            frameView.tag = 84
            
            
            let textView = UILabel(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
            
            textView.contentMode = .scaleAspectFit
            textView.text = "진료카드"
            textView.textColor = UIColor.white
            textView.font = UIFont.boldSystemFont(ofSize: 20.0)
            navigationItem.titleView = textView
            
            print(screenSize.height)
            print(navigationController?.navigationBar.frame.height)
           // view.addSubview(frameView)
            UIView.transition(with: self.view, duration: 0.8, options: UIViewAnimationOptions.curveEaseOut, animations: {self.view.addSubview(self.frameView)}, completion: nil)
            
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named:"SideHome"), style: .plain, target: self, action: #selector(infoButtonTapped(sender:)))
            navigationItem.rightBarButtonItem?.tintColor = UIColor.white

            performSegue(withIdentifier: "진료카드", sender: nil)
        default:
            print("default")
        }


        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let postString = xmlWriter(prtc: "count").xmlString()
        _ = HttpClient.requestXML(Xml: postString){ responseString in
            // print(responseString)
            let dataXML = responseString.data(using: .utf8)
            
            self.parser = XMLParser(data: dataXML!)
            self.parser.delegate = self
            
            let success:Bool = self.parser.parse()
            if success {
                print("parse success!")
                
                if self.st == "100"{        // 리스폰스 스테이터스가 100(성공)일때
                    // DispatchQueue.main.async -> ui가 대기상태에서 특정 조건에서 화면전환시 멈추는 현상을 없애기 위한 명령어(비동기제어)
                    DispatchQueue.main.async{
                        self.rsvCount.text = self.countData[0]
                        self.todayCount.text = self.countData[2]
                        if self.countData[0] != "0"{
                            self.rsvCorner.isHidden = false
                        } else {
                            self.rsvCorner.isHidden = true
                        }
                        
                        if self.countData[2] != "0"{
                            self.todayCorner.isHidden = false
                            } else {
                            self.todayCorner.isHidden = true
                        }
                        
                    }
                }else {         // 리스폰스 스테이터스 100이 아닐때 (ex: 200번(실패) 3~500번 등등 추가조건 구현가능)
                    DispatchQueue.main.async{
                        
                    }
                }
            } else{
                print("parse failure!")
            }
        }
        
        
    }



    
    func infoButtonTapped(sender: UIBarButtonItem) {
        
        if let viewWithTag = self.view.viewWithTag(84) {
            viewWithTag.removeFromSuperview()
            
            let supportView = UIView(frame: CGRect(x: 0, y: 0, width: 152, height: 32))
            supportView.contentMode = .scaleAspectFit
            
            let logo = UIImageView(image: UIImage(named: "gilLogo") ) //UIImage(named: "SelectAnAlbumTitleLettering")
            logo.frame = CGRect(x: 0, y: 0, width: supportView.frame.size.width, height: supportView.frame.size.height)
            supportView.addSubview(logo)
            supportView.contentMode = .center
            navigationItem.titleView = supportView
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named:"SideInfo"), style: .plain, target: self, action: #selector(infoButtonTapped(sender:)))
            navigationItem.rightBarButtonItem?.tintColor = UIColor.white
            
            viewWillAppear(true)
            
        }else{
            performSegue(withIdentifier: "segInfo", sender: nil)
        }
        
    }
    


    // XML 파서가 시작 테그를 만나면 호출됨
    public func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:])
    {
        currentElement = elementName
        
        if (elementName == "response") {
            st = attributeDict["status"]!
            
        }
    }



    // 현재 테그에 담겨있는 문자열 전달
    public func parser(_ parser: XMLParser, foundCharacters string: String)
    {
        switch currentElement {
        case "rsrvcnt":
            countData.append(string)
        case "todaycnt":
            countData.append(string)

        default:break
        }
    }
}
public enum Model : String {
    case simulator   = "simulator/sandbox",
    iPod1            = "iPod 1",
    iPod2            = "iPod 2",
    iPod3            = "iPod 3",
    iPod4            = "iPod 4",
    iPod5            = "iPod 5",
    iPad2            = "iPad 2",
    iPad3            = "iPad 3",
    iPad4            = "iPad 4",
    iPhone4          = "iPhone 4",
    iPhone4S         = "iPhone 4S",
    iPhone5          = "iPhone 5",
    iPhone5S         = "iPhone 5S",
    iPhone5C         = "iPhone 5C",
    iPadMini1        = "iPad Mini 1",
    iPadMini2        = "iPad Mini 2",
    iPadMini3        = "iPad Mini 3",
    iPadAir1         = "iPad Air 1",
    iPadAir2         = "iPad Air 2",
    iPadPro9_7       = "iPad Pro 9.7\"",
    iPadPro9_7_cell  = "iPad Pro 9.7\" cellular",
    iPadPro12_9      = "iPad Pro 12.9\"",
    iPadPro12_9_cell = "iPad Pro 12.9\" cellular",
    iPhone6          = "iPhone 6",
    iPhone6plus      = "iPhone 6 Plus",
    iPhone6S         = "iPhone 6S",
    iPhone6Splus     = "iPhone 6S Plus",
    iPhoneSE         = "iPhone SE",
    iPhone7          = "iPhone 7",
    iPhone7plus      = "iPhone 7 Plus",
    unrecognized     = "?unrecognized?"
}

public extension UIDevice {
    public var type: Model {
        var systemInfo = utsname()
        uname(&systemInfo)
        let modelCode = withUnsafePointer(to: &systemInfo.machine) {
            $0.withMemoryRebound(to: CChar.self, capacity: 1) {
                ptr in String.init(validatingUTF8: ptr)
                
            }
        }
        var modelMap : [ String : Model ] = [
            "i386"      : .simulator,
            "x86_64"    : .simulator,
            "iPod1,1"   : .iPod1,
            "iPod2,1"   : .iPod2,
            "iPod3,1"   : .iPod3,
            "iPod4,1"   : .iPod4,
            "iPod5,1"   : .iPod5,
            "iPad2,1"   : .iPad2,
            "iPad2,2"   : .iPad2,
            "iPad2,3"   : .iPad2,
            "iPad2,4"   : .iPad2,
            "iPad2,5"   : .iPadMini1,
            "iPad2,6"   : .iPadMini1,
            "iPad2,7"   : .iPadMini1,
            "iPhone3,1" : .iPhone4,
            "iPhone3,2" : .iPhone4,
            "iPhone3,3" : .iPhone4,
            "iPhone4,1" : .iPhone4S,
            "iPhone5,1" : .iPhone5,
            "iPhone5,2" : .iPhone5,
            "iPhone5,3" : .iPhone5C,
            "iPhone5,4" : .iPhone5C,
            "iPad3,1"   : .iPad3,
            "iPad3,2"   : .iPad3,
            "iPad3,3"   : .iPad3,
            "iPad3,4"   : .iPad4,
            "iPad3,5"   : .iPad4,
            "iPad3,6"   : .iPad4,
            "iPhone6,1" : .iPhone5S,
            "iPhone6,2" : .iPhone5S,
            "iPad4,1"   : .iPadAir1,
            "iPad4,2"   : .iPadAir2,
            "iPad4,4"   : .iPadMini2,
            "iPad4,5"   : .iPadMini2,
            "iPad4,6"   : .iPadMini2,
            "iPad4,7"   : .iPadMini3,
            "iPad4,8"   : .iPadMini3,
            "iPad4,9"   : .iPadMini3,
            "iPad6,3"   : .iPadPro9_7,
            "iPad6,11"  : .iPadPro9_7,
            "iPad6,4"   : .iPadPro9_7_cell,
            "iPad6,12"  : .iPadPro9_7_cell,
            "iPad6,7"   : .iPadPro12_9,
            "iPad6,8"   : .iPadPro12_9_cell,
            "iPhone7,1" : .iPhone6plus,
            "iPhone7,2" : .iPhone6,
            "iPhone8,1" : .iPhone6S,
            "iPhone8,2" : .iPhone6Splus,
            "iPhone8,4" : .iPhoneSE,
            "iPhone9,1" : .iPhone7,
            "iPhone9,2" : .iPhone7plus,
            "iPhone9,3" : .iPhone7,
            "iPhone9,4" : .iPhone7plus
        ]
        
        if let model = modelMap[String.init(validatingUTF8: modelCode!)!] {
            return model
        }
        return Model.unrecognized
    }
}


