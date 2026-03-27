//
//  NetworkService.swift
//  TaskExplorerKnC
//
//  Created by Siti Hafsah on 26/03/26.
//

import Foundation

final class NetworkService {
    
    private let session: URLSessionProtocol
    
    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
    
    func request<T: Decodable>(
        url: URL,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        let request = URLRequest(url: url)
        
        let task = session.dataTask(with: request) { data, response, error in
            
            // 1. Error dari URLSession
            if let error = error {
                self.returnOnMain {
                    completion(.failure(error))
                }
                return
            }
            
            // 2. Validasi response
            guard let httpResponse = response as? HTTPURLResponse,
                  200...299 ~= httpResponse.statusCode else {
                self.returnOnMain {
                    completion(.failure(NetworkError.invalidResponse))
                }
                return
            }
            
            // 3. Validasi data
            guard let data = data else {
                self.returnOnMain {
                    completion(.failure(NetworkError.noData))
                }
                return
            }
            
            // 4. Decode
            do {
                let decoded = try JSONDecoder().decode(T.self, from: data)
                self.returnOnMain {
                    completion(.success(decoded))
                }
            } catch {
                self.returnOnMain {
                    completion(.failure(NetworkError.decodingError))
                }
            }
        }
        
        task.resume()
    }
    
    private func returnOnMain(_ block: @escaping () -> Void) {
        DispatchQueue.main.async {
            block()
        }
    }
}
