//
//  UnitsViewController.swift
//  Supervisores
//
//  Created by Sharepoint on 14/01/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import UIKit
import MapKit

enum OrderUnit: String, CaseIterable {
    case distance = "Distancia"
    case increaseYby = "Incremento año vs año"
    case amountIssues = "Cantidad de incumplimientos"
    case unitName = "Nombre de unidad"
    case newOpen = "Fecha de apertura"
    case lastSupervision = "Última supervisión"
}

class UnitsViewController: UIViewController {
    @IBOutlet weak var navigationBar: UIView!
    @IBOutlet weak var searchBar: UIView!
    @IBOutlet weak var unitList: UITableView!
    @IBOutlet weak var viewQR: UIView!
    @IBOutlet weak var lblInfoText: UILabel!
    @IBOutlet weak var btnSwitchOptions: UIButton!
    var pickerView: PickerSelectView? = nil
    var appPermissionView: AppPermissions? = nil
    var localizacion: LocalizationDelegate? = nil
    var mapViewSelected : MapsProtocol?
    var unitsList : [[String : Any]] = []
    var arrayHeaders : [String] = []
    var unitsByState : [String: [[String: Any]]] = [:]
    var currentLocation : CLLocation?
    var currentOder: OrderUnit = OrderUnit.distance
    var orderFunctions: [OrderUnit: OrderFunction]?
    var searchBarVC : SearchBarViewController? = nil
    var textSearching : String = ""
    var lottieView : LottieViewController?
    var delegate: ProtocolMainTabBar!
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
        let nib = UINib(nibName: "UnitCell", bundle: nil)
        self.unitList.register(UnitCell.self, forCellReuseIdentifier: Cells.unitCell.rawValue)
        self.unitList.register(nib, forCellReuseIdentifier: Cells.unitCell.rawValue)
        CommonInit.navBArInitMainTabBar(vc: self, navigationBar: self.navigationBar, title: "Planeación de supervisiones")
        self.searchBarVC = CommonInit.searchBarInit(vc: self, searchBar: self.searchBar)
        self.lottieView = CommonInit.lottieViewInit(vc: self)
        CommonInit.qrViewInit(vc: self, searchBar: self.viewQR, delegate:self)
        self.lblInfoText.text = self.currentOder.rawValue
        self.searchBarVC?.delegate = self
        self.unitList.addSubview(self.refreshControl)
        self.lottieView?.animationLoading()
        UnitsMapViewModel.shared.getAllUnits()
        MyUnitsViewModel.shared.setListener(listener: self)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        DispatchQueue.main.async {
             let _ = MyUnitsViewModel.shared.getMyUnits(orderBy: self.currentOder)
        }
        
       
        
        self.localizacion = LocalizationDelegate()
        self.localizacion!.delegate = self
        if self.pickerView == nil {
            let stringCases: [String] = OrderUnit.allCases.map({$0.rawValue})
            self.pickerView = PickerSelectView(dataPicker: stringCases, frame: self.view.frame)
            self.pickerView?.lblTitle.text = "Ordenar unidades por:"
            self.pickerView!.delegate = self
        }
        self.btnSwitchOptions.superview?.bringSubviewToFront(self.btnSwitchOptions)
        unitList.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //MyUnitsViewModel.shared.setListener(listener: nil)
        self.localizacion!.stopUpdateLocation()
    }
    
    @IBAction func changeOrderUnits(_ sender: Any) {
        guard let pickerView = self.pickerView else {
            return
        }
        self.view.addSubview(pickerView)
    }
    
}
extension UnitsViewController: ShowMenuOperationQr{
    func actionOpen(delegate: PopUpDelegate){
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
