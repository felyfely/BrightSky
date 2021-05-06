//
//  WeatherListViewModel.swift
//  BrightSky
//
//  Created by 付 旦 on 5/6/21.
//

import Foundation
import Combine

class WeatherListViewModel: ObservableObject {
    var locationManager = LocationManager()
    var anyCancelable: Set<AnyCancellable> = []
    @Published var forcasts: Forecasts?
    
    init() {
        // dummy data, apple park
        let lat = 37.335046
        let lon = -122.009007
        getWeatherForcasts(lat: lat, lon: lon)
        
        locationManager.didUpdateLocation = { [weak self] loc in
            self?.forcasts = nil // avoid bug when refreshing data
            self?.getWeatherForcasts(lat: loc.latitude, lon: loc.longitude)
        }
    }

    func getWeatherForcasts(lat: Double, lon: Double) {
        OneCallRequest.init(lat: lat, lon: lon).apiCall().sink {
            (value) in
            debugPrint(value)
        } receiveValue: { [weak self] (casts) in
            self?.forcasts = casts
        }
        .store(in: &anyCancelable)
    }
    
    func queryLocation() {
        locationManager.requestLocation()
    }
}
