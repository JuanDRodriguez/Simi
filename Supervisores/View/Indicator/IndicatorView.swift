//
//  IndicatorView.swift
//  Supervisores
//
//  Created by Sharepoint on 7/8/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import UIKit
enum typeSearch{
    case unit
    case Indicators
}
class IndicatorView: UIView {
   @IBOutlet weak var collectionViewMain: UICollectionView!
    @IBOutlet weak var collectionViewSecond: UICollectionView!
    @IBOutlet weak  var collectionviewAll:  UICollectionView!
    @IBOutlet weak var collectionViewUnit: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var contentCollections: UIView!
    @IBOutlet weak var contentCollectionsMain: UIView!
    @IBOutlet weak var contentCollectionsSecond: UIView!
    @IBOutlet weak var contentTableView: UIView!
    @IBOutlet weak var btnLevel: UIButton!
    @IBOutlet weak var btnSearch: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var lblGroupBy: UILabel!
    @IBOutlet weak var btnFilter: UIButton!
    var pickerView: PickerSelectView? = nil
    var searchingFilter : SearchUnitIndicator = .name
    var itemAction: ((Int,Indicators) -> Void)?
    var itemActionOption: ((UIAlertController) -> Void)?
    var itemActionShowDetail: ((Int,String) -> Void)?
    var itemActionShowMenu: ((Int,IndicatorView,Int) -> Void)?
    var itemActionShowSearBar: ((Bool) -> Void )?
    var itemActionShowIndicadorUnit: ((UnitLite) -> Void)?
    var itemActionCancel: (() -> Void)?
    var itemActionShowDetailUnit: ((Int,String) -> Void)?
    var itemActionShowDetailContacto:((String,String) -> Void)?
    var dataSource: IndicatorCollectionViewDataSource!{
        didSet{
            dataSource.collectionViewIndicator = collectionViewMain
            dataSource.collectionViewIndicator2 = collectionviewAll
            dataSource.collectionViewIndicator3 = collectionViewUnit
            collectionViewMain.dataSource = dataSource
            collectionViewSecond.dataSource = dataSource
            collectionviewAll.dataSource = dataSource
            collectionViewUnit.dataSource = dataSource
            tableView.dataSource = dataSource
        }
    }
    var typeIndicators = Indicators.negocioTotal
    var typeSearch: typeSearch = .Indicators
    var size: Double = 0
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentCollectionsSecond.isHidden = true
        self.collectionViewSecond.delegate = self
        self.collectionViewMain.delegate = self
        self.collectionviewAll.delegate = self
        self.collectionViewUnit.delegate = self
        self.tableView.delegate = self 
        self.registerNib()
       searchBar.isHidden = true
        searchBar.delegate = self
       configView(type: typeIndicators)
        if self.pickerView == nil {
            let stringCases: [String] = SearchUnitIndicator.allCases.map({$0.rawValue})
            self.pickerView = PickerSelectView(dataPicker: stringCases, frame: self.frame)
            self.pickerView?.lblTitle.text = "Buscar por:"
            self.pickerView!.delegate = self
        }
    }
    
}
extension IndicatorView: viewInput{
    func display(_ items: [ContactoItem], typeIndicators: Indicators) {
            dataSource.items = []
            dataSource.itemsSearch = []
            dataSource.itemsContacto = items
            dataSource.total = typeIndicators
            self.configView(type: typeIndicators)
            self.typeIndicators = typeIndicators
            
            self.searchBar.text = ""
    }
    
    func reloadCollectionView() {
        collectionViewMain.reloadData()
    }
    
    func displaySeachUnit(_ items: [Unit],typeIndicators:Indicators) {
         self.searchBar.isHidden = false
        self.typeIndicators = typeIndicators
        typeSearch = .unit
        dataSource.itemsUnits = items
        dataSource.itemsContacto = []
        btnLevel.isEnabled = true
        self.searchBar.text = ""
        
    }
    
    func displey(_ items: [Unit], typeIndicators: Indicators) {
        dataSource.itemsSearch = []
        dataSource.itemsUnits = []
        dataSource.itemsContacto = []
        dataSource.total = typeIndicators
        dataSource.itemsUnits = items
        self.configView(type: typeIndicators)
        self.typeIndicators = typeIndicators
        contentCollectionsMain.isHidden = false
        self.btnSearch.isHidden = true
        self.searchBar.text = ""
    }

    func display(_ items: [IndicatorResumItem], typeIndicators: Indicators) {
        dataSource.items = items
        dataSource.itemsSearch = []
        dataSource.itemsContacto = []
        dataSource.total = typeIndicators
        self.configView(type: typeIndicators)
        self.typeIndicators = typeIndicators
        
        self.searchBar.text = ""
    }
    
    func displey(_ items: [States]) {
        dataSource.states = items
        dataSource.itemsContacto = []
        self.collectionViewSecond.reloadData()
        self.searchBar.text = ""
    }
    func closeMenuLevel() {
        self.btnLevel.isEnabled = true
    }
    func showFilter() {
        self.btnFilter.isHidden = false
    }
}
