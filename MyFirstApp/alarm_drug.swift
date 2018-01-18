

import Foundation
import UserNotifications
import UIKit

class alarm_drug : UIViewController, XMLParserDelegate{
    
    var plag : Int = 0
    var sec_plag : Int = 0
    @IBOutlet weak var start_day: UITextField!
    @IBOutlet weak var end_day: UITextField!
    @IBOutlet weak var getup_time: UITextField!
    @IBOutlet weak var bed_time: UITextField!
    @IBOutlet weak var breakfast_time: UITextField!
    @IBOutlet weak var lunch_time: UITextField!
    @IBOutlet weak var dinner_time: UITextField!
    
    
    
    let datepicker = UIDatePicker()
    let getup_timepicker = UIDatePicker()
    let bed_timepicker = UIDatePicker()
    let breakfast_timepicker = UIDatePicker()
    let lunch_timepicker = UIDatePicker()
    let dinner_timepicker = UIDatePicker()
    let end_datepicker = UIDatePicker()
    
    @IBOutlet weak var getup_sw: UISwitch!
    @IBOutlet weak var bed_sw: UISwitch!
    @IBOutlet weak var before_break_sw: UISwitch!
    @IBOutlet weak var after_break_sw: UISwitch!
    @IBOutlet weak var before_lunch_sw: UISwitch!
    @IBOutlet weak var after_lunch_sw: UISwitch!
    @IBOutlet weak var before_dinner_sw: UISwitch!
    @IBOutlet weak var after_dinner_sw: UISwitch!
    
    @IBOutlet weak var dateSetting: UIButton!
    
    
    var set_time = Date()
    
    
    var postString = ""
    var parser = XMLParser()        // 파서 객체
    var st = ""                 // 스테이터스 값 변수
    var currentElement = ""       // 현재 Element
    var startdate = ""
    var enddate = ""
    var startat = ""
    var endat = ""
    var tempdate = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        
        start_day.addBorderBottom(height: 1.0, color: UIColor.lightGray)
        end_day.addBorderBottom(height: 1.0, color: UIColor.lightGray)
        getup_time.addBorderBottom(height: 1.0, color: UIColor.lightGray)
        bed_time.addBorderBottom(height: 1.0, color: UIColor.lightGray)
        breakfast_time.addBorderBottom(height: 1.0, color: UIColor.lightGray)
        lunch_time.addBorderBottom(height: 1.0, color: UIColor.lightGray)
        dinner_time.addBorderBottom(height: 1.0, color: UIColor.lightGray)

        
        data_load()
       

