//
//  OderIndicatorPopUp.swift
//  Supervisores
//
//  Created by Sharepoint on 7/12/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import UIKit

class OderIndicatorPopUp: UIViewController {
    @IBOutlet weak var content: UIView!
    var delegate: OrderIndicatorDelegate!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0)
        content.layer.borderColor = #colorLiteral(red: 0.5550909638, green: 0.5550909638, blue: 0.5550909638, alpha: 1).cgColor
        content.clipsToBounds = true
        content.layer.borderWidth = 1
        content.layer.cornerRadius = CGFloat(10.0)
        showAnimate()
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

    @IBAction func action(button: UIButton){
        removeAnimate()
        delegate.orderIndicators(typeOrder: .name)
    }

}
protocol OrderIndicatorDelegate {
    func orderIndicators(typeOrder: TypeOrder)
}
