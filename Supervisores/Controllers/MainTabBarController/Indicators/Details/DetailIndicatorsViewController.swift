//
//  DetailIndicatorsViewController.swift
//  Supervisores
//
//  Created by Sharepoint on 7/9/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import UIKit
enum typePharmacy {
    case all
    case franchise
    case branch
}
class DetailIndicatorsViewController: UIViewController {
    
    @IBOutlet weak var navBar: UIView!
    var type: typePharmacy!
    var from: fromBuild!
    var model: DetailModelInput!
    var items: IndicatorDetail!
    var lottieView : LottieViewController?
    var titleH = ""
    var symbol: String = "%"
   lazy var contentView : viewInputDetail = { return view as! viewInputDetail}()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lottieView = CommonInit.lottieViewInit(vc: self)
        type = .all
        contentView.dataSource = DataSourceDetailIndicator()
        CommonInit.navBArIndicators(vc: self, navigationBar: self.navBar, title: titleH)
        contentView.display(from: from)
       self.lottieView?.animationLoading()
        contentView.formatterAction = {
            self.symbol = $0
            self.model.loadChangeSymbol(type: self.type)
        }
        contentView.itemAction = {
            self.type = $0
            self.model.loadTypePharmacy(type: $0)
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if from == fromBuild.unitIndicators{
            self.lottieView?.animationFinishCorrect()
        }
    }
    
   

}
extension DetailIndicatorsViewController: DetailModelOutput{
    func modelDidLoad(_ items: [IndicatorItem], mounts: [String]) {
        contentView.display(items, time: mounts, symbol: self.symbol)
    }
    
    func modelDidLoad(_ items: IndicatorDetail) {
        contentView.display(items,from: self.from)
        self.lottieView?.animationFinishCorrect()
    }
    
    func modelDidFail() {
    self.lottieView?.animationFinishError()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.1, execute: {
           // self.dismiss(animated: true, completion: nil)
        })
        
    }
}
