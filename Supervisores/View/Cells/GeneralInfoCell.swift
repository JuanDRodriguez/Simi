//
//  GeneralInfoCell.swift
//  Supervisores
//
//  Created by Sharepoint on 8/14/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import UIKit
import Lottie

class GeneralInfoCell: UITableViewCell {
    let labels: [String] = ["Razón social","Dirección","Telefono","Horario","Supervisor","Gerente","Director"]
    let img: [String] = ["razonSocial","Direccion","telefono","Horario","Username","Username","Username"]
     static var reuseIdentifier: String = "\(String(describing: self))"
    @IBOutlet weak var stackServicesUnit: UIStackView!
    @IBOutlet weak var viewStars: UIView!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var viewServices: UIView!
    @IBOutlet weak var viewStar1: UIView!
    @IBOutlet weak var viewStar2: UIView!
    @IBOutlet weak var viewStar3: UIView!
    @IBOutlet weak var viewStar4: UIView!
    @IBOutlet weak var viewStar5: UIView!
    var lottieStars : [LOTAnimationView] = []
    var stars = 5
    override func awakeFromNib() {
        super.awakeFromNib()
        for view in self.stackServicesUnit.subviews {
            if let imgService = view as? UIImageView {
                imgService.isHidden = true
            }
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func display(item: String,index: Int){
        
        viewServices.isHidden = true
        viewStars.isHidden = true
        lblDescription.text = "\(labels[index]):\n\(item)"
        imgView.image = UIImage(named: img[index])
        
    }
    func display(items: [Service]){
       viewServices.isHidden = false
        viewStars.isHidden = true
        if items.count > 0{
            for service in items {
                self.stackServicesUnit.viewWithTag(service.id)?.isHidden = false
            }
        }
    }
    func display(stars: Int){
        viewServices.isHidden = true
         viewStars.isHidden = false
        createStars(numberStars: stars)
    }
    func createStars(numberStars: Int) {
        let sizeLottie = self.viewStar1.frame.width * 2.0
        let centerAnim = CGPoint(x: self.viewStar1.frame.width / 2.0 , y: self.viewStar1.frame.height / 2.0)
        for _ in 0..<5 {
            let lottie = LOTAnimationView(name: "star")
            lottie.isUserInteractionEnabled = false
            lottie.frame = CGRect(x: 0.0, y: 0.0, width: sizeLottie, height: sizeLottie)
            self.lottieStars.append(lottie)
        }
        self.viewStar1.addSubview(self.lottieStars[0])
        self.lottieStars[0].center = centerAnim
        self.viewStar2.addSubview(self.lottieStars[1])
        self.lottieStars[1].center = centerAnim
        self.viewStar3.addSubview(self.lottieStars[2])
        self.lottieStars[2].center = centerAnim
        self.viewStar4.addSubview(self.lottieStars[3])
        self.lottieStars[3].center = centerAnim
        self.viewStar5.addSubview(self.lottieStars[4])
        self.lottieStars[4].center = centerAnim
        
        let maxNumberStars = numberStars > 5 ? 4 : numberStars
        for i in 0..<maxNumberStars {
            DispatchQueue.main.asyncAfter(deadline: .now() + (Double(i) * 0.1), execute: {
                Utils.runAnimation(lottieAnimation: self.lottieStars[i], from: 0, to: 30)
            })
        }
    }
}
