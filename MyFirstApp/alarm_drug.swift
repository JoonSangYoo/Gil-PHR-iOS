

import Foundation
import UIKit

class alarm_drug : UIViewController{
    
    var plag = 0
    @IBOutlet weak var end_day: UITextField!
    @IBOutlet weak var start_day: UITextField!
    
    let datepicker = UIDatePicker()
    let end_datepicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startDatePicker()
    }
    
    func startDatePicker(){
        print(plag)
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePicker))
        
        toolbar.setItems([done], animated: false)
            start_day.inputAccessoryView = toolbar
            start_day.inputView  = datepicker
            datepicker.datePickerMode = .date
        
    }
    
    func donePicker (sender:UIBarButtonItem)
    {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        
        let str = formatter.string(from: datepicker.date)
        
        start_day.text = "\(str)"
        
        self.view.endEditing(true)
    }
}
