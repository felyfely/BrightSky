// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let forecasts = try? newJSONDecoder().decode(Forecasts.self, from: jsonData)

import Foundation

// MARK: - Forecasts
struct Forecasts: Codable {
    let lat, lon: Double?
    let timezone: String?
    let timezoneOffset: Double?
    let current: Current
    let minutely: [Minutely]?
    let hourly: [Current]
    let daily: [Daily]

    enum CodingKeys: String, CodingKey {
        case lat, lon, timezone
        case timezoneOffset
        case current, minutely, hourly, daily
    }
}

// MARK: - Daily
struct Daily: Codable {
    let dt: Date
    let sunrise, sunset, moonrise, moonset: Double?
    let moonPhase: Double?
//    let temp: Temp?
//    let feelsLike: FeelsLike?
    let pressure, humidity: Double?
    let dewPoint, windSpeed: Double?
    let windDeg: Double?
    let windGust: Double?
    let weather: [Weather]
    let clouds, pop: Double?
    let uvi: Double?
}

// MARK: - Current
struct Current: Codable {
    let dt: Date
    let sunrise, sunset: Double?
    let temp: Double
    let feelsLike: Double?
    let pressure, humidity: Double?
    let dewPoint, uvi: Double?
    let clouds, visibility: Double?
    let windSpeed: Double?
    let windDeg: Double?
    let windGust: Double?
    let weather: [Weather]
    let pop: Double?
}

// MARK: - Weather
struct Weather: Codable {
    let id: Int
    let main: String?
    let weatherDescription: String?
    let icon: String

    enum CodingKeys: String, CodingKey {
        case id, main
        case weatherDescription = "description"
        case icon
    }
}

enum Main: String, Codable {
    case clear = "Clear"
    case clouds = "Clouds"
}

enum Description: String, Codable {
    case brokenClouds = "broken clouds"
    case clearSky = "clear sky"
    case fewClouds = "few clouds"
    case overcastClouds = "overcast clouds"
    case scatteredClouds = "scattered clouds"
}


// MARK: - FeelsLike
struct FeelsLike: Codable {
    let day, night, eve, morn: Double
}

// MARK: - Temp
struct Temp: Codable {
    let day, min, max, night: Double
    let eve, morn: Double
}

// MARK: - Minutely
struct Minutely: Codable {
    let dt: Date
    let precipitation: Double?
}
