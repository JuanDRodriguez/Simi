//
//  DriveOptionsViewController.swift
//  Supervisores
//
//  Created by Sharepoint on 30/01/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import UIKit
import MapKit

class DriveOptionsView: UIView {
    @IBOutlet weak var btnMaps: UIButton!
    @IBOutlet weak var btnGoogleMaps: UIButton!
    @IBOutlet weak var btnWaze: UIButton!
    var to : CLLocation? = CLLocation(latitude: 19.4978, longitude: -99.1269)
    
    init(parentView: UIView) {
        let windowH : CGFloat = 150.0
        let windowY : CGFloat = parentView.bounds.size.height - windowH
        let windowW : CGFloat = parentView.bounds.size.width
        super.init(frame: CGRect(x: 0, y: windowY, width: windowW, height: windowH))
        let view = Bundle.main.loadNibNamed("DriveOptionsView", owner: self, options: nil)![0] as! DriveOptionsView
        view.frame = CGRect(x: 0, y: 0, width: windowW, height: windowH)
        self.addSubview(view)
        parentView.addSubview(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func checkApps(){
        self.btnGoogleMaps.imageView?.contentMode = .scaleAspectFit
        self.btnMaps.imageView?.contentMode = .scaleAspectFit
        self.btnWaze.imageView?.contentMode = .scaleAspectFit

        if UIApplication.shared.canOpenURL(URL(string:"maps://")!) {
            self.btnMaps.isHidden = false
        } else {
            self.btnMaps.isHidden = true
        }
        if UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!) {
            self.btnGoogleMaps.isHidden = false
        } else {
            self.btnGoogleMaps.isHidden = true
        }
        if UIApplication.shared.canOpenURL(URL(string: "waze://")!)  {
            self.btnWaze.isHidden = false
        } else {
            self.btnWaze.isHidden = true
        }
    }
    func setDestination(to: CLLocation){
        self.isHidden = false
        self.checkApps()
        self.to = to
    }
    @IBAction func closeModal(_ sender: Any) {
        self.isHidden = true
    }
    @IBAction func openMaps(_ sender: Any) {
        if let lat = self.to?.coordinate.latitude,
            let lng = self.to?.coordinate.longitude {
            let query = "?daddr=\(lat),\(lng)"
            if let url = URL(string: "http://maps.apple.com/maps\(query)"){
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
    @IBAction func openGoogleMaps(_ sender: Any) {
        if let lat = self.to?.coordinate.latitude,
            let lng = self.to?.coordinate.longitude {
            if let url = URL(string: "comgooglemaps://?saddr=&daddr=\(lat),\(lng)&directionsmode=driving"){
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
    @IBAction func openWaze(_ sender: Any) {
        if let lat = self.to?.coordinate.latitude,
            let lng = self.to?.coordinate.longitude {
            if let url = URL(string: "waze://?ll=\(lat),\(lng)&navigate=yes"){
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
}
