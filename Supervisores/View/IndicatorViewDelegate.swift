//
//  IndicatorViewDelegate.swift
//  Supervisores
//
//  Created by Sharepoint on 7/9/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//
import UIKit
extension IndicatorView: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        searchBar.resignFirstResponder()
        if collectionView == self.collectionviewAll   {
            if dataSource.itemsSearch.count > 0 {
                itemActionShowDetail?(dataSource.itemsSearch[indexPath.item].LocacionId!,dataSource.itemsSearch[indexPath.item].Nombre!)
                dataSource.itemsSearch = []
            }else{
                if dataSource.itemsContacto.count > 0{
                    itemActionShowDetailContacto?(dataSource.itemsContacto[indexPath.item].CuentaDominio!,"\(dataSource.itemsContacto[indexPath.row].Nombre)")
                }else{ itemActionShowDetail?(dataSource.items[indexPath.item].LocacionId!,dataSource.items[indexPath.item].Nombre!)
                }
            }
            //print("IDForDetailIndicator: \(dataSource.items[indexPath.item].LocacionId!)")
            dataSource.search = false
            collectionviewAll.reloadData()
        }
        else if collectionView == self.collectionViewMain{
            itemActionShowDetail?(1,"Negocio Total")
        }else if collectionView == self.collectionViewUnit{
            User.typeUnit = dataSource.itemsUnits[indexPath.row].type
            if dataSource.itemsUnits[indexPath.item].status == 4 || dataSource.itemsUnits[indexPath.item].status == 3{
                let alertController = UIAlertController(title: "Se encuentra \(dataSource.itemsUnits[indexPath.item].statusName)", message: "No se puede mostrar indicadores", preferredStyle: .alert)
                let actionOk = UIAlertAction(title: "Aceptar", style: .default, handler: nil)
                alertController.addAction(actionOk)
                itemActionOption?(alertController)
            }else{
                
                itemActionShowDetailUnit?(dataSource.itemsUnits[indexPath.row].id,"\(dataSource.itemsUnits[indexPath.row].key) \(dataSource.itemsUnits[indexPath.row].name)")
                
            }
            
        }
        else {
            self.itemAction?(dataSource.states[indexPath.item].id, typeIndicators)
            self.dataSource.index = indexPath.item
            self.collectionViewSecond.reloadData()
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var w = 0.0
        var h = 0.0
        if  collectionView == collectionViewMain {
            w = 320.0
            h = 380.0
        }
        else if  collectionView == collectionviewAll {
            w = 350.0
            h = 150.0
        }else if  collectionView == collectionViewUnit{
            w = 350.0
            h = 90.0
        }
            else{
            w = 130.0
            h = 40.0
        }
        
        return CGSize.init(width: w, height: h)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if collectionView == collectionViewSecond{
            return CGSize.init(width: 5, height: 5)
        }else{
        return CGSize.init(width: 50, height: 50)
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize.init(width: 30, height: 30)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return CGFloat(20.0)
    }
}
extension IndicatorView: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchBar.resignFirstResponder()
        
    itemActionShowIndicadorUnit?(dataSource.itemsTable[indexPath.row])
        
    }
}

