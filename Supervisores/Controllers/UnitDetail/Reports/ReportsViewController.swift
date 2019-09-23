//
//  ReportsViewController.swift
//  Supervisores
//
//  Created by Sharepoint on 30/01/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import UIKit

class ReportsViewController: UIViewController {
    @IBOutlet weak var navBar: UIView!
    var unit: [String: Any]
    var model: ReportsModelInput!
    var button: UIButton!
    var lottieView : LottieViewController?
    var pickerView: PickerSelectView? = nil
    lazy var contentView: ReportsViewInput = { return view as! ReportsViewInput}()
    init(unit: [String: Any]){
        self.unit = unit
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.unit = [:]
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lottieView = CommonInit.lottieViewInit(vc: self)
        var nameUnit = ""
        if let name = self.unit[KeysUnit.name.rawValue] as? String, let key = self.unit[KeysUnit.key.rawValue] as? String {
            nameUnit = "\(key) \(name)"
        }
        CommonInit.navBArIndicators(vc: self, navigationBar: self.navBar, title: nameUnit)
        contentView.itemAction = {
            //print("idMotivo: \($0)")
            self.openPopUp()
        }
        contentView.itemActionSend = {
            self.lottieView?.animationLoading()
            self.model.sendLoad(param: $0)
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        model.load()
    lottieView?.animationLoading()
    }
    func openPopUp(){
        
        if self.pickerView == nil {
            let stringCases: [String] = IncumplimientoModel.shared.items.map({$0.EstatusSeguimiento})
            self.pickerView = PickerSelectView(dataPicker: stringCases, frame: self.view.frame)
            self.pickerView?.lblTitle.text = "Cambiar estatus por:"
            self.pickerView!.delegate = self
        }
        guard let pickerView = self.pickerView else { return }
        self.view.endEditing(true)
        self.view.addSubview(pickerView)
    }
}
extension ReportsViewController: ReportModelOutput{
    func modelDidLoad(_ items: ReportItem) {
        lottieView?.animationFinishCorrect()
        contentView.display(items)
    }
    
    func modelDidLoadFail() {
        lottieView?.animationFinishError()
    }
    func modelDidLoadFinish(){
        lottieView?.animationFinishCorrect()
    }
    
}
extension ReportsViewController: PickerSelectViewDelegate{
    func selectOption(_ option: Int, value: String) {
        //print("id: \(option) description: \(value)")
        contentView.displayUpdate(option + 1, status: value)
       
        self.pickerView?.removeFromSuperview()
        self.pickerView = nil
    }
    
    func cancelOption() {
        self.pickerView?.removeFromSuperview()
    }
    
    
}
