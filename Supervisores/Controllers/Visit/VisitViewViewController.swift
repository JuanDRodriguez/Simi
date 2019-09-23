//
//  VisitViewViewController.swift
//  Supervisores
//
//  Created by Sharepoint on 7/26/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import UIKit

class VisitViewViewController: UIViewController {
    @IBOutlet weak var navBar: UIView!
    var model: visitModelInput!
    var lottieView : LottieViewController?
    var date: Date!
    lazy var contentView: visitViewInput = { return view as! visitViewInput }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lottieView = CommonInit.lottieViewInit(vc: self)
        date = Date()
        contentView.dataSource = VisitDataSoruce()
        model.load(date: Date())
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        let center: NotificationCenter = NotificationCenter.default
        center.addObserver(self, selector: #selector(keyboardDidShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        center.addObserver(self, selector: #selector(keyboardShow(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        CommonInit.navBarGenericBack(vc: self, navigationBar: self.navBar, title: "Visita")
        contentView.itemAction = {
            self.model.sendVisit(photos: $0, motivos: $1, comentario: $2,date: (self.date,Date()))
            self.lottieView?.animationLoading()
        }
        self.view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard(){
        
        self.view.endEditing(true)
         self.view.frame.origin.y = 0
    }
    @objc func keyboardShow ( notification: Notification){
        self.view.frame.origin.y = 0
    }
    @objc func keyboardDidShow ( notification: Notification){
        self.view.frame.origin.y = -100
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
}
extension VisitViewViewController: visitModelOutput{
    func modelDidLoadSend() {
         lottieView?.animationFinishCorrect()
        self.dismiss(animated: true, completion: nil)
    }
    
    func modelDidFail() {
        lottieView?.animationFinishError()
    }
    
    func modelDidLoad(_ items: [ReasonItem]) {
        lottieView?.animationFinishCorrect()
        contentView.display(items: items)
    }
    
    
}
