//
//  NetworkingClient.swift
//  Mavsim
//
//  Created by mac on 23/11/22.
//

import Foundation
import Alamofire
import UIKit

class NetworkingClient {
    final var baseUrl: String = "http://api.mavsim.com"
    
    static let standart = NetworkingClient()
    private init() {}
    
    typealias WebServiceResponseAuthWithLogin = (String?, Error?) -> Void
    typealias WebServiceResponseGetUserDriver = (User?, Error?, Bool?) -> Void
    typealias WebServiceResponseGetCargoStatus = ([Status]?, Error?, Bool?) -> Void
    typealias WebServiceResponseGetNewOrders = ([Order]?, Error?) -> Void
    typealias WebServiceResponsePostOrderAccept = (Bool?, Error?) -> Void
    typealias WebServiceResponseGetMyOrders = ([Order]?, Error?) -> Void
    typealias WebServiceResponseGetComplatedOrders = ([Order]?, Error?) -> Void
    typealias WebServiceResponseDelOrderDelete = (Bool?, Error?) -> Void
    typealias WebServiceResponsePutDriverLocation = (Bool?, Error?) -> Void
    
    typealias WebServiceResponsePostFile = (Bool?, Error?) -> Void
    /*private let session: Session = {
        let manager = ServerTrustManager(evaluators: ["https://api.mavsim.com": DisabledTrustEvaluator()])
        let configuration = URLSessionConfiguration.af.default
        
        return Session(configuration: configuration, serverTrustManager: manager)
    }()*/
    
    // private let networkClient = NetworkingClient()
    
