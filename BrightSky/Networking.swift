//
//  Networking.swift
//  BrightSky
//
//  Created by 付 旦 on 5/6/21.
//

import Foundation
import Combine

enum HTTPMethod: String {
    case connect, delete, get, head, options, patch, post, put, trace
}


protocol NetworkRequestable {
    associatedtype Response: Decodable
    
    var method: HTTPMethod { get }
    var path: String { get }
    var query: [String: String]? { get }
}

enum CustomError: Error, Equatable {
    case serializationError(message: String)
    case clientError(code: Int)
    case serverError(code: Int)
}

struct NetworkClient {
    
    static let shared = NetworkClient.init()
    
    let session = URLSession.init(configuration: .default)
    
    func executeRequest(_ request: URLRequest) -> AnyPublisher<Data, Error> {
        return session.dataTaskPublisher(for: request)
            .tryMap() { element -> Data in
                guard let httpResponse = element.response as? HTTPURLResponse,
                      httpResponse.statusCode <= 300 else {
                    throw URLError(.badServerResponse)
                }
                return element.data
            }
        .eraseToAnyPublisher()
    }
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

