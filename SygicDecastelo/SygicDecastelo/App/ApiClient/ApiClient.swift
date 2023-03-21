//
//  ApiClient.swift
//  SygicDecastelo
//
//  Created by Filip Decastelo on 21.03.2023.
//

import Foundation
import Combine

struct Router {
    let path: String
    let method: String?
    let headers: [String: String]?
    let body: Data?
}

class ApiClient {

    private let session: URLSession = URLSession.shared

    func dataTaskPublisher<Response: Decodable>(for router: Router) -> AnyPublisher<Response, Error> {
        session
            .dataTaskPublisher(for: makeRequest(for: router))
            .tryMap { (data, response) in
                if let response = response as? HTTPURLResponse,
                   !(200...299).contains(response.statusCode) {
                    print("### error asi vole \(response.statusCode)")
                }
                print("### data \(data)")
                return data
            }
            .decode(type: Response.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }

    private func makeRequest(for router: Router) -> URLRequest {
        var urlRequest = URLRequest(url: URL(string: router.path)!)
        urlRequest.httpMethod = router.method
        return urlRequest
    }
}
