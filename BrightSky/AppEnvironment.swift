//
//  AppEnvironment.swift
//  BrightSky
//
//  Created by 付 旦 on 5/6/21.
//

import Foundation
import Combine

struct OpenWeatherConstants {
    
    static let apiKey = "15571afac7e37c3311637cad671cd6bb"

    static let baseUrl = URL.init(string: "https://api.openweathermap.org/data/2.5")! // force unwarp on a static string is safe
    static let weatherIconBaseUrl = "https://openweathermap.org/img/w"

}
