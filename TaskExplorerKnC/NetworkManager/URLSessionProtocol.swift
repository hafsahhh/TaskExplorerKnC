//
//  URLSessionProtocol.swift
//  TaskExplorerKnC
//
//  Created by Siti Hafsah on 26/03/26.
//

import Foundation

protocol URLSessionProtocol {
    func dataTask(
        with request: URLRequest,
        completionHandler: @escaping @Sendable (Data?, URLResponse?, Error?) -> Void
    ) -> URLSessionDataTask
}
extension URLSession: URLSessionProtocol {}
