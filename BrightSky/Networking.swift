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

