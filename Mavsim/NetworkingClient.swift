//
//  NetworkingClient.swift
//  Mavsim
//
//  Created by mac on 23/11/22.
//

import Foundation
import Alamofire

class NetworkingClient {
    final var baseUrl: String = "https://api.mavsim.com"
    
    typealias WebServiceResponseAuthWithLogin = ([String: Any]?, Error?) -> Void
    
    private let session: Session = {
        let manager = ServerTrustManager(evaluators: ["https://api.mavsim.com": DisabledTrustEvaluator()])
        let configuration = URLSessionConfiguration.af.default
        
        return Session(configuration: configuration, serverTrustManager: manager)
    }()
    
    func authWithLogin(login: String , password: String, completion: @escaping WebServiceResponseAuthWithLogin){
        
        guard let url = URL(string: baseUrl + "/api/login") else {
            return
        }
        
        let headers: HTTPHeaders = []
        let parameters = ["login": login, "password": password]
        
        
        
        AF.request(url, method: .post, parameters: parameters, headers: headers ).validate().responseJSON { response in
            
            if let error = response.error {
                
                if response.response != nil {
                    if response.response?.statusCode == 404 {
                        // IncLoadData.inCorrectLogOrPass = true
                        print("ASDASdasd")
                    }
                } else {
                    // IncLoadData.serverNotResponse = true
                }
                
                completion(nil, error)
                
                
            } else if let jsonDict = response.value as? [String: Any] {
                print("EE")
                //let token = jsonDic["message"] as! String
                //print(token)
                completion(jsonDict, nil)
            }
        }
        
    }
}
