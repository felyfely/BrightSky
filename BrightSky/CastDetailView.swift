//
//  CastDetailView.swift
//  BrightSky
//
//  Created by 付 旦 on 5/6/21.
//

import SwiftUI

struct CastDetailView: View {
    let cast: Daily
    var body: some View {
        VStack {
            ForEach(cast.weather) { weather in
                RemoteImage(url: weather.imageUrl)
                Text(weather.weatherDescription ?? "")
            }
        }
    }
}

struct CastDetailView_Previews: PreviewProvider {
    static var previews: some View {
        CastDetailView(cast: Daily.init(dt: Date(), sunrise: 0, sunset: 0, moonrise: 0, moonset: 0, moonPhase: 0, temp: nil, feelsLike: nil, pressure: 0, humidity: 0, dewPoint: 0, windSpeed: 0, windDeg: 0, windGust: 0, weather: [], clouds: 0, pop: 0, uvi: 0))
    }
}