extension IndicatorView {
    func registerNib() {
        collectionviewAll.register(UINib(nibName: "CollectionViewCellIndicator", bundle: nil), forCellWithReuseIdentifier: CollectionViewCellIndicator.reuseIdentifier)
        collectionViewMain.register(UINib(nibName: "CollectionViewCellIndicatorTotal", bundle: nil), forCellWithReuseIdentifier: CollectionViewCellIndicatorTotal.reuseIdentifier)
        collectionViewSecond.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: CollectionViewCell.reuseIdentifier)
        collectionViewUnit.register(UINib(nibName: "CollectionViewCellUnit", bundle: nil), forCellWithReuseIdentifier: CollectionViewCellUnit.reuseIdentifier)
        tableView.register(UINib(nibName: "TableViewCellUnit", bundle: nil), forCellReuseIdentifier: TableViewCellUnit.reuseIdentifier)
        
    }
    func configLayout(_ width: Double,height: Double, orientation: UICollectionView.ScrollDirection) -> UICollectionViewFlowLayout{
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = CGSize(width: width , height: height)
        layout.scrollDirection = .horizontal
        
        return layout
    }
    func configView(type: Indicators){
        lblGroupBy.text = Operation.getIndicatorsString(type: type)
        if type == Indicators.ciudad || type == Indicators.municipio{
            
        }else{
            
        }
        
       btnLevel.isEnabled = true
        self.searchBar.isHidden = true
        if type == Indicators.negocioTotal || type == Indicators.direccion{
            btnSearch.isHidden = true
        }else{
            btnSearch.isHidden = false
        }
        if type == Indicators.negocioTotal{
            self.contentCollectionsMain.isHidden = false
            self.collectionViewMain.isHidden = false
            self.collectionviewAll.isHidden = true
            self.collectionViewUnit.isHidden = true
            self.contentTableView.isHidden = true
            self.collectionViewMain.reloadData()
            
        }else if type == Indicators.unit{
            
            self.collectionViewMain.isHidden = true
            self.collectionviewAll.isHidden = true
            self.collectionViewUnit.isHidden = false
            self.contentTableView.isHidden = true
            self.collectionViewUnit.reloadData()
        }
        else{
             self.contentCollectionsMain.isHidden = false
            self.collectionViewMain.isHidden = true
            self.collectionviewAll.isHidden = false
             self.collectionViewUnit.isHidden = true
            self.contentTableView.isHidden = true
            self.collectionviewAll.reloadData()
        }
        if type == Indicators.ciudad || type == Indicators.municipio || type == Indicators.gerencia{
            
            if self.size == 1 {
                self.size = 0
                contentCollectionsMain.frame.size.height -= 49
            }
            contentCollectionsMain.frame.origin.y = 49
            contentCollectionsSecond.isHidden = false
        } else{
            contentCollectionsMain.frame.origin.y = 0
            contentCollectionsSecond.isHidden = true
            if self.size == 0  {
                size = 1
                contentCollectionsMain.frame.size.height += 49
            }
            
        }
        
        
    }
    @IBAction func actShowMenu(){
        self.searchBar.resignFirstResponder()
        btnLevel.isEnabled = false
        dataSource.search = false
        if  dataSource.items.count > 0{
        if let aux =  dataSource.items[0].LocacionId { itemActionShowMenu?(1,self,aux)
        }else
        {
            itemActionShowMenu?(1,self,1)
            }
            
        }else{
           itemActionShowMenu?(1,self,1)
        }
    }
    
    @IBAction func actSearch(){
        self.searchBar.resignFirstResponder()
        self.searchBar.isHidden = false
        self.searchBar.text = ""
        itemActionShowSearBar?(true)
        typeSearch = .Indicators
        self.btnFilter.isHidden = true
    }
    @IBAction func actFilter(){
        searchBar.resignFirstResponder()
        guard let pickerView = self.pickerView else { return }
        self.endEditing(true)
        self.addSubview(pickerView)
    }
    
}
extension IndicatorView: PickerSelectViewDelegate{
    func cancelOption() {
        guard let pickerView = self.pickerView else {
            return
        }
        pickerView.removeFromSuperview()
    }
    func selectOption(_ option: Int, value: String) {
        guard let filter = SearchUnitIndicator(rawValue: value) else {return}
        guard let pickerView = self.pickerView else { return }
        self.searchingFilter = filter
        pickerView.removeFromSuperview()
        
    }
    
    
}
extension IndicatorView: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if typeSearch == .unit{
            if searchText.count > 2{
                switch searchingFilter{
                case .bussinesName:
                    dataSource.itemsTable = UnitsMapViewModel.shared.arrayAllUnits.filter({$0.bussinesName.contains(searchText.uppercased()) && ($0.type == 1 || $0.type == 2)})
                    break
                case .contact:
                    dataSource.itemsTable = UnitsMapViewModel.shared.arrayAllUnits.filter({$0.contact.contains(searchText.uppercased()) && ($0.type == 1 || $0.type == 2)})
                    break
                case .key:
                    dataSource.itemsTable = UnitsMapViewModel.shared.arrayAllUnits.filter({$0.key.contains(searchText.uppercased()) && ($0.type == 1 || $0.type == 2)})
                    break
                case .name:
                    dataSource.itemsTable = UnitsMapViewModel.shared.arrayAllUnits.filter({$0.name.contains(searchText.uppercased()) && ($0.type == 1 || $0.type == 2)})
                    break
                }
            
            self.contentCollectionsMain.isHidden = true
            self.contentTableView.isHidden = false
            tableView.reloadData()
            }else{
                dataSource.itemsTable = []
                tableView.reloadData()
            }
        }else{
            if dataSource.itemsContacto.count > 0{
               dataSource.itemSearchContacto =  dataSource.itemsContacto.filter({$0.Nombre.lowercased().prefix(searchText.count) == searchText.lowercased()})
            }else{
              dataSource.itemsSearch =  dataSource.items.filter({$0.Nombre!.lowercased().prefix(searchText.count) == searchText.lowercased()})
            }
            
            
            dataSource.search = true
            collectionviewAll.reloadData()
        }       
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        if typeIndicators == .unit{
            
            self.contentCollectionsMain.isHidden = false
            self.contentTableView.isHidden = true
            
        }
        dataSource.search = false
        searchBar.text = ""
        itemActionShowSearBar?(false)
        self.searchBar.isHidden = false
        collectionviewAll.reloadData()
        searchBar.resignFirstResponder()
    }
  
}

