//
//  Model.swift
//  TaskExplorerKnC
//
//  Created by Siti Hafsah on 26/03/26.
//

import Foundation

struct Task: Decodable {
    let userId: Int
    let id: Int
    let title: String
    let completed: Bool
}
