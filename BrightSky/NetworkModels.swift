//
//  NetworkModels.swift
//  BrightSky
//
//  Created by 付 旦 on 5/6/21.
//

import Foundation

struct OneCallRequest: NetworkRequestable {
    
    let lat: Double
    let lon: Double
    
    var method: HTTPMethod { .get }
    
    var path: String { "onecall"}
    
    var query: [String : String]? {
        ["lat": lat.description, "lon": lon.description, "units": "metric"]
    }
    
    typealias Response = Forecasts
    
}
