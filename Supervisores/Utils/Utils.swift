//
//  Utils.swift
//  Supervisores
//
//  Created by Sharepoint on 05/02/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import Foundation
import UIKit
import EventKit
import Lottie

class Utils {
    static var index = 0
    static var breanch: [[Int:[String: Any]]] = []
    static var eventStore = EKEventStore()
    static let dateFormatter = DateFormatter()
    static var calendar : EKCalendar?
    static var nameUnit: String!
    static func removeAllNonNumeric(text: String) -> Double {
        let digitChars  = text.components(separatedBy:
            CharacterSet.decimalDigits.inverted).joined(separator: "")
        return Double(digitChars) ?? 0.0
    }
    
    static func base64ToImage(base64String: String) -> UIImage {
        if base64String.isEmpty {
            return #imageLiteral(resourceName: "no_image_found")
        }else {
            
            if let dataDecoded = Data(base64Encoded: base64String, options: .ignoreUnknownCharacters) {
                if let decodedimage = UIImage(data: dataDecoded) {
                    return decodedimage
                }
            }
        }
        return UIImage(named: "unidades") ?? #imageLiteral(resourceName: "no_image_found")
    }
    static func imageToBase64(image: UIImage) -> String {
        guard let imageData = image.jpegData(compressionQuality: 0.5) else { return "" }
        return imageData.base64EncodedString(options: Data.Base64EncodingOptions.lineLength64Characters)
    }
    static func addReminder(dateAlert: Date, title: String, description: String, completion: @escaping (Bool, Error?)->Void) {
        self.eventStore.reset()
        eventStore.requestAccess(to: .reminder, completion: {
            granted, error in
            if (granted) && (error == nil) {
                let reminder:EKReminder = EKReminder(eventStore: self.eventStore)
                reminder.title = title
                reminder.notes = description
                reminder.priority = 1
                let alarm = EKAlarm(absoluteDate: dateAlert)
                reminder.addAlarm(alarm)
                guard let calendarSelected = Utils.getCalendar() else {
                    let errorCS = NSError(domain:"", code:500, userInfo:[ NSLocalizedDescriptionKey: "No hay calendario"])
                    completion(false, errorCS)
                    return
                }
                reminder.calendar = calendarSelected
                do {
                    try self.eventStore.save(reminder, commit: true)
                } catch {
                    print("ERROR guardando ===>> \(error)")
                    completion(granted, error)
                }
                completion(granted, nil)
            } else {
                print("ERROR guardando ===>> \(String(describing: error))")
                completion(granted, error)
            }
        })
    }
    
    private static func getCalendar()->EKCalendar? {
        if Utils.calendar == nil {
            var calendars = self.eventStore.calendars(for: .reminder)
            calendars = calendars.filter({$0.title == "Supervisores 2.0"})
            if calendars.count > 0 {
                Utils.calendar = calendars[0]
                return Utils.calendar!
            }
            Utils.calendar = EKCalendar(for: .reminder, eventStore: eventStore)
            Utils.calendar?.title = "Supervisores 2.0"
            let sourcesInEventStore = eventStore.sources
            let calendarS = sourcesInEventStore.filter {
                (source: EKSource) -> Bool in
                source.sourceType.rawValue == EKSourceType.local.rawValue
                }
            if calendarS.count > 0 {
                Utils.calendar?.source = calendarS.first
            } else {
                return nil
            }
            do {
                try eventStore.saveCalendar(Utils.calendar!, commit: true)
            } catch {
                print("ERROR Creando calendario ===>> \(error)")
            }
        }
        return Utils.calendar!
    }
    
    static func runAnimation(lottieAnimation: LOTAnimationView, from: NSNumber, to: NSNumber ){
        DispatchQueue.main.async {
            if lottieAnimation.isAnimationPlaying {
                lottieAnimation.completionBlock = { _ in
                    Utils.playAnimation(lottieAnimation: lottieAnimation, from: from, to: to)
                }
            } else {
                Utils.playAnimation(lottieAnimation: lottieAnimation, from: from, to: to)
            }
        }
    }
    private static func playAnimation(lottieAnimation: LOTAnimationView, from: NSNumber, to: NSNumber ){
        lottieAnimation.play(fromFrame: from, toFrame: to, withCompletion: nil)
    }
    static func dateCampareToDateNow(stringDate: (String,String)) -> Bool{
        Utils.dateFormatter.dateFormat = "HH:mm:ss"
        
        
        let date = Date()
        let timenow = Utils.dateFormatter.string(from: date)
        let index1: String.Index = stringDate.0.index(timenow.startIndex, offsetBy: 2)
        let index2: String.Index = stringDate.1.index(timenow.startIndex, offsetBy: 2)
        let index: String.Index = timenow.index(timenow.startIndex, offsetBy: 2)
        let hora: Int = Int(timenow.substring(to: index))!
        let hora1: Int = Int(stringDate.0.substring(to: index))!
        let hora2: Int = Int(stringDate.1.substring(to: index))!
        var status = false
        if hora2 > hora1{
            if hora >= hora1  && hora < hora2{
                status = true
            }
        }else{
            if hora > hora1 {
                status = true
            }else{
                if hora < hora2{
                    status = true
                }
            }
        } 
        return status
    }
    static func isVisibleEncuesta(inicio: Date,fin: Date) -> Bool{
        var isVisible: Bool = false
        let dateNow = Date()
        if inicio < dateNow && fin > dateNow{
            isVisible = true
        }
        return isVisible
    }
    static func dateFromService(stringDate: String)->Date {
        Utils.dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        Utils.dateFormatter.timeZone = TimeZone.current
        Utils.dateFormatter.locale = Locale.current
        let date = Utils.dateFormatter.date(from: stringDate) ?? Date(timeIntervalSince1970: 0)
        return date
    }
    
