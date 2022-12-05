//
//  Networking.swift
//  PYP
//
//  Created by Dongbing Hou on 2022/11/13.
//

import Foundation

class Networking {

    enum Method: String {
        case post = "POST"
        case get = "GET"
    }

    static let shard = Networking()

    private let session = URLSession(configuration: .default)

    func request<T: Codable>(
        _ method: Method = .get,
        url: String,
        parameters: [String: String]? = nil,
        model: T.Type,
        completion: @escaping (Result<T?, Error>) -> Void
    ) {
        guard let url = URL(string: url) else { return completion(.failure(.invalidURL)) }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        if let parameters, let data = try? JSONEncoder().encode(parameters) {
            urlRequest.httpBody = data
        }
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("Bearer some token", forHTTPHeaderField: "Authorization")
        request(urlRequest: urlRequest, model: model, completion: completion)
    }

    func request<T: Codable>(
        urlRequest: URLRequest,
        model: T.Type,
        completion: @escaping (Result<T?, Error>) -> Void
    ) {
        session.dataTask(with: urlRequest) { data, response, error in
            DispatchQueue.main.async {
                if let err = error as? URLError, err.code == .timedOut {
                    return completion(.failure(.timeout))
                }
                guard
                    let response = response as? HTTPURLResponse,
                    response.statusCode == 200
                else { return completion(.failure(.network)) }

                guard let data = data else { return completion(.failure(.noAvailableData)) }
                do {
                    let wrapper = try JSONDecoder().decode(ModelWrapper<T>.self, from: data)
                    if wrapper.code == 200 {
                        completion(.success(wrapper.data))
                    } else {
                        completion(.failure(.underlying(message: wrapper.message)))
                    }
                }
                catch {
                    completion(.failure(.decodeFailed))
                }
            }
        }
        .resume()
    }
}
