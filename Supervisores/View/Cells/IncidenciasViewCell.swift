//
//  IncidenciasViewCell.swift
//  Supervisores
//
//  Created by Sharepoint on 8/15/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import UIKit

class IncidenciasViewCell: UITableViewCell {
    static var reuseIdentifier: String = "\(String(describing: self))"
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnStatus: UIButton!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblNivelIncumplimiento: UILabel!
    var motivos: [MotivosIncumplimiento] = []
    var size = 0
    var ids: [Int] = []
    var delegate: ProtocolMotivo!
    override func awakeFromNib() {
        super.awakeFromNib()
       tableView.register(UINib(nibName: "MotivoCell", bundle: nil), forCellReuseIdentifier: MotivoCell.reuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func display(motivos: [MotivosIncumplimiento],ids:[Int]){
        self.motivos = motivos
        self.ids = ids
        self .size = motivos.count
       self.lblStatus.text = motivos[0].status!
        //self.lblStatus.text = ":)"
        self.lblNivelIncumplimiento.text = motivos[0].nivelIncumplimiento!
        self.lblDate.text = self.motivos[0].fechaCompromiso!
        self.tableView.reloadData()
    }
    @IBAction func didSelectedButtonStatus(){
        delegate.setMotivo(IdMotivo: (self.motivos.map({($0.id!)}),self.motivos.map({$0.idRespuesta!})),idMotivo: ids)
    }
}
extension IncidenciasViewCell: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return motivos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MotivoCell.reuseIdentifier, for: indexPath) as! MotivoCell
        if motivos.count > 0 {
            cell.display(motivo: motivos[indexPath.row])
            
        }
        return  cell
        
    }
    
    
}
extension IncidenciasViewCell: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(60)
    }
}
protocol ProtocolMotivo {
    func setMotivo(IdMotivo: ([Int],[Int]), idMotivo: [Int])
}
