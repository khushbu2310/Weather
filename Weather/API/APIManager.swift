//
//  APIManager.swift
//  Weather
//
//  Created by Khushbuben Patel on 09/10/23.
//

import Foundation

protocol APIRouter {
    var host: String { get }
    var schema: String { get }
    var path: String { get }
    var method: String { get }
    var queryItems: [URLQueryItem] { get }
    var headers: [(String, String)] { get }
    var statusCode: Int { get }
    var body: Codable? { get }
}

enum APIRequestError: Error {
    case badUrl, noData, invalidResponse, encodeError(Error), invalidData, decodeError(Error)
}

typealias Handler<T> = (Result<T,APIRequestError>) -> Void

final class APIManager {
    static let shared = APIManager()
    private init() {}
    
    func request<T:Codable> (apiRouter: APIRouter, modelType: T.Type, completion: @escaping Handler<T>) {
        var components = URLComponents()
        components.host = apiRouter.host
        components.scheme = apiRouter.schema
        components.path = apiRouter.path
        components.queryItems = apiRouter.queryItems
        
        guard let url = components.url else {
            completion(.failure(.badUrl))
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = apiRouter.method
        
        apiRouter.headers.forEach { (key, value) in
            urlRequest.addValue(value, forHTTPHeaderField: key)
        }
        
        if let requestBody = apiRouter.body {
            do {
                let data = try JSONEncoder().encode(requestBody)
                urlRequest.httpBody = data
            } catch {
                completion(.failure(.encodeError(error)))
            }
        }
        
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            
            guard let data = data, error == nil else {
                completion(.failure(.invalidData))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == apiRouter.statusCode else {
                completion(.failure(.invalidResponse))
                return
            }
            
            do {
                let response = try JSONDecoder().decode(T.self, from: data)
                completion(.success(response))
            } catch {
                print("Decoding error in API Router: \(error)")
                completion(.failure(.decodeError(error)))
            }
        }.resume()
    }
}


