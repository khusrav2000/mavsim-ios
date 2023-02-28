//
//  LoginConstroller.swift
//  Mavsim
//
//  Created by mac on 23/11/22.
//

import Foundation
import UIKit

class LoginController: UIViewController {
    
    func hideKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard(_:)))
        view.addGestureRecognizer(tap)
    }
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    enum LoadType {
        case Auth, Token
    }
    
    @IBOutlet weak var login: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var indicatorLoading: UIActivityIndicatorView!
    
    @IBOutlet weak var loadingIndicatorRefresh: UIActivityIndicatorView!
    @IBOutlet weak var loginViewBackground: UIView!
    @IBOutlet weak var loginView: UIView!
    //@IBOutlet weak var loadingView: UIView!
    var loginTextRes: String?
    
    
    // private let networkClient = NetworkingClient()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboard()
        login.delegate = self
        password.delegate = self
        
        loginButton.tintColor = Colors.yellow
        loginButton.layer.cornerRadius = 5
        
        login.layer.borderWidth = 1
        login.layer.cornerRadius = 5
        login.layer.borderColor = UIColor.darkGray.cgColor
        
        password.layer.borderWidth = 1
        password.layer.cornerRadius = 5
        password.layer.borderColor = UIColor.darkGray.cgColor
        
        loginView.layer.cornerRadius = 5
        loginView.layer.shadowOpacity = 0.2
        loginView.layer.shadowOffset = .zero
        loginView.layer.shadowRadius = 2
        
        loginViewBackground.layer.cornerRadius = 5
        loginViewBackground.layer.shadowOpacity = 0.2
        loginViewBackground.layer.shadowOffset = .zero
        loginViewBackground.layer.shadowRadius = 2
        
        checkToken()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkToken()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if login.isHidden == false {
            login.becomeFirstResponder()
        }
    }
    
    func checkToken() {
        let data = KeychainHelper.standart.read(service: "access-token", account: "mavsim")
        
        if data == nil {
            login.becomeFirstResponder()
            login.isHidden = false
            password.isHidden = false
            loginButton.isHidden = false
        } else {
            refreshToken()
        }
            
    }
    
    func refreshToken() {
        indicatorLoading.stopAnimating()
        login.isHidden = true
        password.isHidden = true
        loginButton.isHidden = true
        loadingIndicatorRefresh.startAnimating()
        
        loadDriverInfo(type: .Token)
    }
    
    
    @IBAction func clickLoginButton(_ sender: Any) {
        authWithLogin()
    }
    
    func authWithLogin(){
        
        indicatorLoading.startAnimating()
        loginButton.isHidden = true

        NetworkingClient.standart.authWithLogin(login: login.text!, password: password.text! ){ (token, error) in
            if let error = error {
                print(error.localizedDescription)
                self.showRightToast()
                self.authRequestError()
                
            } else if let token = token {
                print("token \(String(describing: token))")
                let data = Data(token.utf8)
                KeychainHelper.standart.save(data, service: "access-token", account: "mavsim")
                self.loadDriverInfo(type: .Auth)
            }
        
        }
    }
    
    func loadDriverInfo(type: LoadType) {
        
        let data = KeychainHelper.standart.read(service: "access-token", account: "mavsim")
        
        if data == nil {
            return
        }
        
        let token = String(data: data!, encoding: .utf8)!
        NetworkingClient.standart.getUserDriver(token: token) { (user, error, unauthorized) in
            if unauthorized ?? false {
                self.unauthorizedAction()
            } else if let user = user {
                self.indicatorLoading.stopAnimating()
                self.loadingIndicatorRefresh.stopAnimating()
                TemporaryData.user = user
                self.loadStatusInfo(type: type)
            }
            else if let error = error {
                print(error)
                if type == .Auth {
                    self.authRequestError()
                } else {
                    self.tokenRequestError()
                }
                self.showRightToast()
            }
            
        }
        
    }
    
    func loadStatusInfo(type: LoadType) {
        let data = KeychainHelper.standart.read(service: "access-token", account: "mavsim")
        
        if data == nil {
            return
        }
        
        let token = String(data: data!, encoding: .utf8)!
        NetworkingClient.standart.getCargoStatus(token: token) { (statues, error, unauthorized) in
            if unauthorized ?? false {
                self.unauthorizedAction()
            } else if let statues = statues {
                self.indicatorLoading.stopAnimating()
                self.loadingIndicatorRefresh.stopAnimating()
                TemporaryData.statues = statues
                self.presentMain()
            }
            else if let error = error {
                print(error)
                if type == .Auth {
                    self.authRequestError()
                } else {
                    self.tokenRequestError()
                }
                self.showRightToast()
            }
            
        }
    }
    
    func unauthorizedAction() {
        indicatorLoading.stopAnimating()
        login.isHidden = false
        password.isHidden = false
        loginButton.isHidden = false
        loadingIndicatorRefresh.stopAnimating()
    }
    
    func authRequestError() {
        indicatorLoading.stopAnimating()
        loginButton.isHidden = false
    }
    
    func tokenRequestError() {
        loadingIndicatorRefresh.stopAnimating()
    }
    
    func presentMain() {
        // trackLocation()
        let vc = storyboard?.instantiateViewController(withIdentifier: "MainStoryboard") as! TabBarController
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    
    /*func trackLocation() {
        let vc = TrackLocationViewController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }*/
    
    func showRightToast(){

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

extension LoginController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.returnKeyType == .next {
            self.password.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
}
