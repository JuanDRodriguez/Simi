//
//  TareaViewController.swift
//  Supervisores
//
//  Created by Sharepoint on 9/3/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import UIKit
import EventKit
class TareaViewController: UIViewController {

    @IBOutlet weak var navBar: UIView!

    @IBOutlet weak var txtStartDate: UITextField!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var imgView1: UIImageView!
    @IBOutlet weak var imgView2: UIImageView!
    @IBOutlet weak var imgView3: UIImageView!
    @IBOutlet weak var imgView4: UIImageView!
    @IBOutlet weak var imgView5: UIImageView!
    @IBOutlet weak var imgView6: UIImageView!
    @IBOutlet weak var imgView7: UIImageView!
    var daysBool:[Bool] = [false,false,false,false,false,false,false]
    let datePicker: UIDatePicker = UIDatePicker()
    let eventStore = EKEventStore()
    var imgViews: [UIImageView] = []
     var days: [EKRecurrenceDayOfWeek] = []
    var idUnit = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        CommonInit.navBarGenericBack(vc: self, navigationBar: navBar, title: "Tareas")
        textView.layer.masksToBounds = true
        textView.layer.cornerRadius = CGFloat(10.0)
        textView.clipsToBounds = true
        textView.layer.borderWidth = 0.5
        textView.layer.borderColor = UIColor.black.cgColor
        // Do any additional setup after loading the view.
        imgViews = [imgView1,imgView2,imgView3,imgView4,imgView5,imgView6,imgView7]
        self.setupDatePicker()
    }
    
    
    func setupDatePicker() {
        // Specifies intput type
        let loc = Locale(identifier: "es")
        self.datePicker.locale = loc
        datePicker.datePickerMode = .dateAndTime
        // Creates the toolbar
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
        toolBar.sizeToFit()
        
        // Adds the buttons
        let doneButton = UIBarButtonItem(title: "Aceptar", style: .plain, target: self, action: #selector(self.doneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancelar", style: .plain, target: self, action: #selector(self.cancelClick))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        // Adds the toolbar to the view
        txtStartDate!.inputView = datePicker
        txtStartDate!.inputAccessoryView = toolBar
        txtStartDate?.tag = 1
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        SOGetPermissionCalendarAccess()
    }
    func SOGetPermissionCalendarAccess() {
        switch EKEventStore.authorizationStatus(for: .reminder) {
        case .authorized:
            print("Authorised")
        case .denied:
            print("Access denied")
        case .notDetermined:
            // 3
            eventStore.requestAccess(to: .reminder, completion:
                {[weak self] (granted: Bool, error: Error?) -> Void in
                    if granted {
                        
                    } else {
                        print("Access denied")
                    }
            })
        default:
            print("Case Default")
        }
    }
    @objc func doneClick() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy hh:mm a"
        //dateFormatter.dateStyle = .ShortStyle
        if txtStartDate?.isFirstResponder == true {
            txtStartDate!.text = dateFormatter.string(from: datePicker.date)
            txtStartDate!.resignFirstResponder()
        } else {
           
        }
    }
    
    @objc func cancelClick() {
        txtStartDate!.resignFirstResponder()
        
    }
    func changeStatus(index: Int){
        if daysBool[index]{
            imgViews[index].image = UIImage(named: "buttonFalse")
            daysBool[index] = false
        }else{
            imgViews[index].image = UIImage(named: "buttonTrue")
            daysBool[index] = true
        }
    }
    @IBAction func actButton(button: UIButton){
        changeStatus(index: button.tag - 1)
    }
    
    @IBAction func actionAddEvent(sender: AnyObject) {
        if txtStartDate.text == "" ||  textView.text == "" {
            return
        }
        if daysBool[0]{
            days.append(EKRecurrenceDayOfWeek.init(dayOfTheWeek: EKWeekday.sunday, weekNumber: 1))
        }
        if daysBool[1]{
            days.append(EKRecurrenceDayOfWeek.init(dayOfTheWeek: EKWeekday.monday, weekNumber: 2))
        }
        if daysBool[2]{
            days.append(EKRecurrenceDayOfWeek.init(dayOfTheWeek: EKWeekday.tuesday, weekNumber: 3))
        }
        if daysBool[3]{
            days.append(EKRecurrenceDayOfWeek.init(dayOfTheWeek: EKWeekday.wednesday, weekNumber: 4))
        }
        if daysBool[4]{
            days.append(EKRecurrenceDayOfWeek.init(dayOfTheWeek: EKWeekday.thursday, weekNumber: 5))
        }
        if daysBool[5]{
            days.append(EKRecurrenceDayOfWeek.init(dayOfTheWeek: EKWeekday.friday, weekNumber: 6))
        }
        if daysBool[6]{
           days.append(EKRecurrenceDayOfWeek.init(dayOfTheWeek: EKWeekday.saturday, weekNumber: 7))
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy hh:mm a"
        var dateStart = dateFormatter.date(from: (txtStartDate.text)!)
       var frecuency = EKRecurrenceFrequency.weekly
       
        
        let calendarGregorian = Calendar.init(identifier: .gregorian)
        let daysComponents:DateComponents =  calendarGregorian.dateComponents([.minute,.day,.month,.year,.second], from: dateStart!)
        let event = EKReminder.init(eventStore: eventStore)
        event.title = "Supervisión"
        event.notes = idUnit
        event.dueDateComponents = daysComponents
        let calendars = eventStore.calendars(for: EKEntityType.reminder)
        var calendar:  EKCalendar
        if calendars.count > 0{
            calendar = calendars[0]
        }else{
            calendar = EKCalendar.init(for: EKEntityType.reminder, eventStore: eventStore)
            calendar.title = "SupervisiónPrueba"
            calendar.cgColor = UIColor.blue.cgColor
            calendar.source = eventStore.defaultCalendarForNewReminders()?.source!
            
            do {
                try eventStore.saveCalendar(calendar, commit: true)
                print("calendar added with dates:")
                self.dismiss(animated: true, completion: nil)
            } catch let e as NSError {
                print("errorSaveCalendar: \(e.description)")
                return
            }
        }
       
        
        event.calendar = calendar
        
        event.title = idUnit
        
        event.addAlarm(EKAlarm(absoluteDate: dateStart!))
       let rule = EKRecurrenceRule.init(recurrenceWith: frecuency, interval: 1, daysOfTheWeek: days, daysOfTheMonth: nil, monthsOfTheYear: nil, weeksOfTheYear: nil, daysOfTheYear: nil, setPositions: nil, end: EKRecurrenceEnd.init(occurrenceCount: 1))
        event.addRecurrenceRule(rule)
        
        do {
            try eventStore.save(event, commit: true)
            print("events added with dates:")
            self.dismiss(animated: true, completion: nil)
        } catch let e as NSError {
            print(e.description)
            return
        }
        print("Saved Event")
        
    }
    
    @IBAction func actionBack(sender: AnyObject) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
}
