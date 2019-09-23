//
//  Privileges.swift
//  Supervisores
//
//  Created by Sharepoint on 7/19/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import Foundation
class Privileges {
    static var shared: Privileges = Privileges()
    var privileges: [PrivilegeItem] = []
    var privilegesProfile: [PrivilegeProfileItem] = []
    func getPrivileges(id: Int){
        NetworkingServices.shared.getPrivileges(id: id){  [unowned self] in
            
            guard let dataResponse = $0,
                $1 == nil else {
                    print($1?.localizedDescription ?? "Response Error")
                    
                    return }
            do{
                //here dataResponse received from a network request
                let jsonResponse = try JSONSerialization.jsonObject(with:
                    dataResponse, options: [])
               // print(jsonResponse) //Response result
            } catch let parsingError {
                
                print("Error", parsingError)
            }
            do{
                if id == 1 {
                    self.privileges =  try JSONDecoder().decode([PrivilegeItem].self, from: dataResponse)
                    self.getPrivileges(id: 2)
                }else{
                    let items = try JSONDecoder().decode([PrivilegeProfileItem].self, from: dataResponse)
                    self.privilegesProfile = self.getPrivilagesFromProfile(items: items)
                   // User.currentProfile = .franchisee
                }
                
                
            }
            catch let error{
                
                print("ErrorDescription\(error.localizedDescription)")
            }
        }
    }
    func getPrivilagesFromProfile(items: [PrivilegeProfileItem]) -> [PrivilegeProfileItem] {
        var profiles: [PrivilegeProfileItem] = []
        for i in 0 ..< items.count{
            if  User.currentProfile.rawValue == items[i].PerfilId!{
                profiles.append(items[i])
            }
        }
        return profiles
    }
}
