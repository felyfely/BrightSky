//
//  BrightSkyApp.swift
//  BrightSky
//
//  Created by 付 旦 on 5/6/21.
//

import SwiftUI
import CoreLocation

@main
struct BrightSkyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(coordinate: CLLocationCoordinate2D.init(latitude: 37.335046, longitude: -122.009007))
        }
    }
}
