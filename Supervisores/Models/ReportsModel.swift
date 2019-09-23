//
//  ReportsModel.swift
//  Supervisores
//
//  Created by Sharepoint on 8/16/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import Foundation
class ReportsModel: ReportsModelInput{
    var out: ReportModelOutput!
    func load() {
        NetworkingServices.shared.getModules(){
            [unowned self] in
            if let error = $1 {
                self.out.modelDidLoadFail()
                return
            }
            guard let data = $0 else {
                let error = NSError(domain:"", code:400, userInfo:[ NSLocalizedDescriptionKey: "No hay información"])
                self.out.modelDidLoadFail()
                return
            }
            do{
                //here dataResponse received from a network request
                let jsonResponse = try JSONSerialization.jsonObject(with:
                    data, options: [])
               // print("Modules: \(jsonResponse)") //Response result
            } catch let parsingError {
                self.out.modelDidLoadFail()
                print("Error", parsingError)
            }
            do {
                let decoder = JSONDecoder()
                let modules = try decoder.decode([Module].self, from: data)
                if PastSupervisionViewModel.shared.lastSupervisions.count > 0{
                    self.getReports(modules: modules)
                }
                else{
                   self.out.modelDidLoadFail()
                }
            }
            catch {
                self.out.modelDidLoadFail()
            }
        }
    }
    func getReports(modules: [Module]){
        let idUnit = PastSupervisionViewModel.shared.lastSupervisions[0]
        NetworkingServices.shared.getSupervision(supervisionId: idUnit.supervisionId){
        [unowned self] in
        if let error = $1 {
            self.out.modelDidLoadFail()
            return
        }
        guard let data = $0 else {
            let error = NSError(domain:"", code:400, userInfo:[ NSLocalizedDescriptionKey: "No hay información"])
            self.out.modelDidLoadFail()
            return
        }
        do{
            //here dataResponse received from a network request
            let jsonResponse = try JSONSerialization.jsonObject(with:
                data, options: [])
            print("ResponseGetSupervision: \(jsonResponse)") //Response result
        } catch let parsingError {
            self.out.modelDidLoadFail()
            print("Error", parsingError)
        }
        do {
            let decoder = JSONDecoder()
            let supervisionResume = try decoder.decode(ResumeSupervision.self, from: data)
            self.out.modelDidLoad(Operation.getReports(item: supervisionResume, modules: modules))
        }
        catch {
            self.out.modelDidLoadFail()
        }
        }
        
        }
    func sendLoad(param: [[String : Int]]) {
        NetworkingServices.shared.postReports(param:param){
          [unowned self] in
            if let error = $1 {
                self.out.modelDidLoadFail()
                return
            }
            guard let data = $0 else {
                let error = NSError(domain:"", code:400, userInfo:[ NSLocalizedDescriptionKey: "No hay información"])
                self.out.modelDidLoadFail()
                return
            }
            do{
                //here dataResponse received from a network request
                let jsonResponse = try JSONSerialization.jsonObject(with:
                    data, options: [])
                // print("Modules: \(jsonResponse)") //Response result
            } catch let parsingError {
                self.out.modelDidLoadFail()
                print("Error", parsingError)
            }
            do {
                self.out.modelDidLoadFinish()
               
            }
            catch {
                self.out.modelDidLoadFail()
            }
        }
    }
}
