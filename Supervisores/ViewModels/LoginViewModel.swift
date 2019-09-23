//
//  LoginViewModel.swift
//  Supervisores
//
//  Created by Sharepoint on 5/9/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import Foundation

enum Profiles: Int {
    case directorStaff = 1
    case director = 2
    case manager = 3
    case supervisor = 4
    case general = 8
    case franchisee = 6
    case administrator = 7
    case NA = 0
}

protocol LoginVMProtocol {
    func loginOk()
    func loginError()
}

class LoginViewModel {
    static let shared = LoginViewModel()
    var listener: LoginVMProtocol?
    var loginInfo: UserInfo?
//    var arrayUnitsSearched: [UnitLite] = [] {
//        didSet {
//            self.arrayUnitsMaped.removeAll()
//            self.arrayUnitsMaped = self.arrayUnitsSearched.map({unitToDictionary(unit: $0)})
//            self.listener?.unitsSearched(units: self.arrayUnitsMaped)
//        }
//    }
    init() { }
    
    func setListener(listener: LoginVMProtocol?){
        self.listener = listener
    }
    
    func login(user: String, password: String) {
        NetworkingServices.shared.getToken(userName: user, password: password) {
            [unowned self] in
            
            
            
            if let error = $1 {
                self.listener?.loginError()
                print("ERROR pp===>>> \(error)")
            }
            guard let data = $0 else {
                self.listener?.loginError()
                return
            }
            do{
                //here dataResponse received from a network request
                let jsonResponse = try JSONSerialization.jsonObject(with:
                    data, options: [])
                print(jsonResponse) //Response result
            } catch let parsingError {
                
                print("Error", parsingError)
            }
            do {
                let decoder = JSONDecoder()
                self.loginInfo = try decoder.decode(UserInfo.self, from: data)
                if let token = self.loginInfo?.token?.accessToken {
                    Storage.shared.saveToken(token: token)                    
                }
                if let tokenType = self.loginInfo?.token?.tokenType {
                    Storage.shared.saveOption(option: tokenType, key: SimpleStorageKeys.tokenType.rawValue)
                }
                if let timeRemain = self.loginInfo?.token?.expiresIn {
                    let dateExp = Date().addingTimeInterval(TimeInterval(timeRemain / 1000))
                    Storage.shared.saveOption(option: dateExp, key: SimpleStorageKeys.tokenExpiration.rawValue)
                }
                if let userId = self.loginInfo?.user?.userId {
                    Storage.shared.saveOption(option: userId, key: SimpleStorageKeys.userID.rawValue)
                }
                if let name = self.loginInfo?.user?.name {
                    Storage.shared.saveOption(option: name, key: SimpleStorageKeys.name.rawValue)
                }
                if let lastName = self.loginInfo!.user?.lastName {
                    Storage.shared.saveOption(option: lastName, key: SimpleStorageKeys.lastName.rawValue)
                }
                if let middleName = self.loginInfo?.user?.middleName {
                    Storage.shared.saveOption(option: middleName, key: SimpleStorageKeys.middleName.rawValue)
                }
                print("DOMAIN")
                if let domainAccount = self.loginInfo?.user?.domainAccount {
                    Storage.shared.saveOption(option: domainAccount, key: SimpleStorageKeys.domainAccount.rawValue)
                }
                print("PASO")
//                if let email = loginInfo.user?.email {
//                    Storage.shared.saveOption(option: email, key: SimpleStorageKeys.email.rawValue)
//                }
                if let profileId = self.loginInfo?.user?.profileId {
                    Storage.shared.saveOption(option: profileId.rawValue, key: SimpleStorageKeys.profileId.rawValue)
                }
                if let profile = self.loginInfo?.user?.profile {
                    Storage.shared.saveOption(option: profile, key: SimpleStorageKeys.profile.rawValue)
                }
                //User.currentProfile = .general
                User.currentProfile = self.getCurrentProfile()
                self.setPrivileges(id: 1)
                GeneralCloseModel.shared.load()
               let profiles:(current: Int,last:Int) = Storage.shared.getProfile()
                if profiles.current == 0{
                    
                    Storage.shared.setProfile(currentProfile: User.currentProfile.rawValue, latProfile: 0)
                    
                }else{
                    if User.currentProfile != Profiles(rawValue: profiles.current) {
                        Storage.shared.setProfile(currentProfile: User.currentProfile.rawValue, latProfile: profiles.current)
                    }else{
                      Storage.shared.setProfile(currentProfile: User.currentProfile.rawValue, latProfile: 0)
                    }
                }
            } catch {
                self.listener?.loginError()
            }
        }
    }
    func setPrivileges(id: Int){
        NetworkingServices.shared.getPrivileges(id: id){
            [unowned self] in
            guard let dataResponse = $0,
                $1 == nil else {
                    print($1?.localizedDescription ?? "Response Error")
                    
                    return }
            do{
                //here dataResponse received from a network request
                let jsonResponse = try JSONSerialization.jsonObject(with:
                    dataResponse, options: [])
               
                //print(jsonResponse) //Response result
            } catch let parsingError {
                
                print("Error", parsingError)
            }
            do{
                if id == 1{
                     Privileges.shared.privileges = try JSONDecoder().decode([PrivilegeItem].self, from: dataResponse)
                    self.setPrivileges(id: 2)
                }else{
                    let items = try JSONDecoder().decode([PrivilegeProfileItem].self, from: dataResponse)
                   
                    MessageModel.shared.load()
                    
                   Privileges.shared.privilegesProfile = Privileges.shared.getPrivilagesFromProfile(items: items)
                    print("LLEGO AL LOGIN")
                    self.listener?.loginOk()
                }
               
               
                
            }
            catch{
                
                self.listener?.loginError()
            }
        }
    }
    func getCurrentProfile()->Profiles {
        if let profile = self.loginInfo?.user?.profileId {
            return profile
        }
        if let profileId = Storage.shared.getOption(key: SimpleStorageKeys.profileId.rawValue) as? Int {
            let profile = Profiles(rawValue: profileId) ?? .general
            return profile
        }
        return .general
    }
}
