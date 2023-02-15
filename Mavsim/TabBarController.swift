//
//  TabBarController.swift
//  Mavsim
//
//  Created by mac on 23/11/22.
//

import Foundation
import UIKit
import CoreLocation

class TabBarController: UITabBarController {
    
    let locationService = LocationService()
    private var statusLabel: UILabel!
    var startTime: Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.backgroundColor = Colors.yellow
        // tabBar.tintColor = Colors.yellow
        tabBar.barTintColor = Colors.yellow
        selectedIndex = 1
        tabBar.unselectedItemTintColor = .white
        
        //setupStatusLabel()
        initializeLocationServices()
        locationService.requestTrackPermission()
        //tabBar.barTintColor = Colors.yellow
    }
    
    private func initializeLocationServices() {
        locationService.delegate = self
        
        
        let isEnabled = locationService.enabled
        
        guard isEnabled else {
            locationServicesNeededState()
            return
        }
        
        // start
        locationService.requestAuthorization()
        
        
    }
}

extension TabBarController: LocationServiceDelegate {
    func authTracking() {
        print("authtrack")
        TemporaryData.trackPermission = true
    }
    
    func authorizationUknown() {
        locationServicesNeededState()
    }
    
    func authorizationRestricted() {
        locationServicesRestrictedState()
    }
    
    func promptAuthorizationAction() {
        promptForAuthorization()
    }
    
    func didAuthorize() {
        print("IS AUTH")
        locationService.start()
    }
    
    func locationUpdate(locations: [CLLocation]) {
        guard let loc = locations.last else { return }
        let locStr = String(loc.coordinate.latitude ) + " , " + String(loc.coordinate.longitude )
        TemporaryData.lastLocation = locStr
        let time = loc.timestamp
        // print(locStr)
        guard var startTime = startTime else {
            self.startTime = time
            return
        }
        
        let elapsed = time.timeIntervalSince(startTime)
        
        // print("elapsed = ", elapsed)
        if elapsed > 60 {
            print("start send " , locStr)
            self.startTime = time
            
            if TemporaryData.trackPermission {
                sendLocation(location: locStr)
            }
        }
    }
}

extension TabBarController {
    
    func sendLocation(location: String) {
        let data = KeychainHelper.standart.read(service: "access-token", account: "mavsim")
        
        if data == nil {
            return
        }
        let token = String(data: data!, encoding: .utf8)!
       
        NetworkingClient.standart.putDriverLocation(token: token, location: location) { (success, error) in
            if success ?? false {
                print("success!!!!!!")
            } else {
                print(error)
            }
        }
    }
    
    func promptForAuthorization() {
        let alert = UIAlertController(title: "Доступ к местоположению необходим, чтобы получить ваше текущее местоположение", message: "Чтобы приложении работала правильно пожалуйста включите доступ к местоположению в настройках. Сейчас приложение может работать некорректно, вы можете не видеть некоторые новые заказы.", preferredStyle: .alert)
        /*let settingsAction = UIAlertAction(title: "Settings", style: .default, handler: { _ in
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
        })*/

        let cancelAction = UIAlertAction(title: "Ok", style: .default, handler: { [weak self] _ in
            self?.locationServicesNeededState()
        })

        // alert.addAction(settingsAction)
        alert.addAction(cancelAction)
              
        // alert.preferredAction = settingsAction

        present(alert, animated: true, completion: nil)
    }
    
    func locationServicesNeededState() {
        // self.statusLabel.text = "Access to location services is needed."
        print("Access to location services is needed.")
    }
    
    func locationServicesRestrictedState() {
        // statusLabel.text = "The app is restricted from using the location services."
        print("The app is restricted from using the location services.")
    }
}

