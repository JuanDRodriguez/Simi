//
//  IncumplimientosCell.swift
//  Supervisores
//
//  Created by Sharepoint on 8/15/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import UIKit

class IncumplimientosCell: UICollectionViewCell, ProtocolMotivo {
    static var reuseIdentifier: String = "\(String(describing: self))"
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblModulo: UILabel!
    @IBOutlet weak var lblTema: UILabel!
    @IBOutlet weak var lblFechaInicio: UILabel!
    @IBOutlet weak var lblFechaFin: UILabel!
    @IBOutlet weak var lblPregunta: UILabel!
    
    var item: Preguntas!
    var items: Modulos!
    var id: Int!
    var delegate: ProtocolPregunta!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.masksToBounds = true
        self.layer.cornerRadius = CGFloat(8.0)
        self.clipsToBounds = true
        tableView.register(UINib(nibName: "IncidenciasViewCell", bundle: nil), forCellReuseIdentifier: IncidenciasViewCell.reuseIdentifier)
        
        tableView.register(HeaderCell.nib, forHeaderFooterViewReuseIdentifier: HeaderCell.reuseIdentifier)
    }
    func display(item: Modulos){
        self.items = item
        lblModulo.text = item.nombre
        
        lblFechaInicio.text = item.fechaInicio
        lblFechaFin.text = item.fechaFin
        
        self.tableView.reloadData()
    }
    func display(item: Preguntas, id: Int)  {
        self.id = id
        self.item = item
        lblPregunta.text = item.name!
        lblTema.text = item.tema
    }
    func setMotivo(IdMotivo:([Int],[Int]), idMotivo: [Int]) {
        delegate.setPregunta(idMotivo: IdMotivo,ids: (id,idMotivo))
    }

}
extension IncumplimientosCell: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return item.motivos!.count
    }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: IncidenciasViewCell.reuseIdentifier, for: indexPath) as! IncidenciasViewCell
        if item.nivelIncumplimiento! {
            cell.display(motivos: [item.motivos![indexPath.row]],ids: [indexPath.row])
        }else{
            cell.display(motivos: item.motivos!, ids: getIdsFromMotivos())
        }
        
        cell.delegate = self
        
        return cell
    }
    func getIdsFromMotivos() -> [Int]{
        var items: [Int] = []
        for i in 0 ..< item.motivos!.count{
            items.append(i)
        }
        return items
    }
}
extension IncumplimientosCell: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(60)
    }
   
    
}
protocol ProtocolPregunta {
    func setPregunta(idMotivo: ([Int],[Int]),ids: (Int,[Int]))
}