    func authWithLogin(login: String , password: String, completion: @escaping WebServiceResponseAuthWithLogin){
        
        guard let url = URL(string: baseUrl + "/api/login") else {
            return
        }
        
        let headers: HTTPHeaders = ["Content-Type": "application/json"]
        let parameters: [String: String] = [
            "Username": login,
            "Password": password
        ]
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers ).validate(statusCode: 200..<500).responseString { response in

            if response.response?.statusCode == 200 {
                completion(response.value, nil)
            } else if response.response?.statusCode == 400 || response.response?.statusCode == 404 {
                IncLoadData.inCorrectLogOrPass = true
                completion(nil, NSError(domain: "bad request", code: response.response?.statusCode ?? 400))
            }
            else if let error = response.error {
                completion(nil, error)
            } else {
                completion(nil, NSError(domain: "bad request", code: response.response?.statusCode ?? 400))
            }
            
        }
    }
    
    func getUserDriver(token: String, completion: @escaping WebServiceResponseGetUserDriver) {
        guard let url = URL(string: baseUrl + "/api/driver") else {
            return
        }
        
        let headers: HTTPHeaders = [
            .authorization(bearerToken: token)
        ]
        
        AF.request(url, method: .get, headers: headers ).validate(statusCode: 200..<500).responseDecodable(of: User.self) { response in
            if response.response?.statusCode == 401 {
                completion(nil, nil, true)
            } else {
                switch(response.result) {
                case .success(let value):
                    completion(value, nil, false)
                case .failure(let error):
                    completion(nil, error, false)
                }
            }
            
        }
    }
    
    func getCargoStatus(token: String, completion: @escaping WebServiceResponseGetCargoStatus) {
        guard let url = URL(string: baseUrl + "/api/cargo/status") else {
            return
        }
        
        let headers: HTTPHeaders = [
            .authorization(bearerToken: token)
        ]
        
        AF.request(url, method: .get, headers: headers ).validate(statusCode: 200..<500).responseDecodable(of: [Status].self) { response in
            if response.response?.statusCode == 401 {
                completion(nil, nil, true)
            } else {
                switch(response.result) {
                case .success(let value):
                    completion(value, nil, false)
                case .failure(let error):
                    completion(nil, error, false)
                }
            }
            
        }
    }
    
    func getNewOrders(token: String, completion: @escaping WebServiceResponseGetNewOrders) {
        guard let url = URL(string: baseUrl + "/api/cargo/list") else {
            return
        }
        
        let headers: HTTPHeaders = [
            .authorization(bearerToken: token)
        ]
        
        AF.request(url, method: .get, headers: headers ).validate(statusCode: 200..<500).responseDecodable(of: [Order].self) { response in
            
            print(response)

            switch(response.result) {
            case .success(let value):
                
                completion(value, nil)
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
    
    func postOrderAccept(token: String, id: Int, location: String, completion: @escaping WebServiceResponsePostOrderAccept) {
        guard let url = URL(string: baseUrl + "/api/cargo") else {
            return
        }
        
        let headers: HTTPHeaders = [
            .authorization(bearerToken: token)
        ]
        let parameters: [String: Any] = [
            "cargoid": id,
            "location": location
        ]
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers ).validate(statusCode: 200..<500).responseString { response in
            
            let statusCode = response.response?.statusCode ?? 404
            if statusCode == 202 {
                completion(true, nil)
            } else if let error = response.error {
                completion(false, error)
            } else {
                completion(false, NSError(domain: "error", code: statusCode))
            }
        }
    }
    
    func getMyOrders(token: String, completion: @escaping WebServiceResponseGetMyOrders) {
        guard let url = URL(string: baseUrl + "/api/cargo/my") else {
            return
        }
        
        let headers: HTTPHeaders = [
            .authorization(bearerToken: token)
        ]
        
        AF.request(url, method: .get, headers: headers ).validate(statusCode: 200..<500).responseDecodable(of: [Order].self) { response in
            
            print(response)

            switch(response.result) {
            case .success(let value):
                completion(value, nil)
            case .failure(let error):
                if response.response?.statusCode == 404 {
                    completion([], nil)
                } else {
                    completion(nil, error)
                }
            }
        }
    }
    
    func delOrderDelete(token: String, id: Int, completion: @escaping WebServiceResponsePostOrderAccept) {
        guard let url = URL(string: baseUrl + "/api/cargo/remove") else {
            return
        }
        
        let headers: HTTPHeaders = [
            .authorization(bearerToken: token)
        ]
        let parameters: [String: Any] = [
            "cargoid": id
        ]
        
        AF.request(url, method: .delete, parameters: parameters, encoding: JSONEncoding.default, headers: headers ).validate(statusCode: 200..<500).responseString { response in
            
            let statusCode = response.response?.statusCode ?? 404
            if statusCode == 200 || statusCode == 202 {
                completion(true, nil)
            } else if let error = response.error {
                completion(false, error)
            } else {
                completion(false, NSError(domain: "error", code: statusCode))
            }
        }
    }
    
    func getComplatedOrders(token: String, completion: @escaping WebServiceResponseGetComplatedOrders) {
        guard let url = URL(string: baseUrl + "/api/cargo/completed") else {
            return
        }
        
        let headers: HTTPHeaders = [
            .authorization(bearerToken: token)
        ]
        
        AF.request(url, method: .get, headers: headers ).validate(statusCode: 200..<500).responseDecodable(of: [Order].self) { response in
            
            print(response)

            switch(response.result) {
            case .success(let value):
                
                completion(value, nil)
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
    
    func postPhotosAndStatus(token: String, appId: Int, status: Int, location: String, images: [UIImage], completion: @escaping WebServiceResponsePostFile) {
        guard let url = URL(string: baseUrl + "/api/cargo/upload") else {
            return
        }
        
        let headers: HTTPHeaders = [
            .authorization(bearerToken: token)
        ]
        
        AF.upload(multipartFormData: { multipartFormData in
            for img in images {
                let imgData = img.jpegData(compressionQuality: 0.25)!
                multipartFormData.append(imgData, withName: "" ,fileName: "image.jpeg", mimeType: "image/jpeg")
            }
            multipartFormData.append(Data(String(appId).utf8), withName: "appId")
            multipartFormData.append(Data(String(status).utf8), withName: "status")
            multipartFormData.append(Data(String(location).utf8), withName: "location")
        },  to: url,
            method: .post,
            headers: headers)
        .uploadProgress { progress in
            print(progress)
        }
        .responseString { response in
            print("response")
            print(response.value)
            if response.response?.statusCode == 202 {
                print("SUC RESS")
                completion(true, nil)
                return
            } else if let error = response.error {
                print("ERROR = ", response.response?.statusCode)
                print(response)
            
                completion(false, error)
                return
            }
            completion(false, nil)
        }
    }
    
    func putDriverLocation(token: String, location: String, completion: @escaping WebServiceResponsePutDriverLocation) {
        guard let url = URL(string: baseUrl + "/api/driver/location") else {
            return
        }
        
        let headers: HTTPHeaders = [
            .authorization(bearerToken: token)
        ]
        let parameters: [String: Any] = [
            "location": location
        ]
        
        AF.request(url, method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: headers ).validate(statusCode: 200..<500).responseString { response in
            
            let statusCode = response.response?.statusCode ?? 404
            if statusCode == 200 {
                completion(true, nil)
            } else if let error = response.error {
                completion(false, error)
            } else {
                completion(false, NSError(domain: "error", code: statusCode))
            }
        }
    }
}
