//
//  AppPermissions.swift
//  Supervisores
//
//  Created by Sharepoint on 16/01/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import UIKit

enum Permissions: String {
    case location = "Ve a configuración y da permisos para utilizar la localización"
    case camera = "Ve a configuración y da permisos para utilizar la cámara"
}

class AppPermissions: UIView {
    @IBOutlet weak var lblInfo: UILabel!
    init(frame: CGRect, permision: Permissions) {
        super.init(frame: frame)
        let view = Bundle.main.loadNibNamed("AppPermissions", owner: self, options: nil)![0] as! AppPermissions
        view.frame = frame
        self.addSubview(view)
        self.lblInfo.text = permision.rawValue
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @IBAction func gotToSettings(_ sender: Any) {
        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
    }
}
