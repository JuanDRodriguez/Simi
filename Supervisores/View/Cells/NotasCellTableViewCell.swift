//
//  NotasCellTableViewCell.swift
//  Supervisores
//
//  Created by Sharepoint on 8/26/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import UIKit

class NotasCellTableViewCell: UITableViewCell {
    static let reuseIdentifier: String = String(describing: self)
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDetail: UILabel!
    var nota: NotasItem!
    var delegate: NotaCellProtocol!
    static var nib: UINib {
        return UINib(nibName: String(describing: self), bundle: nil)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    func Display(_ item: NotasItem){
        self.nota = item
        lblTitle.text = item.title
        lblDetail.text = item.detail
    }
    @IBAction func actEdit(){
        delegate.openPopUp(item: self.nota)
    }
    @IBAction func actDelete(){
        delegate.actDelete(item: self.nota)
    }

}
protocol NotaCellProtocol {
    func actEdit(item: NotasItem)
    func actDelete(item: NotasItem)
    func openPopUp(item: NotasItem)
}
