//
//  UnitCell.swift
//  Supervisores
//
//  Created by Oscar Montaño Ayala on 1/20/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import UIKit
import MapKit

class UnitCell: UITableViewCell {
    @IBOutlet weak var lblUnit: UILabel!
    @IBOutlet weak var lblInfo: UILabel!
    @IBOutlet weak var foundBy: UILabel!
    
    var unit: [String: Any] = [:]
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    func setInfoCell(unit: [String: Any], orderBy: OrderUnit, currentPosition: CLLocation?, textSearched: String) {
        self.unit = unit
        guard let key = unit[KeysUnit.key.rawValue] as? String else { return }
        guard let name = unit[KeysUnit.name.rawValue] as? String else { return }

        self.lblUnit.text = "  \(key.replacingOccurrences(of: " ", with: "")) - \(name)"
        let (text, color) = self.getInfoUnitByOrder(currentOrder: orderBy, currentPosition: currentPosition)
        if orderBy == .increaseYby{
             self.lblInfo.text = "\(text)%"
        }else{
           self.lblInfo.text = text
        }
       
        self.lblInfo.textColor = color
        if textSearched != "" {
            self.foundBy.text = "  \(unit[KeysUnit.foundBy.rawValue] as? String ?? "")"
        }
    }
    @IBAction func goToMap(_ sender: Any) {
        NotificationCenter.default.post(name: .goToMapWithUnit, object: self.unit)
    }
    func getInfoUnitByOrder(currentOrder: OrderUnit, currentPosition: CLLocation?)->(String, UIColor) {
        let dateFormatter : DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale.current
        switch currentOrder {
        case .unitName, .distance:
            if let currentLocation = currentPosition {
                let lat: CLLocationDegrees = unit[KeysUnit.lat.rawValue] as? CLLocationDegrees ?? 0.0
                let lng: CLLocationDegrees = unit[KeysUnit.lng.rawValue] as? CLLocationDegrees ?? 0.0
                var distance = currentLocation.distance(from: CLLocation(latitude: lat, longitude: lng))
                distance = distance / 1000.0
                return ("\(String(format: "%.2f", distance)) km", .darkGray)
            }
            return ("----", .red)
        case .amountIssues:
            if let numberIssues = unit[KeysUnit.numberIssues.rawValue]{
                return ("\(numberIssues)", .darkGray)
            }
            return ("----", .red)
        case .increaseYby:
            if let increaseDicto = unit[KeysUnit.unitIncreaseYBY.rawValue] as? [String: Any]{
                if let amountIncrease = increaseDicto[KeysIncreaseYBY.value.rawValue]{
                    return ("\(amountIncrease)", .darkGray)
                }
            }
            return ("----", .red)
        case .newOpen:
            if let dateOpen = unit[KeysUnit.openDate.rawValue] as? Date {
                let dateFormater = dateFormatter.string(from: dateOpen)
                let componentsLeftTime = Calendar.current.dateComponents([.day, .month, .year], from: dateOpen, to: Date())
                if let year = componentsLeftTime.year{
                    let greenBandera = UIColor(red: (102.0 / 255.0), green: (204.0 / 255.0), blue: (0.0 / 255.0), alpha: 1.0)
                    return ("\(dateFormater)", year < 1 ? greenBandera : .darkGray)
                }
                return ("\(dateFormater)", .red)
            }
            return ("----", .red)
        case .lastSupervision:
            if let lastSupDicto = unit[KeysUnit.lastSupervision.rawValue] as? [String: Any] {
                if let lastSupervision = lastSupDicto[KeysLastSupervision.lastSupervision.rawValue] as? Date {
                    let key = unit[KeysUnit.typeUnit.rawValue] as? Int ?? 1
                    var type = "S"
                    if key == UnitsType.franchise.rawValue { type = "F" }
                    SupervisionLapseViewModel.shared.getLapse(type: type){[unowned self]
                        date, error  in
                        if let _ = error { }
                        else {
                            if lastSupervision < date {
                                DispatchQueue.main.async {
                                    self.lblInfo.textColor = .red
                                }
                            }
                        }
                    }
                    let dateFormater = dateFormatter.string(from: lastSupervision)
                    return ("\(dateFormater)", .darkGray)
                }
            }
            return ("----", .darkGray)
        }
    }
}
