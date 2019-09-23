//
//  MapViewController.swift
//  Supervisores
//
//  Created by Sharepoint on 14/01/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import UIKit
import MapKit
import Lottie

enum SearchUnit: String, CaseIterable {
    case name = "Nombre de la unidad"
    case key = "Número de la unidad"
    case street = "Calle"
    case colony = "Colonia"
    case bussinesName = "Razón social"
    case contact = "Nombre de contacto"
    case closeTo = "Cercanas a..."
}
enum SearchUnitIndicator: String, CaseIterable {
    case name = "Nombre de la unidad"
    case key = "Número de la unidad"
    case bussinesName = "Razón social"
    case contact = "Nombre de contacto"
}

class MapViewController: UIViewController, showIndcatorUnitDelegate,PopUpDelegate, ShowMenuOperationQr {
    
    @IBOutlet weak var btnDriveOptions: UIButton!
    @IBOutlet weak var navigationBar: UIView!
    @IBOutlet weak var searchBar: UIView!
    @IBOutlet weak var mapView: UIView!
    @IBOutlet weak var btnShowHideBricks: UIButton!
    @IBOutlet weak var viewQR: UIView!
    @IBOutlet weak var btnCompass: UIButton!
    @IBOutlet weak var lblLoading: UILabel!
    @IBOutlet weak var stackButtonsDistance: UIStackView!
    
