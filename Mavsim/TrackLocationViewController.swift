//
//  TrackLocationViewController.swift
//  Mavsim
//
//  Created by istiqlolsoft on 03/01/23.
//

import UIKit
import CoreLocation

class TrackLocationViewController: UIViewController {
    
    let locationService = LocationService()
    private var statusLabel: UILabel!
    var startTime: Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupStatusLabel()
        initializeLocationServices()
    }
    
    private func setupStatusLabel() {
        statusLabel = UILabel(frame: .zero)
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        statusLabel.font = .systemFont(ofSize: 24)
        statusLabel.numberOfLines = 0
        statusLabel.textAlignment = .center
        view.addSubview(statusLabel)
        
        NSLayoutConstraint.activate([
            statusLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0),
            statusLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            statusLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
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

extension TrackLocationViewController: LocationServiceDelegate {
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
        locationService.start()
    }
    
    func locationUpdate(locations: [CLLocation]) {
        guard let loc = locations.last else { return }
        let locStr = String(loc.coordinate.latitude ) + " , " + String(loc.coordinate.longitude )
        TemporaryData.lastLocation = locStr
        let time = loc.timestamp
        print(locStr)
        guard var startTime = startTime else {
            self.startTime = time
            return
        }
        
        let elapsed = time.timeIntervalSince(startTime)
        
        print("elapsed = ", elapsed)
        if elapsed > 15 {
            print("start send " , locStr)
            self.startTime = time
            sendLocation(location: locStr)
            
        }
    }
}

extension TrackLocationViewController {
    
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
        let alert = UIAlertController(title: "Location access is needed to get your current location", message: "Please allow location access", preferredStyle: .alert)
        let settingsAction = UIAlertAction(title: "Settings", style: .default, handler: { _ in
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
        })

        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: { [weak self] _ in
            self?.locationServicesNeededState()
        })

        alert.addAction(settingsAction)
        alert.addAction(cancelAction)
              
        alert.preferredAction = settingsAction

        present(alert, animated: true, completion: nil)
    }
    
    func locationServicesNeededState() {
        self.statusLabel.text = "Access to location services is needed."
    }
    
    func locationServicesRestrictedState() {
        statusLabel.text = "The app is restricted from using the location services."
    }
}
