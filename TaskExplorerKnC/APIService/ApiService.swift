//
//  ApiService.swift
//  TaskExplorerKnC
//
//  Created by Siti Hafsah on 26/03/26.
//

import Foundation

protocol ApiServiceProtocol {
    func fetchTasks(completion: @escaping (Result<[Task], Error>) -> Void)
}

final class ApiService: ApiServiceProtocol {
    
    private let network: NetworkService
    
    init(network: NetworkService = NetworkService()) {
        self.network = network
    }
    
    func fetchTasks(completion: @escaping (Result<[Task], Error>) -> Void) {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/todos") else {
            completion(.failure(NetworkError.invalidResponse))
            return
        }
        
        network.request(url: url, completion: completion)
    }
}
