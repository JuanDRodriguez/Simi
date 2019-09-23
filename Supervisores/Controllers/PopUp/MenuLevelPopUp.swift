//
//  MenuLevelPopUp.swift
//  Supervisores
//
//  Created by Sharepoint on 7/12/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import UIKit

class MenuLevelPopUp: UIViewController {
    var delegate : MenuLevelDelegate!
    @IBOutlet weak var btnContacto: UIButton!
    @IBOutlet weak var content: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
self.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        content.layer.borderColor = #colorLiteral(red: 0.5550909638, green: 0.5550909638, blue: 0.5550909638, alpha: 1).cgColor
        content.clipsToBounds = true
        content.layer.borderWidth = 1
        showAnimate()
        if User.currentProfile == Profiles.franchisee {
            btnContacto.isHidden = true
        }
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
    @IBAction func actButton(button: UIButton)  {
        removeAnimate()
        var level: Indicators?
        switch button.titleLabel?.text {
        case "NEGOCIO TOTAL":
            level =  Indicators.negocioTotal
            break
        case "DIRECCIÓN":
            level =  Indicators.direccion
            break
        case "ESTADO":
            level =  Indicators.estado
            break
        case "CIUDAD":
            level =  Indicators.ciudad
            break
        case "MUNICIPIO":
            level =  Indicators.municipio
            break
        case "UNIDAD":
            level =  Indicators.unit
            break
        case "GERENCIA":
            level = Indicators.gerencia
        default:
            level =  Indicators.contacto
            break
        }
        
        delegate.selectedMenuLevel(level: level!)
    }
    @IBAction func close(){
        self.removeAnimate()
        delegate.close()
    }
}
protocol MenuLevelDelegate: class {
    func selectedMenuLevel(level: Indicators )
    func close()
}
