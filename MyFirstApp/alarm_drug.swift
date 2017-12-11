

import Foundation
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
    
    var temp_startdate = ""
    var temp_enddate = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        let now = NSDate()
        let dateFormat_now = DateFormatter()
        dateFormat_now.dateFormat = "yyyyMMdd"
        let now_Date = dateFormat_now.string(from: now as Date)
        
        start_day.addBorderBottom(height: 1.0, color: UIColor.lightGray)
        end_day.addBorderBottom(height: 1.0, color: UIColor.lightGray)
        getup_time.addBorderBottom(height: 1.0, color: UIColor.lightGray)
        bed_time.addBorderBottom(height: 1.0, color: UIColor.lightGray)
        breakfast_time.addBorderBottom(height: 1.0, color: UIColor.lightGray)
        lunch_time.addBorderBottom(height: 1.0, color: UIColor.lightGray)
        dinner_time.addBorderBottom(height: 1.0, color: UIColor.lightGray)
        
        temp_startdate = now_Date
        temp_enddate = now_Date
        start_day.text = weekdayForm(dateString: now_Date)
        end_day.text = weekdayForm(dateString: now_Date)
        
        data_load()
        
        startDatePicker()
        endDatePicker()
        getupDatePicker()
        bedDatePicker()
        breakfastDatePicker()
        lunchDatePicker()
        dinnerDatePicker()
        
    }
    
    @IBOutlet weak var alarm_buttonout: UIButton!
    @IBAction func alarm_button(_ sender: Any) {
        if(UserDefault.load(key: UserDefaultKey.alarm_onoff) == "on"){
            //알람 꺼짐
            UserDefault.save(key: UserDefaultKey.alarm_onoff, value: "off")
        }
        else{
            //알람켜짐
            UserDefault.save(key: UserDefaultKey.alarm_onoff, value: "on")
        }
        self.data_store()
        viewDidLoad()
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
        temp_startdate = tempdate
        start_day.text = "\(weekdayForm(dateString: tempdate))"
        self.view.endEditing(true)
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
        temp_enddate = tempdate
        end_day.text = "\(weekdayForm(dateString: tempdate))"
        self.view.endEditing(true)
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
            
            df.dateFormat = "yyyy.MM.dd"
            
            switch comps.weekday! {
                
            case 1:
                weekFormDate = "\(df.string(from: formDate!))(일)"
            case 2:
                weekFormDate = "\(df.string(from: formDate!))(월)"
            case 3:
                weekFormDate = "\(df.string(from: formDate!))(화)"
            case 4:
                weekFormDate = "\(df.string(from: formDate!))(수)"
            case 5:
                weekFormDate = "\(df.string(from: formDate!))(목)"
            case 6:
                weekFormDate = "\(df.string(from: formDate!))(금)"
            case 7:
                weekFormDate = "\(df.string(from: formDate!))(토)"
            default:break
            }
            return weekFormDate
        }
    }
    //--------------------------날짜 형식 end
    //------스위치 제어
    var getup_onoff = "off"
    var bed_onoff = "off"
    var before_breakfast_onoff = "off"
    var after_breakfast_onoff = "off"
    var before_lunch_onoff = "off"
    var after_lunch_onoff = "off"
    var before_dinner_onoff = "off"
    var after_dinner_onoff="off"
    
    @IBAction func getup_sw_click(_ sender: Any) {
        if( getup_onoff == "off"){getup_onoff = "on"}
        else{getup_onoff = "off"}
        self.data_store()
    }
    @IBAction func bed_sw_click(_ sender: Any) {
        if( bed_onoff == "off"){bed_onoff = "on"}
        else{bed_onoff = "off"}
        self.data_store()
    }
    @IBAction func before_break_click(_ sender: Any) {
        if( before_breakfast_onoff == "off"){before_breakfast_onoff = "on"}
        else{before_breakfast_onoff = "off"}
        self.data_store()
    }
    @IBAction func after_break_click(_ sender: Any) {
        if( after_breakfast_onoff == "off"){after_breakfast_onoff = "on"}
        else{after_breakfast_onoff = "off"}
        self.data_store()
    }
    @IBAction func before_lunch_click(_ sender: Any) {
        if( before_lunch_onoff == "off"){before_lunch_onoff = "on"}
        else{before_lunch_onoff = "off"}
        self.data_store()
    }
    
    @IBAction func after_lunch_click(_ sender: Any) {
        if( after_lunch_onoff == "off"){after_lunch_onoff = "on"}
        else{after_lunch_onoff = "off"}
        self.data_store()
    }
    @IBAction func before_dinner_click(_ sender: Any) {
        if( before_dinner_onoff == "off"){before_dinner_onoff = "on"}
        else{before_dinner_onoff = "off"}
        self.data_store()
    }
    @IBAction func after_dinner_click(_ sender: Any) {
        if( after_dinner_onoff == "off"){after_dinner_onoff = "on"}
        else{after_dinner_onoff = "off"}
        self.data_store()
    }
    
    
    func data_store(){
        UserDefault.save(key: UserDefaultKey.alarm_startdate, value: temp_startdate)
        UserDefault.save(key: UserDefaultKey.alarm_enddate, value: temp_enddate)
        UserDefault.save(key: UserDefaultKey.alarm_getuptime, value: self.getup_time.text!)
        UserDefault.save(key: UserDefaultKey.alarm_bedtime, value: self.bed_time.text!)
        UserDefault.save(key: UserDefaultKey.alarm_breakfast, value: self.breakfast_time.text!)
        UserDefault.save(key: UserDefaultKey.alarm_lunch, value: self.lunch_time.text!)
        UserDefault.save(key: UserDefaultKey.alarm_dinner, value: self.dinner_time.text!)
        
        UserDefault.save(key: UserDefaultKey.alarm_getup, value: getup_onoff)
        UserDefault.save(key: UserDefaultKey.alarm_bed, value: bed_onoff)
        UserDefault.save(key: UserDefaultKey.alarm_befor_breakfast, value: before_breakfast_onoff)
        UserDefault.save(key: UserDefaultKey.alarm_after_breakfast, value: after_breakfast_onoff)
        UserDefault.save(key: UserDefaultKey.alarm_befor_lunch, value: before_lunch_onoff)
        UserDefault.save(key: UserDefaultKey.alarm_after_lunch, value: after_lunch_onoff)
        UserDefault.save(key: UserDefaultKey.alarm_befor_dinner, value: before_dinner_onoff)
        UserDefault.save(key: UserDefaultKey.alarm_after_dinner, value: after_dinner_onoff)
        
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
            
            let background_color =  UIColor(red: 126/255.0, green: 158/255.0, blue: 220/255.0, alpha: 1.0)
            alarm_buttonout.backgroundColor = background_color
            alarm_buttonout.setTitle("알람 켜짐", for: .normal)
            start_day.textColor = UIColor.black
            end_day.textColor = UIColor.black
            getup_time.textColor = UIColor.black
            bed_time.textColor = UIColor.black
            breakfast_time.textColor = UIColor.black
            lunch_time.textColor = UIColor.black
            dinner_time.textColor = UIColor.black
        }
        else{
            alarm_buttonout.backgroundColor = UIColor.lightGray
            alarm_buttonout.setTitle("알람 꺼짐", for: .normal)
            start_day.textColor = UIColor.lightGray
            end_day.textColor = UIColor.lightGray
            getup_time.textColor = UIColor.lightGray
            bed_time.textColor = UIColor.lightGray
            breakfast_time.textColor = UIColor.lightGray
            lunch_time.textColor = UIColor.lightGray
            dinner_time.textColor = UIColor.lightGray
        }
        if(UserDefault.load(key: UserDefaultKey.alarm_startdate) != ""){
            start_day.text = weekdayForm(dateString: UserDefault.load(key: UserDefaultKey.alarm_startdate))
        }
        if(UserDefault.load(key: UserDefaultKey.alarm_enddate) != ""){
            end_day.text = weekdayForm(dateString: UserDefault.load(key: UserDefaultKey.alarm_enddate))
        }
        if(UserDefault.load(key: UserDefaultKey.alarm_getuptime) != ""){
            getup_time.text = UserDefault.load(key: UserDefaultKey.alarm_getuptime)
        }
        if(UserDefault.load(key: UserDefaultKey.alarm_bed) != ""){
            bed_time.text = UserDefault.load(key: UserDefaultKey.alarm_bedtime)
        }
        if(UserDefault.load(key: UserDefaultKey.alarm_breakfast) != ""){
            breakfast_time.text = UserDefault.load(key: UserDefaultKey.alarm_breakfast)
        }
        if(UserDefault.load(key: UserDefaultKey.alarm_lunch) != ""){
            lunch_time.text = UserDefault.load(key: UserDefaultKey.alarm_lunch)
        }
        if(UserDefault.load(key: UserDefaultKey.alarm_dinner) != ""){
            dinner_time.text = UserDefault.load(key: UserDefaultKey.alarm_dinner)
        }
    }}
