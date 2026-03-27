//
//  NetworkError.swift
//  TaskExplorerKnC
//
//  Created by Siti Hafsah on 26/03/26.
//

import Foundation
enum NetworkError: Error {
    case invalidResponse
    case noData
    case decodingError
}