    let titleSearch = "Buscando unidades..."
    let titleError = "Hubo un error buscando unidades"
    var currentRatio : Double = 1
    var locationClose : CLLocationCoordinate2D?
    var pickerView: PickerSelectView? = nil
    var driveOptions : DriveOptionsView?
    var infoBricks : InfoBricksView?
    var infoUnit : InfoUnitView?
    var lottieView : LottieViewController?
    var mapViewSelected : MapsProtocol?
    lazy var mapFactory = { MapsFactory(frame: mapView.bounds) }()
    var appPermissionView: AppPermissions? = nil
    var localizacion: LocalizationDelegate? = nil
    var bricksVM : BricksViewModel?
    var arrayBricks: [[String: Any]] = []
    var bricksShowed = false
    var searchBarVC : SearchBarViewController? = nil
    var unitRoute : [String: Any]?
    var currentPosition: CLLocation?
    var fromDestination: CLLocation?
    var searchingBy = ""
    var searchingFilter : SearchUnit = .name
    var locked = false
    var typing = true
    var task : DispatchWorkItem?
    var ismyUnit = false
    var gestureLottie = LOTAnimationView(name: "tapgesture")
    let modelG = GeneralModel()
    //let controller = QRViewController()
    override func viewDidLoad() {
        super.viewDidLoad()
        mapViewSelected = mapFactory.buildMap(mapType : .nativeMap)
        mapViewSelected?.delegate = self
        mapView.insertSubview(mapViewSelected!.componentView, at: 0)
        self.bricksVM = BricksViewModel(self)
        self.btnShowHideBricks.isEnabled = false
        self.bricksVM?.loadBricks()
        CommonInit.navBArInitMainTabBar(vc: self, navigationBar: self.navigationBar, title: "Mapa")
        
        self.searchBarVC = CommonInit.searchBarInit(vc: self, searchBar: self.searchBar)
        CommonInit.qrViewInit(vc: self, searchBar: self.viewQR, delegate: self )
        self.lottieView = CommonInit.lottieViewInit(vc: self)
        self.searchBarVC?.delegate = self
        self.btnDriveOptions.isHidden = true
        self.stackButtonsDistance.isHidden = true
        self.gestureLottie.isUserInteractionEnabled = false
        self.gestureLottie.isHidden  = true
        self.gestureLottie.loopAnimation = true
        let width = self.mapView.bounds.width / 1.7
        self.gestureLottie.frame = CGRect(x: 0, y: 0, width: width, height: width)
        self.mapView.addSubview(self.gestureLottie)
        NotificationCenter.default.addObserver(self, selector: #selector(showQr), name: .showQR, object: nil)

        self.lblLoading.isHidden = true
        self.showBrickInfo(block: nil)
        
        for subview in self.stackButtonsDistance.subviews {
            if let btn = subview as? UIButton {
                btn.layer.cornerRadius = 5
                btn.setTitleColor(UIColor.blue, for: .normal)
                btn.layer.borderWidth = 2
                btn.layer.borderColor = UIColor.blue.cgColor
            }
        }
        if LoginViewModel.shared.getCurrentProfile() == Profiles.franchisee {
            self.btnShowHideBricks.isHidden = true
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UnitsMapViewModel.shared.setListener(listener: self)
        self.infoUnit = InfoUnitView(parentView: self.mapView)
        self.localizacion = LocalizationDelegate()
        self.localizacion!.delegate = self
        self.driveOptions = DriveOptionsView(parentView:self.mapView)
        self.infoBricks = InfoBricksView(parentView: self.mapView)
        self.driveOptions?.isHidden = true
        self.infoBricks?.isHidden = true
        self.infoUnit?.isHidden = true
        self.infoUnit!.delegate = self
        if self.pickerView == nil {
            var stringCases: [String] = SearchUnit.allCases.map({$0.rawValue})
            if User.currentProfile == .franchisee{
                stringCases = stringCases.filter({$0 != "Nombre de contacto"})
            }
            self.pickerView = PickerSelectView(dataPicker: stringCases, frame: self.view.frame)
            self.pickerView?.lblTitle.text = "Buscar por:"
            self.pickerView!.delegate = self
        }
        self.gestureLottie.center = CGPoint(x: self.mapView.bounds.width / 2.0, y: self.mapView.bounds.height / 2.0)
        UnitInfoViewModel.shared.setListener(listener: self)
        if unitRoute != nil{
        unitsSearched(units: [unitRoute!])
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        UnitsMapViewModel.shared.setListener(listener: nil)
        if self.localizacion != nil {
            self.localizacion!.stopUpdateLocation()
            self.localizacion = nil
            self.unitRoute = nil
        }
        self.infoUnit = InfoUnitView(parentView: self.mapView)
        self.infoUnit!.delegate = self
        self.infoUnit?.removeFromSuperview()
    }
    func lock(){
        self.locked = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.locked = false
        }
    }
    @IBAction func showDriveOptions(_ sender: Any) {
        guard let driveOptions = self.driveOptions else { return }
        if !driveOptions.isHidden {
            driveOptions.isHidden = true
            return
        }
        if let fromDestination = self.fromDestination {
            driveOptions.isHidden = false
            self.infoBricks?.isHidden = true
            self.infoUnit?.isHidden = true
            self.driveOptions?.setDestination(to: fromDestination)
        }
    }
    @IBAction func activeCompass(_ sender: Any) {
        self.mapViewSelected?.activeDeactiveCompass()
    }
    @IBAction func centerUser(_ sender: Any) {
        self.mapViewSelected?.centerUser()
    }
    @IBAction func showHideBricks(_ sender: Any) {
        if self.bricksShowed {
            self.mapViewSelected?.removeBricks()
            self.showBrickInfo(block: nil)
        } else {
            self.btnShowHideBricks.isEnabled = false
            self.mapViewSelected?.showBricks(blocks : self.arrayBricks)
        }
        self.bricksShowed = !self.bricksShowed
    }
    @IBAction func handleLongPress(_ sender: Any) {
        guard let gestureRecognizer = sender as? UILongPressGestureRecognizer else { return }
        if self.searchingFilter == .closeTo && gestureRecognizer.state == .began {
            self.mapViewSelected?.addAnnotationTap(gesture: gestureRecognizer)
        }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.bricksShowed {
            if let touch = touches.first {
                if touch.tapCount == 1 {
                    let touchLocation = touch.location(in: self.mapView)
                    self.mapViewSelected?.touchesInMap(touchLocation: touchLocation)
                }
            }
        }
    }
    @IBAction func showFilters(_ sender: Any) {
        guard let pickerView = self.pickerView else { return }
        self.view.endEditing(true)
        self.view.addSubview(pickerView)
    }
    
    @IBAction func changeRange(_ sender: Any) {
        guard let button = sender as? UIButton else { return }
        guard let location = self.locationClose else { return }
        self.currentRatio = Double(button.tag)
        self.lblLoading.isHidden = false
        self.lblLoading.text = "Radio: \(button.tag)km"
        if !UnitsMapViewModel.shared.searchUnits(searchBy: "", searchFilter: self.searchingFilter, location: location, ratio: self.currentRatio) {
            self.lblLoading.text = titleSearch
            self.lblLoading.isHidden = false
        }
    }
    func actionShowQR(type: typeOperationStore,id: Int) {
        let controller = QRViewController()
        controller.view.frame = searchBar.bounds
        self.addChild(controller)
        controller.didMove(toParent: self)
        controller.goToController(type: type, jsonInfo: Operation.getJsonOffQR(type: type , id: id))
        
    }
    
    func showVisitOrSupervition(qr: QrOperation,id: Int) {
        actClose()
        if Utils.dateCampareToDateNow(stringDate: (GeneralCloseModel.shared.generalClose!.HoraInicio,GeneralCloseModel.shared.generalClose!.HoraFin)){
            print("**********id: \(id)")
            let vc = PopUp()
            vc.id = id
            vc.showSupervision = qr
            self.addChild(vc)
            vc.view.frame = self.view.frame
            self.view.addSubview(vc.view)
            vc.delegate = self
            vc.didMove(toParent: self)
        }else{
            let controller = QRViewController()
            controller.view.frame = searchBar.bounds
            self.addChild(controller)
            controller.didMove(toParent: self)
            if qr == .yes{
            controller.goToQr()
            }else{
                let vc = PopUp()
                vc.id = id
                vc.showSupervision = qr
                self.addChild(vc)
                vc.view.frame = self.view.frame
                self.view.addSubview(vc.view)
                vc.delegate = self
                vc.didMove(toParent: self)
            }
        }
    }
    func actClose() {
        self.infoUnit = nil
        self.infoUnit = InfoUnitView(parentView: self.mapView)
        self.infoUnit!.delegate = self
        self.infoUnit?.isHidden = true
        
    }
    func showIndicator(idUnit: Int,name: String) {
        actClose()
        let detailIndicator = DetailIndicatorsViewController()
        let model = DetailIndicatorModel()
        model.out = detailIndicator
        detailIndicator.model = model
        detailIndicator.from = fromBuild.unitIndicators
        detailIndicator.titleH = name
        model.load(id: idUnit,typeIndicator: Indicators.unit)
        self.present(detailIndicator, animated: true, completion: nil)
    }
    func showDetailUnit(key: String,name: String, unitInfo: UnitInfo) {
        actClose()
        var unit: [String: Any] = [:]
        let unitV = UnitsMapViewModel.shared.arrayAllUnits.filter({$0.key == key})
        unit["idUnit"] = unitV[0].id
        unit[KeysUnit.key.rawValue] = key
        unit[KeysUnit.name.rawValue] = name
        let vc = GeneralInfoViewController(unit: unit)
        modelG.out = vc
        vc.nameUnit = "\(key) \(name)"
        modelG.load(key:key,itemInf:unitInfo)
        self.present(vc, animated: true, completion: nil)
    }
    func actionOpen(delegate: PopUpDelegate) {
        let vc = PopUp()
        vc.id = 0
        vc.showSupervision = .no
        self.addChild(vc)
        vc.view.frame = self.view.frame
        self.view.addSubview(vc.view)
        vc.delegate = delegate
        vc.didMove(toParent: self)
        
    }
    
}

