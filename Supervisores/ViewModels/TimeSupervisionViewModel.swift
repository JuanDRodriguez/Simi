//
//  TimeSupervisionViewModel.swift
//  Supervisores
//
//  Created by Oscar Montaño Ayala on 4/3/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import Foundation

enum KeysSupervisionLapse: String {
    case id = "lapseId"
    case amount = "amountId"
    case lapse = "lapseType"
}

enum LapseLastSupervision: String {
    case months = "M"
    case days = "D"
}

class SupervisionLapseViewModel {
    static let shared = SupervisionLapseViewModel()
    var lapseSupervision : [TimeSupervision] = []
    var actionType = "S"
    init() { }
    
    
    func getLapse(type: String, completionHandler : @escaping (Date, Error?) -> Void) {
        self.actionType = type
        if self.lapseSupervision.count > 0{
            completionHandler(self.getNewDateWithPeriod(), nil)
            return
        }
        NetworkingServices.shared.getSupervisionLapse() {
            [unowned self] in
            if let error = $1 {
                completionHandler(Date(), error)
                return
            }
            guard let data = $0 else {
                let error = NSError(domain:"", code:400, userInfo:[ NSLocalizedDescriptionKey: "No hay información"])
                    completionHandler(Date(), error)
                return
            }
            do {
                let decoder = JSONDecoder()
                self.lapseSupervision = try decoder.decode([TimeSupervision].self, from: data)
                completionHandler(self.getNewDateWithPeriod(), nil)
            } catch let error {
                print("ERORR ===>>>> \(error)")
                completionHandler(Date(), error)
            }
        }
    }
    
    func getNewDateWithPeriod()->Date {
        let lapsesType = self.lapseSupervision.filter({$0.type == self.actionType})
        if lapsesType.count > 0 {
            let lapse = lapsesType[0]
            let cal = NSCalendar.current
            switch lapse.lapse {
                case "M":
                    let newDate = cal.date(byAdding: .month, value: -lapse.amount, to: Date())
                    if let date = newDate {
                        return date
                    }
                case "D":
                    let newDate = cal.date(byAdding: .day, value: -lapse.amount, to: Date())
                    if let date = newDate {
                        return date
                    }
                default:
                break
            }
        }
        return Date()
    }
}
