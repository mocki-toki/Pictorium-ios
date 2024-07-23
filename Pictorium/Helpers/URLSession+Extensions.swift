//
//  URLSession+data.swift
//  Pictorium
//
//  Created by Simon Butenko on 21.05.2024.
//

import Foundation

enum NetworkError: Error {
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case urlSessionError
}

extension URLSession {
    func data(
        for request: URLRequest,
        completion: @escaping (Result<Data, Error>) -> Void
    ) -> URLSessionTask {
        let fulfillCompletionOnTheMainThread: (Result<Data, Error>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }

        let task = dataTask(with: request) { data, response, error in
            if let data = data, let response = response, let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if 200 ..< 300 ~= statusCode {
                    fulfillCompletionOnTheMainThread(.success(data))
                } else {
                    print("HTTP error: \(statusCode)")
                    fulfillCompletionOnTheMainThread(.failure(NetworkError.httpStatusCode(statusCode)))
                }
            } else if let error = error {
                print("URL request error: \(error)")
                fulfillCompletionOnTheMainThread(.failure(NetworkError.urlRequestError(error)))
            } else {
                print("URL session error")
                fulfillCompletionOnTheMainThread(.failure(NetworkError.urlSessionError))
            }
        }

        task.resume()
        return task
    }

    func objectTask<T: Decodable>(
        for request: URLRequest,
        completion: @escaping (Result<T, Error>) -> Void
    ) -> URLSessionTask {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let task = data(for: request) { (result: Result<Data, Error>) in
            do {
                switch result {
                case .success(let data):
                    let decodedData = try decoder.decode(T.self, from: data)
                    completion(.success(decodedData))
                case .failure(let error):
                    break
                }
            } catch {
                print("Decoding error: \(error)")
                completion(.failure(error))
            }
        }
        return task
    }
}
