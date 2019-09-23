//
//  SupervisionViewController.swift
//  Supervisores
//
//  Created by Sharepoint on 22/01/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import UIKit

enum KeysOperation: String {
    case visit = "visita"
    case supervision = "supervision"
}

enum KeysUnitType: String {
    case branchOffice = "Sucursal"
    case franchise = "Franquicia"
}

enum KeysSupervision: String {
    case timeStamp = "TimeStamp"
    case unitId = "FarmaciaId"
    case unitKey = "FarmaciaClave"
    case unitName = "NombreFarmacia"
    case unitType = "TipoFarmacia"
    case typeOperation = "Tipo"
}

enum KeysSupervisor: String {
    case active = "Activo"
    case middleName = "ApellidoMaterno"
    case lastName = "ApellidoPaterno"
    case name = "Nombre"
    case email = "CorreoElectronico"
    case domainAccount = "CuentaDominio"
    case id = "UsuarioId"
}

class SupervisionViewController: UIViewController {
    @IBOutlet weak var navBar: UIView!
    var modulesList: [[String: Any]] = []
    var modulesFilter: [Int] = []
    var unitInfo: [String: Any] = [:]
    var supervisionComplete = false
    var TypeStore = ""
    @IBOutlet weak var btnPauseSupervision: UIButton!
    @IBOutlet weak var btnEndSupervision: UIButton!
    @IBOutlet weak var categoryList: UICollectionView!
    var pickerView: PickerSelectView? = nil
    var cornerRadius : CGFloat = 0.0
    var navBarVC: SupervisionNavBarViewController?
    var lottieView : LottieViewController?
    var loadingReasons = false
    var dissmisOnEnter = false
    var pauseReasons : [[String: Any]] = []
    var isEditingSupervision = false
    var nameSup = ""
    static var unitId = 0
    var countNewBreaches = 0
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(self.handleRefresh(_:)),
                                 for: UIControl.Event.valueChanged)
        refreshControl.tintColor = UIColor.blue
        
        return refreshControl
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        BreachLevelViewModel.shared.getBreachesLevel()
        ActionsViewModel.shared.getActions(type: "S")

        let nib = UINib(nibName: "SupervisionItemCollectionViewCell", bundle: nil)
        self.categoryList.register(SupervisionItemCollectionViewCell.self, forCellWithReuseIdentifier: Cells.supervisionCell.rawValue)
        self.lottieView = CommonInit.lottieViewInit(vc: self)
        self.categoryList.register(nib, forCellWithReuseIdentifier: Cells.supervisionCell.rawValue)
        self.navBarVC = CommonInit.navBArInitSupervision(vc: self, navigationBar: self.navBar, title: "")
        self.categoryList.addSubview(self.refreshControl)
        let _ = PauseReasonsViewModel.shared.getReasons()
        self.btnPauseSupervision.layer.borderColor = UIColor.blue.cgColor
    }
    override func viewWillAppear(_ animated: Bool) {
        self.btnEndSupervision.isEnabled = true
        self.btnEndSupervision.alpha = 1.0
        self.loadingReasons = false
        self.checkSupervisionFinish()
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.modulesList = []
    }
    func checkSupervisionFinish() {
        var supervisionComplete = true
        if self.isEditingSupervision {
            
            self.modulesList = self.modulesList.map({
                var arrRet = $0
                for i in 0..<self.modulesFilter.count{
                    if arrRet[KeysModule.id.rawValue] as! Int == self.modulesFilter[i]{
                        arrRet[KeysModule.percentFinish.rawValue] = 100
                    }
                }
                
                return arrRet
            })
        }
        for  module in self.modulesList {
            guard let percent = module[KeysModule.percentFinish.rawValue] as? Int else { continue }
            if percent < 100 {
                supervisionComplete = false
                break
            }
        }
        if self.modulesList.count > 0 && supervisionComplete {
            Storage.shared.completeCurrentSupervision()
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        if self.dissmisOnEnter {
            self.dismiss(animated: true, completion: nil)
            self.dissmisOnEnter = false
            return
        }
        SupervisionModulesViewModel.shared.setListener(listener: self)
        if self.modulesList.count == 0 {
            let hasModules = SupervisionModulesViewModel.shared.getModules(ovirrideCurrent: false)
            if !hasModules {
                self.lottieView?.animationLoading()
            }
            self.cornerRadius = self.categoryList.frame.width / 2.8
        }
        PauseReasonsViewModel.shared.setListener(listener: self)
        if self.pickerView == nil {
            self.pickerView = PickerSelectView(dataPicker: [], frame: self.view.frame)
            self.pickerView?.setTitle(title: "Selecciona un motivo de pausa")
            self.pickerView!.delegate = self
            self.pickerView!.showCancelButton()
        }
//        let unitName = unitInfo[KeysSupervision.unitName.rawValue] as? String ?? ""
        if let titulo = unitInfo[KeysSupervision.typeOperation.rawValue] as? String {
            if titulo == KeysOperation.visit.rawValue {
                navBarVC?.setTitle(newTitle:"Visita")// \(unitName)")
            } else {
                navBarVC?.setTitle(newTitle:"Supervisión")// \(unitName)")
            }
        } else {
            navBarVC?.setTitle(newTitle:"Supervisión")// \(unitName)")
        }
        self.categoryList.reloadData()
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
//        let (idUnit, _, _) = Storage.shared.getCurrentSupervision()
//        if idUnit != -1 {
//            self.refreshControl.endRefreshing()
//            return
//        }
        for module in self.modulesList {
            guard let percent = module[KeysModule.percentFinish.rawValue] as? Int else { continue }
            if percent > 0 {
                self.refreshControl.endRefreshing()
                return
            }
        }
        let _ = SupervisionModulesViewModel.shared.getModules(ovirrideCurrent: true)
        self.lottieView?.animationLoading()
    }
    @IBAction func endSupervision(_ sender: Any) { // TO PREVIEW
    
        let previewVC = SupervisionResumeViewController()
        previewVC.delegate = self
        let supervisionData = Storage.shared.getCurrentSupervision()
        var dateString = ""
        if let date = supervisionData.dateStart {
            dateString = Utils.stringFromDate(date: date)
        }
        let (key, address) = UnitsMapViewModel.shared.getInfoUnit(id: supervisionData.idUnit)
        let currentSupervision = CurrentSupervision.shared.getCurrentUnit()
        self.present(previewVC, animated: true, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            
            previewVC.setPreviewInfo(unitKey: key,
                                     unitName: supervisionData.unitName,
                                     address: address,
                                     dateSupervision: dateString,
                                     supKey: supervisionData.supervisorKey,
                                     typeUnit: supervisionData.typeUnit,
                                     nameSup: self.nameSup, domainAccount: supervisionData.domainAccount)
        
            }
        
    }
    @IBAction func pauseSupervision(_ sender: Any) {
        if self.pauseReasons.count == 0 {
            self.loadingReasons = true
            let _ = PauseReasonsViewModel.shared.getReasons()
            return
        } else {
            guard let pickerView = self.pickerView else {
                return
            }
            self.view.addSubview(pickerView)
        }
    }
}
