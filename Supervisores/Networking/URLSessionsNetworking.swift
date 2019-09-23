//
//  URLSessionsNetworking.swift
//  Supervisores
//
//  Created by Sharepoint on 23/01/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import Foundation
import UIKit

class URLSessionsNetworking : NetworkingProtocol {
    
    
    func makeCall(urlEndPoint : String, httpMethod : HTTPMethod,
                  parameters: Any?, token: String?, completion: @escaping (Data?, Error?)->Void) {
        guard let url = URL(string: urlEndPoint) else {
            completion(nil, NetworkError.incorrectUrl)
            return
        }
        print("Url: \(urlEndPoint)")
        var urlRequest = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 1200.0)
        urlRequest.httpMethod = httpMethod.rawValue
        
        if let params = parameters as? [String: Any] {
            guard let dParameters = try? JSONSerialization.data( withJSONObject: params, options: []) else {
                completion(nil, NetworkError.parametersSerialization)
                return
            }
            do{
                //here dataResponse received from a network request
                let jsonResponse = try JSONSerialization.jsonObject(with:
                    dParameters, options: [])
                let decoded = String(data: dParameters, encoding: .utf8)!
                print(decoded)//Response result
            } catch let parsingError {
                
                print("Error", parsingError.localizedDescription)
            }
            urlRequest.httpBody = dParameters
        }
        if let arrayParams = parameters as? [[String: Any]] {
            guard let dParameters = try? JSONSerialization.data( withJSONObject: arrayParams, options: []) else {
                completion(nil, NetworkError.parametersSerialization)
                return
            }
            do{
                //here dataResponse received from a network request
                let jsonResponse = try JSONSerialization.jsonObject(with:
                    dParameters, options: [])//Response result
               
            } catch let parsingError {
                
                print("Error", parsingError.localizedDescription)
            }
            urlRequest.httpBody = dParameters
        }
        if let token = token {
            urlRequest.addValue(token, forHTTPHeaderField: "Authorization")
        }
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let urlSession = URLSession(configuration: .default)
        
        let task = urlSession.dataTask(with: urlRequest) {
            (data, response, error) -> Void in
            DispatchQueue.main.async {
              
            guard let httpResponse = response as? HTTPURLResponse  else {
                completion(nil, NetworkError.unknownError)
                return
            }
                
                do{
                    //here dataResponse received from a network request
    //let jsonResponse = try JSONSerialization.jsonObject(with:
      //  data!, options: [])
            //  print(jsonResponse) //Response result
                } catch let parsingError {

                    print("Error", parsingError.localizedDescription)
                }
            //print("RESPONSE Code ==>> \(httpResponse.statusCode)")
            if !(200 ... 299).contains(httpResponse.statusCode) {
               
                completion(nil, NetworkError.httpResponse)
                return
            }
            guard error == nil else {
                completion(nil, error)
                return
            }
           
            completion(data, nil)
             }
        }
        task.resume()
    }
    
    /*func uploadImage(images: [UIImage], question: Int, completion: @escaping (Data?, Error?)->Void) {
        let boundary = UUID().uuidString
        let fieldName = "supervision"
        let fieldValue = "\(Int.random(in: 0..<10))\(question)"
        let fieldName2 = "respuesta"
        let fieldValue2 = "\(question)"
        let fieldName3 = ""
        let fieldValue3 = ""
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        var urlRequest = URLRequest(url: URL(string: "http://200.34.206.100:8443/SupervisionDmz/dmz/v1/UploadFile/photo")!)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        var data = Data()
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"\(fieldName)\"\r\n\r\n".data(using: .utf8)!)
        data.append("\(fieldValue)".data(using: .utf8)!)
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"\(fieldName2)\"\r\n\r\n".data(using: .utf8)!)
        data.append("\(fieldValue2)".data(using: .utf8)!)
        
        for (index, image) in images.enumerated() {
            let filename = "Evidencia-\(question)-\(index).jpeg"
            data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
            data.append("Content-Disposition: form-data; name=\"fileToUpload\"; filename=\"\(filename)\"\r\n".data(using: .utf8)!)
            data.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
            data.append(image.jpegData(compressionQuality: 0.5)!)
        }
        
        data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
        
        session.uploadTask(with: urlRequest, from: data, completionHandler: { responseData, response, error in
            if(error != nil) {
                print("\(error!.localizedDescription)")
                completion(nil, error)
            }
            guard let responseData = responseData else {
                print("no response data")
                completion(nil, NetworkError.unknownError)
                return
            }
            if let responseString = String(data: responseData, encoding: .utf8) {
                completion(responseData, nil)
                print("uploaded to: \(responseString)")
            }
        }).resume()
    }*/
    func uploadImage(images: [UIImage], clave: Int, date: String, tipo: String, completion: @escaping (Data?, Error?) -> Void) {
        let boundary = UUID().uuidString
        let fieldName = "clave"
        let fieldValue = clave
        let fieldName2 = "tipo"
        let fieldValue2 = tipo
        let fieldName3 = "nombre"
        let fieldValue3 = date
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        print("http://200.34.206.100:8443/SupervisionDmz/dmz/v1/UploadFile/photo")
        var urlRequest = URLRequest(url: URL(string: "http://200.34.206.100:8443/SupervisionDmz/dmz/v1/UploadFile/photo")!)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        var data = Data()
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"\(fieldName)\"\r\n\r\n".data(using: .utf8)!)
        data.append("\(fieldValue)".data(using: .utf8)!)
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"\(fieldName2)\"\r\n\r\n".data(using: .utf8)!)
        data.append("\(fieldValue2)".data(using: .utf8)!)
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"\(fieldName3)\"\r\n\r\n".data(using: .utf8)!)
        data.append("\(fieldValue3)".data(using: .utf8)!)
        
        for (index, image) in images.enumerated() {
            let filename = "\(fieldValue3)"
            data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
            data.append("Content-Disposition: form-data; name=\"fileToUpload\"; filename=\"\(filename)\"\r\n".data(using: .utf8)!)
            data.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
            data.append(image.jpegData(compressionQuality: 0.3)!)
        }
        
        data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
        
        session.uploadTask(with: urlRequest, from: data, completionHandler: { responseData, response, error in
            guard let httpResponse = response as? HTTPURLResponse  else {
                completion(nil, NetworkError.unknownError)
                return
            }
            
            do{
                
            } catch let parsingError {
                
                print("Error", parsingError.localizedDescription)
            }
            print("RESPONSE ==>> \(httpResponse)")
            if(error != nil) {
                print("\(error!.localizedDescription)")
                completion(nil, error)
            }
            guard let responseData = responseData else {
                print("no response data")
                completion(nil, NetworkError.unknownError)
                return
            }
            if let responseString = String(data: responseData, encoding: .utf8) {
                
                completion(responseData, nil)
                //print("uploaded to: \(responseString)")
            }
        }).resume()
    }
    
}
