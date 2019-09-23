//
//  BaseView.swift
//  Supervisores
//
//  Created by Sharepoint on 7/11/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//


import UIKit

protocol NibLoadable {
    func nibSetup() -> UIView
    func nibName() -> String
}


@IBDesignable
class BaseView: UIView, NibLoadable  {
    
    @IBOutlet weak var view: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        view = nibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        view = nibSetup()
    }
}
extension NibLoadable where Self : UIView {
    
    func nibSetup() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName(), bundle: bundle)
        guard let nibView = nib.instantiate(withOwner: self, options: nil).first as? UIView else {
            return UIView()
        }
        backgroundColor = .clear
        nibView.frame = bounds
        nibView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        nibView.translatesAutoresizingMaskIntoConstraints = true
        addSubview(nibView)
        return nibView
    }
    
    func nibName() -> String {
        return String(describing: type(of: self))
    }
}