    static func stringFromDateService(date: Date)->String {
        Utils.dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        Utils.dateFormatter.timeZone = TimeZone.current
        Utils.dateFormatter.locale = Locale.current
        let dateString = Utils.dateFormatter.string(from: date)
        return dateString
    }
    static func stringFromDateNowName()->String {
        let date = Date()
        Utils.dateFormatter.dateFormat = "ddMMYY"
        Utils.dateFormatter.timeZone = TimeZone.current
        Utils.dateFormatter.locale = Locale.current
        let dateString = Utils.dateFormatter.string(from: date)
        return dateString
    }
    static func stringRemainingDays(now: Date, end: Date) -> String{
        let secondsNow = Int( now.timeIntervalSince1970)
        let secondsEnd = Int( end.timeIntervalSince1970)
        
        let  differenceSeconds = secondsEnd - secondsNow
        if ( differenceSeconds / (3600 * 24)) == 0 {
            return "Hoy cierra"
            }else{
            return "\(( differenceSeconds / (3600 * 24))) días restan"
        }
        
    }
    static func stringFromDateYear()-> String{
        let date = Date()
        Utils.dateFormatter.dateFormat = "yyyy"
        Utils.dateFormatter.timeZone = TimeZone.current
        Utils.dateFormatter.locale = Locale.current
        let dateString = Utils.dateFormatter.string(from: date)
        return dateString
    }
    static func stringFromDateNow()-> String{
        let meses: [String] = ["","enero","febrero","marzo","abril","mayo","junio","julio","agosto","septiembre","octubre","noviembre","diciembre"]
        let ultimateDay = [0,31,28,31,30,31,30,31,31,30,31,30,31]
        let date = Date()
        Utils.dateFormatter.dateFormat = "dd"
        Utils.dateFormatter.timeZone = TimeZone.current
        Utils.dateFormatter.locale = Locale.current
        
        var  dateString = Utils.dateFormatter.string(from: date)
        let day = Int(dateString)!
        Utils.dateFormatter.timeZone = TimeZone.current
        Utils.dateFormatter.dateStyle = .full
        Utils.dateFormatter.locale = Locale.current
        Utils.dateFormatter.dateFormat = "MM"
        let mes = Utils.dateFormatter.string(from: date)
        if day > 8{
        dateString  = "Proyección al \((Int(dateString)! - 1 ))"
        dateString += " de \(meses[Int(mes)!])"
        }else{
            dateString = "Cierre al\(ultimateDay[(Int(mes)! - 1)]) de \(meses[(Int(mes)! - 1)])"
        }
        Utils.dateFormatter.dateFormat = "yyyy"
        Utils.dateFormatter.timeZone = TimeZone.current
        Utils.dateFormatter.locale = Locale.current
        dateString += " \(Utils.dateFormatter.string(from: date))"
        return dateString
    }
    static func dateFromString(stringDate: String)->Date? {
        Utils.dateFormatter.dateFormat = "dd-MM-yyyy"
        Utils.dateFormatter.timeZone = TimeZone.current
        Utils.dateFormatter.locale = Locale.current
        if let date = Utils.dateFormatter.date(from: stringDate) {
            return date
        }
        return nil
    }
    
    static func stringFromDate(date: Date)->String {
        Utils.dateFormatter.dateFormat = "dd-MM-yyyy"
        Utils.dateFormatter.timeZone = TimeZone.current
        Utils.dateFormatter.locale = Locale.current
        let dateString = Utils.dateFormatter.string(from: date)
        return dateString
    }
    
    static func stringHourFromDate(date: Date)->String {
        Utils.dateFormatter.dateFormat = "HH:mm a"
        Utils.dateFormatter.timeZone = TimeZone.current
        Utils.dateFormatter.locale = Locale.current
        let dateString = Utils.dateFormatter.string(from: date)
        return dateString
    }
    
    static func stringToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    

}
