//
//  LoginConstroller.swift
//  Mavsim
//
//  Created by mac on 23/11/22.
//

import Foundation
import UIKit

class LoginController: UIViewController {
    
    @IBOutlet weak var login: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var indicatorLoading: UIActivityIndicatorView!
    
    var loginTextRes: String?
    
    private let networkClient = NetworkingClient()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginButton.backgroundColor = Colors.yellow
    }
    
    
    @IBAction func clickLoginButton(_ sender: Any) {
        
        authWithLogin()
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "MainStoryboard") as! TabBarController
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    
    func authWithLogin(){
        
        indicatorLoading.isHidden = false
        loginButton.setTitle("", for: .normal)

        networkClient.authWithLogin(login: login.text!, password: password.text! ){ (json, error) in
            if let error = error {
                print(error.localizedDescription)
                self.showRightToast()
                
            } else if let json = json {
                
                let token = json["message"] as! String
                print(token)
                
            }
        }
    }
    
    func showRightToast(){
        indicatorLoading.isHidden = true
        loginButton.setTitle(loginTextRes, for: .normal)

        if IncLoadData.inCorrectLogOrPass == true {
            self.showToast(controller: self, message: "Неправлиьный логин или пароль", seconds: 2)
        } else if IncLoadData.serverNotResponse == true {
            if true {
                self.showToast(controller: self, message: "Ошибка подключение к серверу", seconds: 2)
               
            } else {
                self.showToast(controller: self, message: "Проверте поключение к интернету", seconds: 2)
            }
        } else {
            self.showToast(controller: self, message: "Неизвестная ошибка", seconds: 2)
        }

        
        IncLoadData.inCorrectLogOrPass = false
        IncLoadData.serverNotResponse = false
    }
    
    func showToast(controller: UIViewController, message: String, seconds: Double) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.view.backgroundColor = .black
        alert.view.alpha = 0.7
        alert.view.layer.cornerRadius = 20
        
        controller.present(alert, animated: true)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds) {
            alert.dismiss(animated: true)
        }
    }
    
    
}
