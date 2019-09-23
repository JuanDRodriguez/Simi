//
//  PopUp.swift
//  Supervisores
//
//  Created by Sharepoint on 6/27/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import UIKit

class PopUp: UIViewController {

    @IBOutlet weak var btn : UIButton!
    @IBOutlet weak var viewMenu: UIView!
    @IBOutlet weak var stackView: UIStackView!
    var delegate: PopUpDelegate!
    var showSupervision: QrOperation!
    var id: Int!
    override func viewDidLoad() {
        super.viewDidLoad()

        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        self.showAnimate()
        
        viewMenu.layer.cornerRadius = CGFloat(20.0)
        viewMenu.clipsToBounds = true
        viewMenu.layer.borderWidth = 1
        viewMenu.layer.borderColor = UIColor.gray.cgColor
        if showSupervision == .no {
            stackView.isHidden = false
        }else{
            stackView.isHidden = true
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func showAnimate()
    {
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.45, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
    func removeAnimate()
    {
        UIView.animate(withDuration: 0.45, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0;
        }, completion:{(finished : Bool)  in
            if (finished)
            {
               
               self.view.removeFromSuperview()
            }
        });
    }

    @IBAction func goToSupervision(button: UIButton){
        removeAnimate()
        //print("Id: \(id)")
         delegate.actionShowQR(type: .supervision,id: self.id)
        
        
        
    }
    @IBAction func goToVisit(){
        removeAnimate()
       delegate.actionShowQR(type: .visita,id: self.id)
    }
    @IBAction func closePopUp(){
       removeAnimate()
    }

}
protocol PopUpDelegate {
    func actionShowQR(type: typeOperationStore,id: Int)
    func actClose()
}
