//
//  NotasViewController.swift
//  Supervisores
//
//  Created by Sharepoint on 8/26/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import UIKit

class NotasViewController: UIViewController {
    @IBOutlet weak var navBar: UIView!
    var model: NotasModelInput!
    var lottieView : LottieViewController?
    var idUnit = ""
    var nameUnit: String!
    var direccion: String!
     @IBOutlet weak var segmentControl: UISegmentedControl!
    let vc = TareaViewController()
    lazy var contentView: NotasViewInput = {return view as! NotasViewInput}()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lottieView = CommonInit.lottieViewInit(vc: self)
        CommonInit.navBarGenericBack(vc: self, navigationBar: navBar, title: "Notas")
        contentView.dataSource = NotasDataSource()
        contentView.dataSource.vc = self
    
        contentView.itemAction = {
            
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        model.load(id: 0)
       
    
    }
    @IBAction func actionSegmentControl(){
        switch self.segmentControl.selectedSegmentIndex {
        case 0:
            let vc = NuevaNotaPopUp()
            vc.delegaete = self
            vc.opertion = .newNota
            self.addChild(vc)
            vc.view.frame = self.view.frame
            self.view.addSubview(vc.view)
            vc.didMove(toParent: self)
            break
        case 1:
            actNewTask()
            break
        default:
            break
        }
    }
    func actNewTask(){
        
        vc.idUnit = self.idUnit
        self.present(vc, animated: true, completion: nil)
    }
    
}
extension NotasViewController: NotasModelOutput{
    func modelDidLoad(_ items: [NotasItem]) {
        contentView.display(items)
        contentView.display(self.nameUnit, direcc: direccion)
        lottieView?.animationFinishCorrect()
    }
    
    func modelDidLoadFail() {
        
    }
    
    
}
extension NotasViewController: NotaCellProtocol{
    func openPopUp(item: NotasItem) {
        let vc = NuevaNotaPopUp()
        vc.delegaete = self
        vc.opertion = .updateNota
        vc.item = item
        self.addChild(vc)
        vc.view.frame = self.view.frame
        self.view.addSubview(vc.view)
        vc.didMove(toParent: self)
    }
    
    func actEdit(item: NotasItem) {
        lottieView?.animationLoading()
        model.Update(item: (Int(item.idNota),item.title,item.detail))
    }
    
    func actDelete(item: NotasItem) {
        model.delete(item: item)
        lottieView?.animationLoading()
    }
    
    
}
