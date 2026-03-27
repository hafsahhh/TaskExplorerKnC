//
//  taskViewModel.swift
//  TaskExplorerKnC
//
//  Created by Siti Hafsah on 26/03/26.
//

import Foundation
import RxSwift
import RxCocoa

final class TaskListViewModel {
    
    private let service: ApiServiceProtocol
    private let storage: TaskStorage
    
    private var allTasks: [Task] = []
    private var currentFilter: TaskFilter = .all
    private var currentQuery: String = ""
    
    let tasks = BehaviorRelay<[Task]>(value: [])
    let error = PublishRelay<String>()
    let isLoading = BehaviorRelay<Bool>(value: false)
    
    enum TaskFilter {
        case all
        case completed
        case notCompleted
        case favorite
    }
    
    init(service: ApiServiceProtocol, storage: TaskStorage) {
        self.service = service
        self.storage = storage
    }
    
    func refreshFavorites() {
        isLoading.accept(true)
        applyFilter()
        isLoading.accept(false)
    }
    
    func fetchTasks() {
        service.fetchTasks { [weak self] result in
            switch result {
            case .success(let tasks):
                self?.allTasks = tasks
                self?.applyFilter()
            case .failure(let err):
                self?.error.accept(err.localizedDescription)
            }
        }
    }
    
    // MARK: - Search
    
    func search(query: String) {
        currentQuery = query
        applyFilter()
    }
    
    // MARK: - Filter
    
    func setFilter(_ filter: TaskFilter) {
        currentFilter = filter
        applyFilter()
    }
    
    // MARK: - Combine Filter + Search
    
    private func applyFilter() {
        let favorites = Set(storage.getFavorites())
        
        var filtered = allTasks
        
        // Filter dulu
        switch currentFilter {
        case .all:
            break
            
        case .completed:
            filtered = filtered.filter { $0.completed }
            
        case .notCompleted:
            filtered = filtered.filter { !$0.completed }
            
        case .favorite:
            filtered = filtered.filter { favorites.contains($0.id) }
        }
        
        // Search setelah filter
        let trimmed = currentQuery.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if !trimmed.isEmpty {
            filtered = filtered.filter {
                $0.title.lowercased().contains(trimmed.lowercased())
            }
        }
        
        tasks.accept(filtered)
    }
    
    func isCompleted(_ task: Task) -> Bool {
        return task.completed
    }
}
