//
//  EncuestaViewController.swift
//  Supervisores
//
//  Created by Sharepoint on 8/28/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import UIKit

class EncuestaViewController: UIViewController {
    @IBOutlet weak var navBar: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    var model: EncuestaModelInput!
    var lottieView : LottieViewController?
    var encuesta: EncuestasItem!
    var countEncuesta: Int!
    var titleEncuesta: String!
    static var idEncuesta: Int!
    lazy var contentView:EncuentaViewInput = { return view as! EncuentaViewInput}()
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        let center: NotificationCenter = NotificationCenter.default
        center.addObserver(self, selector: #selector(keyboardDidShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        center.addObserver(self, selector: #selector(keyboardShow(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
         self.lottieView = CommonInit.lottieViewInit(vc: self)
         CommonInit.navBarGenericBack(vc: self, navigationBar: self.navBar, title: "Encuesta")
        let vc = EncuestaPopUp()
        vc.delegate = self
        vc.instruccciones = encuesta.Instrucciones
        self.addChild(vc)
        vc.view.frame = self.view.frame
        self.view.addSubview(vc.view)
        vc.didMove(toParent: self)
        contentView.itemAction = {
            self.lottieView?.animationLoading()
            self.model.sendEncuesta(items: $0, photos: $1)
            EncuestaViewController.idEncuesta = self.encuesta.EncuestaId
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
       // self.view.frame.origin.y = -250
        
    }
}
extension EncuestaViewController: InstruccionesEncuestasProtocol,EncuestaModelOutput{
    func modelDidLoadFinish() {
         
        lottieView?.animationFinishCorrect()
        self.dismiss(animated: true , completion:   nil)
    }
    
    func modelDidLoad(_ items: [Question]) {
        lblTitle.text = title
        lottieView?.animationFinishCorrect()
        contentView.display(items)
    }
    
    func modelDidLoadFail() {
        lottieView?.animationFinishError()
        self.dismiss(animated: true, completion: nil)
    }
    
    func loadEncuesta() {
        model.load(id: encuesta.EncuestaId!)
        lottieView?.animationLoading()
    }
    
}
