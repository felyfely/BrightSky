//
//  LocationManager.swift
//  BrightSky
//
//  Created by 付 旦 on 5/7/21.
//

import Foundation
import CoreLocation
import Combine

class LocationManager: NSObject, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    var lastLocation: CLLocationCoordinate2D?
    
    var didUpdateLocation: ((CLLocationCoordinate2D) -> Void)?
    
//  weather report for their current location.
    func requestLocation() {
        locationManager.delegate = self
        lastLocation = locationManager.location?.coordinate
//        updateLocation()
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            break // should prompt maybe ?
        case .denied:
            break // go to settings
        case .authorizedAlways:
            locationManager.requestLocation()
        case .authorizedWhenInUse:
            locationManager.requestLocation()
        @unknown default:
            break // can still try
        }
    }
    
    func updateLocation() {
        if let loc = lastLocation, loc.latitude != 0, loc.longitude != 0 {
            didUpdateLocation?(loc)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        lastLocation = locations.last?.coordinate
        updateLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        debugPrint(error.localizedDescription)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        requestLocation()
    }
}
