//
//  DetailIndicatorView.swift
//  Supervisores
//
//  Created by Sharepoint on 7/10/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import UIKit
class DetailIndicatorView: UIView {
    @IBOutlet weak var contentViewGraph: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lineFranquicia: UIView!
    @IBOutlet weak var lineSucursal: UIView!
    @IBOutlet weak var lineTotal: UIView!
    @IBOutlet weak var lblFranquicia: UILabel!
    @IBOutlet weak var lblSucursal: UILabel!
    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var lblNext: UILabel!
    @IBOutlet weak var lblCurrent: UILabel!
    @IBOutlet weak var lblLast: UILabel!
    @IBOutlet weak var lblProyeccion: UILabel!
    @IBOutlet weak var btnMoney: UIButton!
    @IBOutlet weak var btnPercentage: UIButton!
    @IBOutlet weak var tbnF: UIButton!
    @IBOutlet weak var tbnS: UIButton!
    @IBOutlet weak var tbnT: UIButton!
    @IBOutlet weak var graphView: GraphView!
    @IBOutlet weak var headerView: UIView!
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(handleRefresh(_:)),
                                 for: UIControl.Event.valueChanged)
        refreshControl.tintColor = UIColor.blue
        return refreshControl
    }()
    var dataSource: DataSourceDetailIndicator! {
        didSet{
            tableView.dataSource = dataSource
        }
    }
    var itemAction: ((typePharmacy) -> Void)?
    var formatterAction: ((String) -> Void)?
    override func awakeFromNib() {
        tableView.register(TableViewCellIndicator.self, forCellReuseIdentifier: TableViewCellIndicator.reuseIdentifier)
        tableView.register(UINib(nibName: "TableViewCellIndicator", bundle: nil), forCellReuseIdentifier: TableViewCellIndicator.reuseIdentifier)
        tableView.delegate = self
    ConfigureBorderView()
        //lblProyeccion.text = Utils.stringFromDateNow()
        lblProyeccion.text = "Proyección al cierre 11 de septiembre 2019"
        
    }
    
}
extension DetailIndicatorView: viewInputDetail{
    func display(from: fromBuild) {
       configureHeader(from: from)
    }
    
    
    func display(_ items: IndicatorDetail, from: fromBuild) {
        dataSource.items = items.indicatorsTable
        //print("countIndicators: \(items.indicatorsTable.count)")
        dataSource.itemStyle = items.indicatorStyle
        graphView.setDsiplay(items: items.indicatorsGraph, time: items.mounths)
        configViewButton(firstColor: #colorLiteral(red: 0.02701364437, green: 0.5163402289, blue: 1, alpha: 1), secondColor: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
        configureLabelGraph(symbol: "%", items: items.indicatorsGraph, time: items.mounths)
        configureHeader(from: from)
        tableView.reloadData()
        setBlockHeader()
        
    }
    
    func display(_ items: [IndicatorItem], time: [String], symbol: String) {
        setBlockHeader()
        if symbol == "%"{
            configViewButton(firstColor: #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1), secondColor:#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
            configureLabelGraph(symbol: "%", items: items, time: time)
        }
        else{
            configViewButton(firstColor: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), secondColor:#colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1))
            configureLabelGraph(symbol: "$", items: items, time: time)
        }
    }
}
