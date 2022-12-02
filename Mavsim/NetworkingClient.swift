//
//  NetworkingClient.swift
//  Mavsim
//
//  Created by mac on 23/11/22.
//

import Foundation
import Alamofire

class NetworkingClient {
    final var baseUrl: String = "http://api.mavsim.com"
    
    static let standart = NetworkingClient()
    private init() {}
    
    typealias WebServiceResponseAuthWithLogin = (String?, Error?) -> Void
    typealias WebServiceResponseGetUserDriver = (User?, Error?) -> Void
    typealias WebServiceResponseGetNewOrders = ([Order]?, Error?) -> Void
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
            "Username": "918545454",
            "Password": "123456"
        ]
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers ).validate(statusCode: 200..<500).responseString { response in

            switch(response.result) {
            case .success(let value):
                completion(value, nil)
            case .failure(let error):
                completion(nil, error)
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

            switch(response.result) {
            case .success(let value):
                completion(value, nil)
            case .failure(let error):
                completion(nil, error)
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
}
