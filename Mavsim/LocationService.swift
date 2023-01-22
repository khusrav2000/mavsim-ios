//
//  LocationService.swift
//  Mavsim
//
//  Created by istiqlolsoft on 03/01/23.
//

import CoreLocation
import AppTrackingTransparency

protocol LocationServiceDelegate: class {
    func authorizationRestricted()
    func authorizationUknown()
    func promptAuthorizationAction()
    func didAuthorize()
    func locationUpdate(locations: [CLLocation])
    func authTracking()
}

class LocationService: NSObject {
    weak var delegate: LocationServiceDelegate?
    
    private var locationManager: CLLocationManager!
    
    var enabled: Bool {
        return CLLocationManager.locationServicesEnabled()
    }
    
    init(locationManager: CLLocationManager = CLLocationManager()) {
        super.init()
        self.locationManager = locationManager
        self.locationManager.delegate = self
    }
    
    func requestAuthorization() {
        locationManager.requestAlwaysAuthorization()
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.showsBackgroundLocationIndicator = true
    }
    
    func start() {
        locationManager.startUpdatingLocation()
    }
    
    func stop() {
        locationManager.stopUpdatingLocation()
    }
    
    func requestTrackPermission() {
        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization { status in
                switch status {
                case .authorized:
                    print("Authorized")
                    self.delegate?.authTracking()
                case .denied:
                    print("Denied")
                case .notDetermined:
                    print("Not Determined")
                case .restricted:
                    print("Restricted")
                @unknown default:
                    print("Unknown")
                }
            }
        }
    }
}

extension LocationService: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        
        switch status {
        case .denied:
            print("denied")
            //ask user to authorize
            delegate?.promptAuthorizationAction()
        case .notDetermined:
            print("notDetermined")
        case .restricted:
            print("restricted")
            //inform the user
            delegate?.authorizationRestricted()
        case .authorizedWhenInUse:
            print("authorizedWhenInUse")
            //didAuthorized
            delegate?.didAuthorize()
        case .authorizedAlways:
            print("authorizedAlways")
            //didAuthorized
            delegate?.didAuthorize()
        default:
            print("unknown")
            //inform the user
            delegate?.authorizationUknown()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        delegate?.locationUpdate(locations: locations)
    }
}
