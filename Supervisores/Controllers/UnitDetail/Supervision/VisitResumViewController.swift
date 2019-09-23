//
//  VisitResumViewController.swift
//  Supervisores
//
//  Created by Sharepoint on 8/8/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import UIKit

class VisitResumViewController: UIViewController {
    @IBOutlet weak var viewNav: UIView!
    @IBOutlet weak var lblNumeroUnidad: UILabel!
    @IBOutlet weak var lblNombreUnidad: UILabel!
    @IBOutlet weak var lblDireccion: UILabel!
    @IBOutlet weak var lblfecha: UILabel!
    @IBOutlet weak var lblSupervisor: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblEtiquetaSuper: UILabel!
    @IBOutlet weak var lblRealizo: UILabel!
    @IBOutlet weak var lblComment: UILabel!
    @IBOutlet weak var photo1: UIImageView!
    @IBOutlet weak var photo2: UIImageView!
    @IBOutlet weak var photo3: UIImageView!
    @IBOutlet weak var photo4: UIImageView!
    @IBOutlet weak var photo5: UIImageView!
    @IBOutlet weak var lblFotos: UILabel!
    var visit: VisistItem!
    var unit: Unit?
    override func viewDidLoad() {
        super.viewDidLoad()
        CommonInit.navBarGenericBack(vc: self, navigationBar: self.viewNav, title: "Visita")
        tableView.register(UINib(nibName: "VisitMotivosCell", bundle: nil), forCellReuseIdentifier: VisitMotivosCell.reuseIdentifier)
        tableView.dataSource = self
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.photo1.isHidden = true
        self.photo2.isHidden = true
        self.photo3.isHidden = true
        self.photo4.isHidden = true
        self.photo5.isHidden = true
         let arrImgs:[UIImageView] = [self.photo1, self.photo2, self.photo3, self.photo4, self.photo5]
       // visit.
        let date = Utils.dateFromService(stringDate: visit.FechaFin!)
        lblfecha.text = Utils.stringFromDate(date: date)
        lblDireccion.text = "CALLE \(unit!.street) NUMERO \(unit!.number) COLONIA \(unit!.colony) MUNICIPIO \(unit!.municipio) CP \(unit!.cp)"
        lblSupervisor.text = "\(Operation.clave)"
       lblRealizo.text = "\(visit.usuario.CuentaDominio), \(visit.usuario.NombreCompleto)" 
        lblNombreUnidad.text = unit?.name
        lblNumeroUnidad.text = unit?.key
        lblComment.text = visit.Comentario
        if visit.fotografias!.count > 0 {
            lblFotos.isHidden = false
            setPhotos(photos: visit.fotografias!, images: arrImgs)
        }else{
            lblFotos.isHidden = true
        }
    }
    func setData(visit: VisistItem, idUnit: Int){
        self.visit = visit
        
        let unit = MyUnitsViewModel.shared.arrayUnits.filter({
            $0.id == visit.UnidadNegocioId
        })
        self.unit = unit[0]
    }
    func setPhotos(photos: [Fotografias],images: [UIImageView]){
        for i in 0 ..< photos.count {
            images[i].isHidden = false
            images[i].load(url: URL(string: photos[i].Url)!)
        }
    }
    
}
extension VisitResumViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return visit.motivos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: VisitMotivosCell.reuseIdentifier, for: indexPath) as! VisitMotivosCell
        cell.display(motivo: visit.motivos[indexPath.row].Motivo,index: indexPath.row)
        return cell
    }
    
    
}
