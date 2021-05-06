//
//  DataModelExtension.swift
//  BrightSky
//
//  Created by 付 旦 on 5/6/21.
//

import Foundation

extension Daily: Identifiable {
    var id: Double {
        return dt.timeIntervalSince1970
    }
}

extension Daily {
    var dayString: String {
        let cal = Calendar.current
        let dayOfTheWeek = Calendar.current.component(.weekday, from: dt)
        return cal.weekdaySymbols[dayOfTheWeek - cal.firstWeekday]
    }
    
    
}

extension Weather: Identifiable {}

extension Weather {
    var imageUrl: URL {
        URL.init(string: OpenWeatherConstants.weatherIconBaseUrl)!.appendingPathComponent("\(self.icon).png")
    }
}

extension Current: Identifiable {
    var id: Double {
        return dt.timeIntervalSince1970
    }
}

