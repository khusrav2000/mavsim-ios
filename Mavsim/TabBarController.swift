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
    
    
    typealias LocationAddress = (String) -> Void
    
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
            self.startTime = time - 100
            return
        }
        
        let elapsed = time.timeIntervalSince(startTime)
        
        // print("elapsed = ", elapsed)
        if elapsed > 60 {
            reverseGeocoding(location: loc) { (address) in
                print("start send " , locStr, address)
                self.startTime = time
                TemporaryData.lastAddress = address
                
                if TemporaryData.trackPermission {
                    self.sendLocation(location: locStr, address: address)
                }
            }
        }
    }
    
    
    func reverseGeocoding(location: CLLocation, completion: @escaping LocationAddress) {
        let geocoder = CLGeocoder()
        // let location = CLLocation(latitude: latitude, longitude: longitude)
        geocoder.reverseGeocodeLocation(location, preferredLocale: Locale(identifier: "ru_RU"), completionHandler: {(placemarks, error) -> Void in
            if error != nil {
                print("Failed to retrieve address")
                completion("");
                return
            }
                        
            else if let placemarks = placemarks, let placemark = placemarks.first {
                print(placemark.address!)
                completion(placemark.address!)
                return
            }
            else
            {
                print("No Matching Address Found")
                completion("")
                return
            }
        })
    }
}

extension TabBarController {
    
    func sendLocation(location: String, address: String) {
        let data = KeychainHelper.standart.read(service: "access-token", account: "mavsim")
        
        if data == nil {
            return
        }
        let token = String(data: data!, encoding: .utf8)!
       
        NetworkingClient.standart.putDriverLocation(token: token, location: location, address: address) { (success, error) in
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

extension CLPlacemark {

    var address: String? {
        if let name = name {
            var result = name

            if let street = thoroughfare {
                result += ", \(street)"
            }

            if let city = locality {
                result += ", \(city)"
            }

            if let country = country {
                result += ", \(country)"
            }

            return result
        }

        return nil
    }

}

