//
//  QRViewController.swift
//  Supervisores
//
//  Created by Sharepoint on 21/01/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import UIKit

enum KeysQr: String {
    case timeStamp = "TimeStamp"
    case isVisit = "EsVisita"
    case unitId = "FarmaciaId"
    case keyUnit = "FarmaciaClave"
    case typeUnit = "TipoFarmacia"
    case nameUnit = "NombreFarmacia"
    case supervisorKey = "ClaveSupervisor"
    case userInfo = "Supervisor"
    case type = "Tipo"
}

class QRViewController: UIViewController, QRReaderProtocol {
    let qrReader = QrReaderViewController()
    let supervision = SupervisionViewController()
    var vc: UIViewController!
    var type: typeOperationStore!
    var delegate: ShowMenuOperationQr!
    var encuesta: EncuestasItem!
    var countEncu: Int!
    var idUnit: Int!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.qrReader.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = false
    }
    func goToQr(){
        qrReader.type = self.type
        self.present(qrReader, animated: true, completion: nil)
    }
    func goToController(type: typeOperationStore,jsonInfo: [String : Any]){
        let supData = Storage.shared.getCurrentSupervision()
        self.type = type
        if  type == .supervision{
            if supData.idUnit != 0 {
                goToQr()
            } else {
                
            self.readingQR(jsonInfo: jsonInfo, wasOnPause: false,statusUnit: 3)
            }
        }
        else{
            let visit = VisitViewViewController()
            let model = VisitModel()
            model.json = jsonInfo
            model.out = visit
            model.idUnit = supData.idUnit
            visit.model = model
            self.present(visit, animated: true, completion: nil)
        }
    
           
        
        
    }
    @IBAction func goToQrReader(_ sender: Any) {
        
 
       delegate.actionOpen(delegate: self)
//        let dicto : [String: Any] = ["TimeStamp": 1549399287980,
//                                     "FarmaciaId": 1,
//                                    "Tipo": "supervision",
//                                    "TipoFarmacia": "Sucursal",
//                                    "NombreFarmacia": "ANTILLAS",
//                                    "FarmaciaClave": "01",
//                                        "ClaveSupervisor" : "07-02",
//                                    "Supervisor": [
//                                        "Activo" : 1,
//                                        "ApellidoMaterno" : "López",
//                                        "ApellidoPaterno" : "Colín",
//                                        "CorreoElectronico" : "sisrlopez@fsimilares.com",
//                                        "CuentaDominio" : "SIMI\\sisrlopez",
//                                        "Nombre" : "Hazael",
//                                        "UsuarioId" : 2]]
//        self.readingQR(jsonInfo: dicto, wasOnPause: true)
    }
    
    func readingQR(jsonInfo: [String : Any], wasOnPause: Bool,statusUnit: Int32) {
        guard let idUnit = jsonInfo["FarmaciaId"] as? Int else {return}
        if type == typeOperationStore.supervision{
        print("JsonForForVisit\(jsonInfo)")
        self.supervision.unitInfo = jsonInfo
        CurrentSupervision.shared.setCurrentUnit(unit: jsonInfo)
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.isNavigationBarHidden = false        
          guard let idUnit = jsonInfo["FarmaciaId"] as? Int else {return}
            guard let unitName = jsonInfo[KeysQr.nameUnit.rawValue] as? String else {return}
            guard let typeUnit = jsonInfo[KeysQr.typeUnit.rawValue] as? String else {return}
            guard let supervisorKey = jsonInfo[KeysQr.supervisorKey.rawValue] as? String else {return}
            let supervisor = jsonInfo["Supervisor"] as! [String : Any]
            guard let name = supervisor["NombreCompleto"] as? String else {return}
            guard let domainAccount = supervisor["CuentaDominio"]as? String else {return}
            self.idUnit = idUnit
            let supInfo = SupervisionData(idUnit: idUnit,
                                          unitName: unitName,
                                          typeUnit: typeUnit,
                                          supervisorKey: supervisorKey,
                                          statusUnit: statusUnit,
                                          nameSupervisor: name,
                                          domainAccount: domainAccount,
                                          completion: false,
                                          dateStart: nil)
            
            //        guard let userInfo = jsonInfo[KeysQr.userInfo.rawValue] as? [String: Any] else {return}
            let _ = Storage.shared.startSupervision(supervisionData: supInfo)
        if wasOnPause {
            Storage.shared.updateLastPause()
        }
           
            
            supervision.nameSup = "\(supervisor["NombreCompleto"] as! String)"
            SupervisionViewController.unitId = idUnit
            supervision.TypeStore = jsonInfo["TipoFarmacia"] as! String
        self.present(supervision, animated: true, completion: nil)
        }else if type == typeOperationStore.encuesta{
            let modelEncuesta = EncuestaModel()
            let vc = EncuestaViewController()
            let idUnit = jsonInfo[KeysQr.unitId.rawValue] as? Int
            modelEncuesta.out = vc
            vc.model = modelEncuesta
            modelEncuesta.idUnit = idUnit!
            vc.encuesta = self.encuesta
            vc.countEncuesta = self.countEncu
            vc.title = self.encuesta.Nombre!
             self.present(vc, animated: true, completion: nil)
        }
        else{
            let idUnit = jsonInfo[KeysQr.unitId.rawValue] as? Int
            let visit = VisitViewViewController()
            let model = VisitModel()
            model.idUnit = idUnit
            model.out = visit
            model.json = Operation.getJsonOffQR(type: .visita , id: idUnit!)
            visit.model = model
           self.present(visit, animated: true, completion: nil)
        }
    }
    func setTypeOption(type: typeOperationStore) {
        self.type = type
    }

}
extension QRViewController: PopUpDelegate{
    func actionShowQR(type: typeOperationStore, id: Int) {
         self.type = type
         goToQr()
    }
    
    func actClose() {
        
    }
    
    
}
protocol ShowMenuOperationQr {
    func actionOpen(delegate: PopUpDelegate)
}
