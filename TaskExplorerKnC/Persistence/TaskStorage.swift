//
//  TaskStorage.swift
//  TaskExplorerKnC
//
//  Created by Siti Hafsah on 26/03/26.
//

import Foundation

final class TaskStorage {
    
    private let key = "favorite_tasks"
    
    func getFavorites() -> [Int] {
        return UserDefaults.standard.array(forKey: key) as? [Int] ?? []
    }
    
    func saveFavorites(_ ids: [Int]) {
        UserDefaults.standard.set(ids, forKey: key)
    }
}