        startDatePicker()
        endDatePicker()
        getupDatePicker()
        bedDatePicker()
        breakfastDatePicker()
        lunchDatePicker()
        dinnerDatePicker()
        
            
    }
    
    
    override func viewWillAppear(_ animated: Bool) {

    }
    
    
    
    @IBOutlet weak var alarm_buttonout: SAFollowButton!
    
    @IBAction func alarm_button(_ sender: Any) {
        if(alarm_buttonout.isOn == true){
            //알람 켜짐
            UserDefault.save(key: UserDefaultKey.alarm_onoff, value: "on")
        }
        else{
            //알람 꺼짐
            UserDefault.save(key: UserDefaultKey.alarm_onoff, value: "off")
        }
        data_load()
  //      self.data_store()
 //       viewDidLoad()
    }
    
    @IBAction func date_setting(_ sender: Any) {
        http_request(request_code: "date_setting")
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
            return xml
        }
    }
    
    func http_request(request_code: String){
        UIApplication.shared.endIgnoringInteractionEvents()
        if(request_code == "date_setting"){
            postString = xmlWriter(prtc: "drugspan").xmlString()
        }
        HttpClient.requestXML(Xml: postString){
            responseString in
            let dataXML = responseString.data(using: .utf8)
            self.parser = XMLParser(data: dataXML!)
            self.parser.delegate = self
            
            let success:Bool = self.parser.parse()
            if success {
                print("parse success!")
                
                if self.st == "100"{        // 리스폰스 스테이터스가 100(성공)일때
                    DispatchQueue.main.async{
                        self.viewDidLoad()
                        self.startdate = self.startdate.replacingOccurrences(of: "\n  ", with: "")
                        self.enddate = self.enddate.replacingOccurrences(of: "\n  ", with: "")
                        self.start_day.text = self.weekdayForm(dateString: self.startdate)
                        self.end_day.text = self.weekdayForm(dateString: self.enddate)
                        
                        self.data_store()
                    }
                }
                else{
                    DispatchQueue.main.async{
                    }
                }
            } else{
                print("parse failure!")
            }
        }
    }
    
    public func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:])
    {
        currentElement = elementName
        if (elementName == "response"){
            st = attributeDict["status"]!
        }
        if(elementName == "startdate"){
            startdate = String()
        }
        if(elementName == "enddate"){
            enddate = String()
        }
    }
    
    public func parser(_ parser: XMLParser, foundCharacters string: String)
    {
        switch currentElement
        {
        case "startdate":
            startdate = startdate + string
        case "startat":
            startat = startat + string
        case "enddate":
            enddate = enddate + string
        case "endat":
            endat = endat + string
        default:
            break
        }
    }
    
    
    //---------------------------------------------시작날짜
    func startDatePicker(){
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let done = UIBarButtonItem(title: "확인", style: .plain, target: self, action: #selector(donePicker))
        toolbar.setItems([done], animated: false)
        
        start_day.inputAccessoryView = toolbar
        start_day.inputView  = datepicker
        datepicker.datePickerMode = .date
    }
    func donePicker (sender:UIBarButtonItem)
    {
        tempdate = self.formatter.string(from: datepicker.date)

//        문자열에서 숫자만 골라내는 처리
        let intString = end_day.text?.components(
            separatedBy: NSCharacterSet
                .decimalDigits
                .inverted)
            .joined(separator: "")
        
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyyMMdd"

        if(tempdate<=intString!){
            startdate = tempdate
            start_day.text = "\(weekdayForm(dateString: tempdate))"
            self.view.endEditing(true)
            UserDefault.save(key: UserDefaultKey.alarm_startdate, value: startdate)
            pickerDoneAlarm()
        } else if(start_day.text == "yyyy-MM-dd" || start_day.text == ""){
            startdate = tempdate
            start_day.text = "\(weekdayForm(dateString: tempdate))"
            self.view.endEditing(true)
            UserDefault.save(key: UserDefaultKey.alarm_startdate, value: startdate)
            pickerDoneAlarm()
        }
        
        else{
            self.view.endEditing(true)
            print("s\(start_day.text!)a")
            let alert = UIAlertController(title: "오류", message: "알림 시작일을 종료일 이전으로 설정하세요.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "확인", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
 

    }
    //---------------------------------------------시작날짜 end
    
    //---------------------------------------------종료날짜
    func endDatePicker(){
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let done = UIBarButtonItem(title: "확인", style: .plain, target: self, action: #selector(end_donePicker))
        toolbar.setItems([done], animated: false)
        
        end_day.inputAccessoryView = toolbar
        end_day.inputView  = datepicker
        datepicker.datePickerMode = .date
    }
    func end_donePicker (sender:UIBarButtonItem)
    {
        
        tempdate = self.formatter.string(from: datepicker.date)
        
        let intString = start_day.text?.components(
            separatedBy: NSCharacterSet
                .decimalDigits
                .inverted)
            .joined(separator: "")

//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyyMMdd"
        
        if(tempdate>=intString!){
            enddate = tempdate
            end_day.text = "\(weekdayForm(dateString: tempdate))"
            self.view.endEditing(true)
            UserDefault.save(key: UserDefaultKey.alarm_enddate, value: enddate)
            pickerDoneAlarm()

        }else if(end_day.text! == "yyyy-MM-dd" || end_day.text! == ""){
            enddate = tempdate
            end_day.text = "\(weekdayForm(dateString: tempdate))"
            self.view.endEditing(true)
            UserDefault.save(key: UserDefaultKey.alarm_enddate, value: enddate)
            pickerDoneAlarm()
        }else{
            self.view.endEditing(true)
            let alert = UIAlertController(title: "오류", message: "알림 종료일을 시작일 이후로 설정하세요.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "확인", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }

    }
    //---------------------------------------------종료날짜 end
    
    //---------------------------------------------기상시간
    func getupDatePicker(){
        getup_timepicker.datePickerMode = .time
        if(self.getup_time.text == ""){
            set_time = time_formatter.date(from: "07:00")!
        }else{
            set_time = time_formatter.date(from: self.getup_time.text!)!
        }
        getup_timepicker.date = set_time
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let done = UIBarButtonItem(title: "확인", style: .plain, target: self, action: #selector(getup_donePicker))
        toolbar.setItems([done], animated: false)
        
        getup_time.inputAccessoryView = toolbar
        getup_time.inputView  = getup_timepicker
    }
    func getup_donePicker (sender:UIBarButtonItem)
    {
        getup_time.text = "\(self.time_formatter.string(from: getup_timepicker.date))"
        UserDefault.save(key: UserDefaultKey.alarm_getuptime, value: self.getup_time.text!)
        self.view.endEditing(true)
    }
    //---------------------------------------------기상시간 end
    
    //---------------------------------------------취침시간 end
    func bedDatePicker(){
        bed_timepicker.datePickerMode = .time
        if(self.bed_time.text == ""){
            set_time = time_formatter.date(from: "23:00")!
        }else{
            print(self.bed_time.text)
            set_time = time_formatter.date(from: self.bed_time.text!)!
        }
        bed_timepicker.date = set_time
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let done = UIBarButtonItem(title: "확인", style: .plain, target: self, action: #selector(bed_donePicker))
        toolbar.setItems([done], animated: false)
        
        bed_time.inputAccessoryView = toolbar
        bed_time.inputView  = bed_timepicker
    }
    func bed_donePicker (sender:UIBarButtonItem)
    {
        bed_time.text = "\(self.time_formatter.string(from: bed_timepicker.date))"
        UserDefault.save(key: UserDefaultKey.alarm_bedtime, value: self.bed_time.text!)

        self.view.endEditing(true)
    }
    //---------------------------------------------취침시간 end
    
    //---------------------------------------------아침식사시간
    func breakfastDatePicker(){
        breakfast_timepicker.datePickerMode = .time
        if(self.breakfast_time.text == ""){
            set_time = time_formatter.date(from: "28:00")!
        }else{
            set_time = time_formatter.date(from: self.breakfast_time.text!)!
        }
        breakfast_timepicker.date = set_time
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let done = UIBarButtonItem(title: "확인", style: .plain, target: self, action: #selector(breakfast_donePicker))
        toolbar.setItems([done], animated: false)
        
        breakfast_time.inputAccessoryView = toolbar
        breakfast_time.inputView  = breakfast_timepicker
    }
    func breakfast_donePicker (sender:UIBarButtonItem)
    {
        breakfast_time.text = "\(self.time_formatter.string(from: breakfast_timepicker.date))"
        UserDefault.save(key: UserDefaultKey.alarm_breakfast, value: self.breakfast_time.text!)
        self.view.endEditing(true)
    }
    //---------------------------------------------아침식사시간 end
    
    //---------------------------------------------점심식사시간
    func lunchDatePicker(){
        lunch_timepicker.datePickerMode = .time
        
        set_time = time_formatter.date(from: self.lunch_time.text!)!
        lunch_timepicker.date = set_time
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let done = UIBarButtonItem(title: "확인", style: .plain, target: self, action: #selector(lunch_donePicker))
        toolbar.setItems([done], animated: false)
        
        lunch_time.inputAccessoryView = toolbar
        lunch_time.inputView  = lunch_timepicker
    }
    func lunch_donePicker (sender:UIBarButtonItem)
    {
        lunch_time.text = "\(self.time_formatter.string(from: lunch_timepicker.date))"
        UserDefault.save(key: UserDefaultKey.alarm_lunch, value: self.lunch_time.text!)
        self.view.endEditing(true)
    }
    //---------------------------------------------점심식사시간 end
    
    //---------------------------------------------저녁식사시간
    func dinnerDatePicker(){
        dinner_timepicker.datePickerMode = .time
        set_time = time_formatter.date(from: self.dinner_time.text!)!
        dinner_timepicker.date = set_time
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let done = UIBarButtonItem(title: "확인", style: .plain, target: self, action: #selector(dinner_donePicker))
        toolbar.setItems([done], animated: false)
        
        dinner_time.inputAccessoryView = toolbar
        dinner_time.inputView  = dinner_timepicker
    }
    
    func dinner_donePicker (sender:UIBarButtonItem)
    {
        dinner_time.text = "\(self.time_formatter.string(from: dinner_timepicker.date))"
        UserDefault.save(key: UserDefaultKey.alarm_dinner, value: self.dinner_time.text!)
        self.view.endEditing(true)
    }
    
    //---------------------------------------------저녀식사시간 end
    fileprivate let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        return formatter
    }()
    
    fileprivate let time_formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }()
    
    
    func weekdayForm(dateString: String) -> String {
        let df: DateFormatter = DateFormatter()
        df.dateFormat = "yyyyMMdd"
        var weekFormDate: String = ""
        let cal = Calendar(identifier: .gregorian)
        if dateString == "" {
            return ""
        }else{
            let formDate = df.date(from: dateString)
            var comps = cal.dateComponents([.weekday], from: formDate!)
            
            df.dateFormat = "yyyy.MM.dd(EEE)"
            weekFormDate = df.string(from: formDate!)

//            switch comps.weekday! {
//
//            case 1:
//                weekFormDate = "\(df.string(from: formDate!))(일)"
//            case 2:
//                weekFormDate = "\(df.string(from: formDate!))(월)"
//            case 3:
//                weekFormDate = "\(df.string(from: formDate!))(화)"
//            case 4:
//                weekFormDate = "\(df.string(from: formDate!))(수)"
//            case 5:
//                weekFormDate = "\(df.string(from: formDate!))(목)"
//            case 6:
//                weekFormDate = "\(df.string(from: formDate!))(금)"
//            case 7:
//                weekFormDate = "\(df.string(from: formDate!))(토)"
//            default:break
//            }
            return weekFormDate
        }
    }
    
    func countDate() -> Int {
        let start = UserDefault.load(key: UserDefaultKey.alarm_startdate)
        let end = UserDefault.load(key: UserDefaultKey.alarm_enddate)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        print(daysBetweenDates(startDate: dateFormatter.date(from: start)!, endDate:  dateFormatter.date(from: end)!))
        return daysBetweenDates(startDate: dateFormatter.date(from: start)!, endDate:  dateFormatter.date(from: end)!)
        
        
    }
    
    func daysBetweenDates(startDate: Date, endDate: Date) -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([Calendar.Component.day], from: startDate, to: endDate)
        print(components.day!)
        return components.day!
    }
    
    
    func alarmTrigger(startDate: String, time: String, id: String, count: Int, ba: String) -> Void {
      
        let year = startDate.substring(with: 0..<4)
        let month = startDate.substring(with: 5..<7)
        let day = startDate.substring(with: 8..<10)
        let hour = time.substring(with: 0..<2)
        let min = time.substring(with: 3..<5)
        
        let content = UNMutableNotificationContent()
        content.title = "복약알림"
        content.body = "길병원 처방약 복약시간입니다.\n(알림을 원하지 않으시면 앱에서 기능을 꺼주세요)"
        content.sound = UNNotificationSound.default()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMddHHmm"
        let baseDate: String = year + month + day + hour + min
        if (count>=0) {
            
        
        for i in 0..<count+1 {
            //let triggerDate = DateComponents(year: Int(year), month: Int(month), day: Int(day)!+i, hour: Int(hour), minute: Int(minute))
            var triggerDate = DateComponents()
            triggerDate.setValue(0, for: Calendar.Component.year)
            triggerDate.setValue(0, for: Calendar.Component.month)
            triggerDate.setValue(i, for: Calendar.Component.day)
            triggerDate.setValue(0, for: Calendar.Component.hour)
            if(ba == "a"){
                triggerDate.setValue(30, for: Calendar.Component.minute)
            }else if(ba == "b"){
                triggerDate.setValue(-30, for: Calendar.Component.minute)
            }else{
                triggerDate.setValue(0, for: Calendar.Component.minute)
            }
            
            let calendar = Calendar(identifier: Calendar.Identifier.gregorian)

            let base = formatter.date(from: baseDate)
            let tempDate = calendar.date(byAdding: triggerDate, to: base!)
//            print(formatter.string(from: tempDate!))
            
            let comps = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: tempDate!)
            
            print(comps)
            let trigger = UNCalendarNotificationTrigger(dateMatching: comps, repeats: false)

            let request = UNNotificationRequest(identifier: id+String(i), content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request, withCompletionHandler: { (error) in
            })
            }
        }

       // UNUserNotificationCenter.current().remov

    }
    //--------------------------날짜 형식 end
    //------스위치 제어
    
    @IBAction func getup_sw_click(_ sender: Any) {
        if(getup_sw.isOn){
            UserDefault.save(key: UserDefaultKey.alarm_getup, value: "on")

            
            if(0<=countDate()){
                alarmTrigger(startDate: start_day.text!, time: getup_time.text!, id: "gw", count: countDate(), ba: "a")
            }else{
                getup_sw.isOn = false
                let alert = UIAlertController(title: "알림", message: "복약알림 기간설정을 먼저 하시기 바랍니다.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "확인", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
       
        } else{
            if(countDate()>=0){
                var id: [String] = []
                for i in 0..<countDate()+1{
                    id.append("gw"+String(i))
                }
                UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: id)
            }

            UserDefault.save(key: UserDefaultKey.alarm_getup, value: "off")
        }
   //     self.data_store()
    }
    @IBAction func bed_sw_click(_ sender: Any) {
        if(bed_sw.isOn){
            UserDefault.save(key: UserDefaultKey.alarm_bed, value: "on")
            
            if(0<=countDate()){
                alarmTrigger(startDate: start_day.text!, time: bed_time.text!, id: "bw", count: countDate(), ba: "b")
            }else{
                bed_sw.isOn = false
                let alert = UIAlertController(title: "알림", message: "복약알림 기간설정을 먼저 하시기 바랍니다.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "확인", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        } else{
            if(countDate()>=0){

            var id: [String] = []
            for i in 0..<countDate()+1{
                id.append("bw"+String(i))
            }
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: id)
            }
            UserDefault.save(key: UserDefaultKey.alarm_bed, value: "off")
        }
   //     self.data_store()
    }
    @IBAction func before_break_click(_ sender: Any) {
        if(before_break_sw.isOn){
            UserDefault.save(key: UserDefaultKey.alarm_befor_breakfast, value: "on")
            if(0<=countDate()){
                alarmTrigger(startDate: start_day.text!, time: breakfast_time.text!, id: "bb", count: countDate(), ba: "b")
            }else{
                before_break_sw.isOn = false
                let alert = UIAlertController(title: "알림", message: "복약알림 기간설정을 먼저 하시기 바랍니다.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "확인", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        } else{
            if(countDate()>=0){

            var id: [String] = []
            for i in 0..<countDate()+1{
                id.append("bb"+String(i))
            }
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: id)
            }
            UserDefault.save(key: UserDefaultKey.alarm_befor_breakfast, value: "off")
        }
  //      self.data_store()
    }
    @IBAction func after_break_click(_ sender: Any) {
        if(after_break_sw.isOn){
            UserDefault.save(key: UserDefaultKey.alarm_after_breakfast, value: "on")
            if(0<=countDate()){
                alarmTrigger(startDate: start_day.text!, time: breakfast_time.text!, id: "ab", count: countDate(), ba: "a")
            }else{
                after_break_sw.isOn = false
                let alert = UIAlertController(title: "알림", message: "복약알림 기간설정을 먼저 하시기 바랍니다.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "확인", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        } else{
            if(countDate()>=0){

            var id: [String] = []
            for i in 0..<countDate()+1{
                id.append("ab"+String(i))
            }
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: id)
            }
            UserDefault.save(key: UserDefaultKey.alarm_after_breakfast, value: "off")
        }
   //     self.data_store()
    }
    @IBAction func before_lunch_click(_ sender: Any) {
        if(before_lunch_sw.isOn){
            UserDefault.save(key: UserDefaultKey.alarm_befor_lunch, value: "on")
            if(0<=countDate()){
                alarmTrigger(startDate: start_day.text!, time: lunch_time.text!, id: "bl", count: countDate(), ba: "b")
            }else{
                before_lunch_sw.isOn = false
                let alert = UIAlertController(title: "알림", message: "복약알림 기간설정을 먼저 하시기 바랍니다.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "확인", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        } else{
            if(countDate()>=0){

            var id: [String] = []
            for i in 0..<countDate()+1{
                id.append("bl"+String(i))
            }
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: id)
            }
            UserDefault.save(key: UserDefaultKey.alarm_befor_lunch, value: "off")
        }
   //     self.data_store()
    }
    
    @IBAction func after_lunch_click(_ sender: Any) {
        if(after_lunch_sw.isOn){
            UserDefault.save(key: UserDefaultKey.alarm_after_lunch, value: "on")
            if(0<=countDate()){
                alarmTrigger(startDate: start_day.text!, time: lunch_time.text!, id: "al", count: countDate(), ba: "a")
            }else{
                after_lunch_sw.isOn = false
                let alert = UIAlertController(title: "알림", message: "복약알림 기간설정을 먼저 하시기 바랍니다.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "확인", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        } else{
            if(countDate()>=0){

            var id: [String] = []
            for i in 0..<countDate()+1{
                id.append("al"+String(i))
            }
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: id)
            }
            UserDefault.save(key: UserDefaultKey.alarm_after_lunch, value: "off")
        }
     //   self.data_store()
    }
    @IBAction func before_dinner_click(_ sender: Any) {
        if(before_dinner_sw.isOn){
            UserDefault.save(key: UserDefaultKey.alarm_befor_dinner, value: "on")
            if(0<=countDate()){
                alarmTrigger(startDate: start_day.text!, time: dinner_time.text!, id: "bd", count: countDate(), ba: "b")
            }else{
                before_dinner_sw.isOn = false
                let alert = UIAlertController(title: "알림", message: "복약알림 기간설정을 먼저 하시기 바랍니다.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "확인", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        } else{
            if(countDate()>=0){

            var id: [String] = []
            for i in 0..<countDate()+1{
                id.append("bd"+String(i))
            }
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: id)
            }
            UserDefault.save(key: UserDefaultKey.alarm_befor_dinner, value: "off")
        }
     //   self.data_store()
    }
    @IBAction func after_dinner_click(_ sender: Any) {
        if(after_dinner_sw.isOn){
            if(0<=countDate()){
                alarmTrigger(startDate: start_day.text!, time: dinner_time.text!, id: "ad", count: countDate(), ba: "a")
            }else{
                after_dinner_sw.isOn = false
                let alert = UIAlertController(title: "알림", message: "복약알림 기간설정을 먼저 하시기 바랍니다.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "확인", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            UserDefault.save(key: UserDefaultKey.alarm_after_dinner, value: "on")
        } else{
            if(countDate()>=0){

            var id: [String] = []
            for i in 0..<countDate()+1{
                id.append("ad"+String(i))
            }
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: id)
            }
            UserDefault.save(key: UserDefaultKey.alarm_after_dinner, value: "off")
        }
   //     self.data_store()
    }
    
    func pickerDoneAlarm() -> Void {
        if(UserDefault.load(key: UserDefaultKey.alarm_getup) == "on"){
            if(UserDefault.load(key: UserDefaultKey.alarm_onoff) == "on"){
                alarmTrigger(startDate: start_day.text!, time: getup_time.text!, id: "gw", count: countDate(), ba: "a")
            }
        }
        
        if(UserDefault.load(key: UserDefaultKey.alarm_bed) == "on"){
            if(UserDefault.load(key: UserDefaultKey.alarm_onoff) == "on"){
                alarmTrigger(startDate: start_day.text!, time: bed_time.text!, id: "bw", count: countDate(), ba: "b")
            }
            
        }
        
        
        if(UserDefault.load(key: UserDefaultKey.alarm_befor_breakfast) == "on"){
            if(UserDefault.load(key: UserDefaultKey.alarm_onoff) == "on"){
                alarmTrigger(startDate: start_day.text!, time: breakfast_time.text!, id: "bb", count: countDate(), ba: "b")
            }
        }
        
        
        if(UserDefault.load(key: UserDefaultKey.alarm_after_breakfast) == "on"){
            if(UserDefault.load(key: UserDefaultKey.alarm_onoff) == "on"){
                alarmTrigger(startDate: start_day.text!, time: breakfast_time.text!, id: "ab", count: countDate(), ba: "a")
            }
        }
        
        if(UserDefault.load(key: UserDefaultKey.alarm_befor_lunch) == "on"){
            if(UserDefault.load(key: UserDefaultKey.alarm_onoff) == "on"){
                alarmTrigger(startDate: start_day.text!, time: lunch_time.text!, id: "bl", count: countDate(), ba: "b")
            }
        }
        
        if(UserDefault.load(key: UserDefaultKey.alarm_after_lunch) == "on"){
            if(UserDefault.load(key: UserDefaultKey.alarm_onoff) == "on"){
                alarmTrigger(startDate: start_day.text!, time: lunch_time.text!, id: "al", count: countDate(), ba: "a")
            }
        }
        
        if(UserDefault.load(key: UserDefaultKey.alarm_befor_dinner) == "on"){
            if(UserDefault.load(key: UserDefaultKey.alarm_onoff) == "on"){
                alarmTrigger(startDate: start_day.text!, time: dinner_time.text!, id: "bd", count: countDate(), ba: "b")
            }
            
        }
        
        if(UserDefault.load(key: UserDefaultKey.alarm_after_dinner) == "on"){
            if(UserDefault.load(key: UserDefaultKey.alarm_onoff) == "on"){
                alarmTrigger(startDate: start_day.text!, time: dinner_time.text!, id: "ad", count: countDate(), ba: "a")
            }
            
        }
    }
    
    
    func data_store(){
        UserDefault.save(key: UserDefaultKey.alarm_startdate, value: startdate)
        UserDefault.save(key: UserDefaultKey.alarm_enddate, value: enddate)
        UserDefault.save(key: UserDefaultKey.alarm_bedtime, value: self.bed_time.text!)
        UserDefault.save(key: UserDefaultKey.alarm_breakfast, value: self.breakfast_time.text!)
        UserDefault.save(key: UserDefaultKey.alarm_lunch, value: self.lunch_time.text!)
        UserDefault.save(key: UserDefaultKey.alarm_dinner, value: self.dinner_time.text!)
        
        
        print(UserDefault.load(key: UserDefaultKey.alarm_onoff))
        print(UserDefault.load(key: UserDefaultKey.alarm_startdate))
        print(UserDefault.load(key: UserDefaultKey.alarm_enddate))
        print(UserDefault.load(key: UserDefaultKey.alarm_getuptime))
        print(UserDefault.load(key: UserDefaultKey.alarm_bedtime))
        print(UserDefault.load(key: UserDefaultKey.alarm_breakfast))
        print(UserDefault.load(key: UserDefaultKey.alarm_lunch))
        print(UserDefault.load(key: UserDefaultKey.alarm_dinner))
        print(UserDefault.load(key: UserDefaultKey.alarm_getup))
        print(UserDefault.load(key: UserDefaultKey.alarm_bed))
        print(UserDefault.load(key: UserDefaultKey.alarm_befor_breakfast))
        print(UserDefault.load(key: UserDefaultKey.alarm_after_breakfast))
        print(UserDefault.load(key: UserDefaultKey.alarm_befor_lunch))
        print(UserDefault.load(key: UserDefaultKey.alarm_after_lunch))
        print(UserDefault.load(key: UserDefaultKey.alarm_befor_dinner))
        print(UserDefault.load(key: UserDefaultKey.alarm_after_dinner))
    }
    
    func data_load(){
        if(UserDefault.load(key: UserDefaultKey.alarm_onoff) == "on"){
            
//            let background_color =  UIColor(red: 126/255.0, green: 158/255.0, blue: 220/255.0, alpha: 1.0)
//            alarm_buttonout.backgroundColor = background_color
//            alarm_buttonout.setTitle("알람 켜짐", for: .normal)
            alarm_buttonout.activateButton(bool: true)
            dateSetting.isEnabled = true
            start_day.textColor = UIColor.black
            end_day.textColor = UIColor.black
            getup_time.textColor = UIColor.black
            bed_time.textColor = UIColor.black
            breakfast_time.textColor = UIColor.black
            lunch_time.textColor = UIColor.black
            dinner_time.textColor = UIColor.black
            getup_sw.isEnabled = true
            bed_sw.isEnabled = true
            before_break_sw.isEnabled = true
            after_break_sw.isEnabled = true
            before_lunch_sw.isEnabled = true
            after_lunch_sw.isEnabled = true
            before_dinner_sw.isEnabled = true
            after_dinner_sw.isEnabled = true
            start_day.isEnabled = true
            end_day.isEnabled = true
            getup_time.isEnabled = true
            bed_time.isEnabled = true
            breakfast_time.isEnabled = true
            lunch_time.isEnabled = true
            dinner_time.isEnabled = true
            
            
        }
        else{
//            alarm_buttonout.backgroundColor = UIColor.lightGray
//            alarm_buttonout.setTitle("알람 꺼짐", for: .normal
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
            dateSetting.isEnabled = false
            alarm_buttonout.activateButton(bool: false)
            start_day.textColor = UIColor.lightGray
            end_day.textColor = UIColor.lightGray
            getup_time.textColor = UIColor.lightGray
            bed_time.textColor = UIColor.lightGray
            breakfast_time.textColor = UIColor.lightGray
            lunch_time.textColor = UIColor.lightGray
            dinner_time.textColor = UIColor.lightGray
            getup_sw.isEnabled = false
            bed_sw.isEnabled = false
            before_break_sw.isEnabled = false
            after_break_sw.isEnabled = false
            before_lunch_sw.isEnabled = false
            after_lunch_sw.isEnabled = false
            before_dinner_sw.isEnabled = false
            after_dinner_sw.isEnabled = false
            start_day.isEnabled = false
            end_day.isEnabled = false
            getup_time.isEnabled = false
            bed_time.isEnabled = false
            breakfast_time.isEnabled = false
            lunch_time.isEnabled = false
            dinner_time.isEnabled = false
        }
        

        if(UserDefault.load(key: UserDefaultKey.alarm_getuptime) != ""){
            getup_time.text = UserDefault.load(key: UserDefaultKey.alarm_getuptime)
        }
        
        if(UserDefault.load(key: UserDefaultKey.alarm_bedtime) != ""){
            bed_time.text = UserDefault.load(key: UserDefaultKey.alarm_bedtime)
        }
    
//        let now = NSDate()
//        let dateFormat_now = DateFormatter()
//        dateFormat_now.dateFormat = "yyyyMMdd"
//        let now_Date = dateFormat_now.string(from: now as Date)
        

        start_day.text = weekdayForm(dateString: UserDefault.load(key: UserDefaultKey.alarm_startdate))

        end_day.text = weekdayForm(dateString: UserDefault.load(key: UserDefaultKey.alarm_enddate))
        

        if(UserDefault.load(key: UserDefaultKey.alarm_breakfast) != ""){
            breakfast_time.text = UserDefault.load(key: UserDefaultKey.alarm_breakfast)
        }
        if(UserDefault.load(key: UserDefaultKey.alarm_lunch) != ""){
            lunch_time.text = UserDefault.load(key: UserDefaultKey.alarm_lunch)
        }
        if(UserDefault.load(key: UserDefaultKey.alarm_dinner) != ""){
            dinner_time.text = UserDefault.load(key: UserDefaultKey.alarm_dinner)
        }
    
        if(UserDefault.load(key: UserDefaultKey.alarm_getup) == "on"){
            getup_sw.isOn = true
            if(UserDefault.load(key: UserDefaultKey.alarm_onoff) == "on"){
            alarmTrigger(startDate: start_day.text!, time: getup_time.text!, id: "gw", count: countDate(), ba: "a")
            }
        }else{
            getup_sw.isOn = false
        }
        
        
        if(UserDefault.load(key: UserDefaultKey.alarm_bed) == "on"){
            bed_sw.isOn = true
            if(UserDefault.load(key: UserDefaultKey.alarm_onoff) == "on"){
                alarmTrigger(startDate: start_day.text!, time: bed_time.text!, id: "bw", count: countDate(), ba: "b")
            }

        }else{
            bed_sw.isOn = false
        }


        if(UserDefault.load(key: UserDefaultKey.alarm_befor_breakfast) == "on"){
            before_break_sw.isOn = true
            if(UserDefault.load(key: UserDefaultKey.alarm_onoff) == "on"){
            alarmTrigger(startDate: start_day.text!, time: breakfast_time.text!, id: "bb", count: countDate(), ba: "b")
            }
        }else{
            before_break_sw.isOn = false
        }


        if(UserDefault.load(key: UserDefaultKey.alarm_after_breakfast) == "on"){
            after_break_sw.isOn = true
            if(UserDefault.load(key: UserDefaultKey.alarm_onoff) == "on"){
            alarmTrigger(startDate: start_day.text!, time: breakfast_time.text!, id: "ab", count: countDate(), ba: "a")
            }
        }else{
            after_break_sw.isOn = false
        }


        if(UserDefault.load(key: UserDefaultKey.alarm_befor_lunch) == "on"){
            before_lunch_sw.isOn = true
            if(UserDefault.load(key: UserDefaultKey.alarm_onoff) == "on"){
            alarmTrigger(startDate: start_day.text!, time: lunch_time.text!, id: "bl", count: countDate(), ba: "b")
            }
        }else{
            before_lunch_sw.isOn = false
        }


        if(UserDefault.load(key: UserDefaultKey.alarm_after_lunch) == "on"){
            after_lunch_sw.isOn = true
            if(UserDefault.load(key: UserDefaultKey.alarm_onoff) == "on"){
            alarmTrigger(startDate: start_day.text!, time: lunch_time.text!, id: "al", count: countDate(), ba: "a")
            }
        }else{
            after_lunch_sw.isOn = false
        }
        
        if(UserDefault.load(key: UserDefaultKey.alarm_befor_dinner) == "on"){
            before_dinner_sw.isOn = true
            if(UserDefault.load(key: UserDefaultKey.alarm_onoff) == "on"){
            alarmTrigger(startDate: start_day.text!, time: dinner_time.text!, id: "bd", count: countDate(), ba: "b")
            }

        }else{
            before_dinner_sw.isOn = false
        }
        
        
        if(UserDefault.load(key: UserDefaultKey.alarm_after_dinner) == "on"){
            after_dinner_sw.isOn = true
            if(UserDefault.load(key: UserDefaultKey.alarm_onoff) == "on"){
            alarmTrigger(startDate: start_day.text!, time: dinner_time.text!, id: "ad", count: countDate(), ba: "a")
            }

        }else{
            after_lunch_sw.isOn = false
        }
    }
    
}
