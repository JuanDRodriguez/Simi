//
//  InfoView.swift
//  Supervisores
//
//  Created by Oscar Montaño Ayala on 2/4/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import UIKit
import MapKit

class InfoUnitView: UIView{
    @IBOutlet weak var lblPercent: UILabel!
    @IBOutlet weak var btnGo: UIButton!
    @IBOutlet weak var btnIndi: UIButton!
    @IBOutlet weak var btnQr: UIButton!
    @IBOutlet weak var lblUnitTitle: UILabel!
    @IBOutlet weak var lblContact: UILabel!
    @IBOutlet weak var stackServicesUnit: UIStackView!
    @IBOutlet weak var lblEtiqueta: UILabel!
    
    var delegate: showIndcatorUnitDelegate!
    var unit: [String: Any]?
    var isMyUnit = false
    var unitInfo: UnitInfo!
    init(parentView: UIView) {
        let windowH : CGFloat = 90.0
        let windowY : CGFloat = parentView.bounds.size.height - windowH - 10.0
        let windowW : CGFloat = parentView.bounds.size.width - 20.0
       
        super.init(frame: CGRect(x: 10.0, y: windowY, width: windowW, height: windowH))
        let view = Bundle.main.loadNibNamed("InfoUnitView", owner: self, options: nil)![0] as! InfoUnitView
        view.frame = CGRect(x: 0, y: 0, width: windowW, height: windowH)
        self.addSubview(view)
        self.btnGo.imageView?.contentMode = .scaleAspectFit
        if  Operation.getPrivilageforId(idPrivilege: 11) == false{
           btnIndi.isEnabled = false
            
        }
        if  Operation.getPrivilageforId(idPrivilege: 4) == false{
           btnQr.isEnabled = false
        }
        if  Operation.getPrivilageforId(idPrivilege: 1) == false{
            btnGo.isEnabled = false
        }
        parentView.addSubview(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    @IBAction func actionGo(){
         self.removeFromSuperview()
       if let name = self.unit?[KeysUnitInfo.nameUnit.rawValue] as? String, let key = self.unit?[KeysUnitInfo.keyUnit.rawValue] as? String{
        delegate.showDetailUnit(key: key,name: name, unitInfo: self.unitInfo)
        }
        }
       //
        @IBAction func actionIndicators(){
            self.removeFromSuperview()
            let units:[UnitLite] = UnitsMapViewModel.shared.arrayAllUnits
            for i in 0 ..< units.count{
                
                if unit![KeysUnitInfo.keyUnit.rawValue] as! String == units[i].key{
                    delegate.showIndicator(idUnit: units[i].id, name: "\(unit![KeysUnitInfo.keyUnit.rawValue] as! String) \(unit![KeysUnitInfo.nameUnit.rawValue] as! String)")
                    
                    return
                }
        }
    }
    @IBAction func actionQr(){
        self.removeFromSuperview()
        if isMyUnit{
        let status =  self.unit![KeysUnitInfo.unidadId.rawValue] as! Int  > 2 && 5 > self.unit![KeysUnitInfo.unidadId.rawValue] as! Int
          let key = self.unit?[KeysUnitInfo.keyUnit.rawValue] as? String
        let unit = UnitsMapViewModel.shared.arrayAllUnits.filter({
            $0.key == key!
        })
        status == true ? delegate.showVisitOrSupervition(qr:.no,id: unit[0].id) : delegate.showVisitOrSupervition(qr:.yes,id: unit[0].id)
        }else{
             let key = self.unit?[KeysUnitInfo.keyUnit.rawValue] as? String
            let unit = UnitsMapViewModel.shared.arrayAllUnits.filter({
                $0.key == key!
            })
            delegate.showVisitOrSupervition(qr:.yes,id: unit[0].id)
        }
    }
    func setUnit(unit: [String: Any]){
        self.isHidden = false
        for view in self.stackServicesUnit.subviews {
            if let imgService = view as? UIImageView {
                imgService.isHidden = true
            }
        }
        self.unit = unit
        
        self.unitInfo = UnitInfoViewModel.shared.unitInfo
        //print("ObjectUnitInfo: \(unit)")
        self.isHidden = false
        if let key = self.unit?[KeysUnitInfo.keyUnit.rawValue] as? String,
            let name = self.unit?[KeysUnitInfo.nameUnit.rawValue] as? String{
            self.lblUnitTitle.text = "\(key) \(name)"
            let unit = UnitsMapViewModel.shared.arrayAllUnits.filter({
                $0.key == key
            })
        }
        
        
        if TypeUnit.typeUnit == 1{
             self.lblEtiqueta.text = "Gerente:"
             self.lblContact.text = unitInfo.gerente!
            print(unit,self.lblUnitTitle.text )
        }else{
           self.lblEtiqueta.text = "Contacto:"
            if let contact = self.unit?[KeysUnitInfo.contactName.rawValue] as? String {
                self.lblContact.text = contact
            }
        }
        guard let arrayServices = self.unit?[KeysUnitInfo.services.rawValue] as? [[String: Any]] else { return }
        
        for service in arrayServices {
            guard let serviceId = service[KeysServicesUnit.serviceId.rawValue] as? Int else { continue }
            self.stackServicesUnit.viewWithTag(serviceId)?.isHidden = false
        }
        if self.unitInfo.unidadId == 4 || self.unitInfo.unidadId == 3{
            return
        }
        do{
        guard let value = self.unitInfo.indicator?.value else {
            return
        }
        guard let idumbral = self.unitInfo.indicator?.id else{
            return
        }
        lblPercent.text = "\(Int(value))%"
            lblPercent.backgroundColor = UIColor.init(hexString:Operation.getUmbral(id: idumbral, value: Double(value)), alpha: 1.0)
        }catch{
            
        }
        
    }
    func getUmbral(id: Int,value: Double) -> String{
       
        var item = IndicatorCatalog.shared.Catalogue.filter({
            $0.IndicadorId == id
        })
        guard let umbrales = item[0].Umbrales else {
            return "#808080"
        }
        var color = umbrales.filter({
            ($0.ValorMaximo! > value) && ($0.ValorMinimo! < value)
        })
        guard let umbral: String = color[0].Color else {
            return "#808080"
        }
        
        return umbral
    }
}
protocol showIndcatorUnitDelegate {
    func showIndicator(idUnit: Int, name: String)
    func showVisitOrSupervition(qr:QrOperation,id: Int)
    func showDetailUnit(key: String,name: String, unitInfo: UnitInfo)
}
