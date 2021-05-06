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

private let snakeJsonDecoder: JSONDecoder = {
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    decoder.dateDecodingStrategy = .secondsSince1970
    return decoder
}()


extension NetworkRequestable {
    func apiCall() -> AnyPublisher<Response, Error> {
        return NetworkClient.shared.executeRequest(buildRequest()).decode(type: Response.self, decoder: snakeJsonDecoder)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func buildRequest() -> URLRequest {
        var requestUrl = OpenWeatherConstants.baseUrl
        // adding path
        requestUrl.appendPathComponent(path)
        // adding auth
        guard var urlcomponents = URLComponents.init(url: requestUrl, resolvingAgainstBaseURL: false) else {
            return URLRequest.init(url: requestUrl)
        }
        
        var queryItems = urlcomponents.queryItems ?? [URLQueryItem]()
        
        // adding custom queries
        let customQueries = query?.map{
            URLQueryItem.init(name: $0, value: $1)
        }
        customQueries.flatMap { queryItems.append(contentsOf: $0) }
        
        // adding auth query
        let authQuery = URLQueryItem.init(name: "appid", value: OpenWeatherConstants.apiKey)
        queryItems.append(authQuery)
        
        urlcomponents.queryItems = queryItems
        
        urlcomponents.url.flatMap{ requestUrl = $0 }
        
        var request = URLRequest.init(url: requestUrl)
        request.httpMethod = method.rawValue
        
        return request
    }
    
}
