//
//  DetailTaskViewController.swift
//  TaskExplorerKnC
//
//  Created by Siti Hafsah on 27/03/26.
//

import UIKit
import SnapKit

final class TaskDetailViewController: UIViewController {
    
    private let task: Task
    private let storage = TaskStorage()
    
    // UI
    private let userIdLabel = UILabel()
    private let idLabel = UILabel()
    private let titleLabel = UILabel()
    private let statusLabel = UILabel()
    private let saveButton = UIButton()
    
    init(task: Task) {
        self.task = task
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        title = "Detail Task"
        navigationItem.backButtonDisplayMode = .minimal
        
        setupUI()
        configure()
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        view.addSubview(userIdLabel)
        view.addSubview(idLabel)
        view.addSubview(titleLabel)
        view.addSubview(statusLabel)
        view.addSubview(saveButton)
        
        titleLabel.numberOfLines = 0
        
        saveButton.setTitle(" Save", for: .normal)
        saveButton.setTitleColor(.systemBlue, for: .normal)
        saveButton.backgroundColor = .clear
        saveButton.layer.cornerRadius = 8

        saveButton.layer.borderWidth = 1
        saveButton.layer.borderColor = UIColor.systemBlue.cgColor
        
        saveButton.addTarget(self, action: #selector(didTapSave), for: .touchUpInside)
        
        // Layout
        userIdLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.left.right.equalToSuperview().inset(20)
        }
        
        idLabel.snp.makeConstraints {
            $0.top.equalTo(userIdLabel.snp.bottom).offset(12)
            $0.left.right.equalToSuperview().inset(20)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(idLabel.snp.bottom).offset(20)
            $0.left.right.equalToSuperview().inset(20)
        }
        
        statusLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.left.right.equalToSuperview().inset(20)
        }
        
        saveButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
            $0.left.right.equalToSuperview().inset(20)
            $0.height.equalTo(50)
        }
    }
    
    // MARK: - Configure UI
    private func configure() {
        userIdLabel.text = "User ID: \(task.userId)"
        idLabel.text = "Task ID: \(task.id)"
        titleLabel.text = "Title:\n\(task.title)"
        
        statusLabel.text = task.completed
            ? "Status: ✔️ Completed"
            : "Status: ❌ Not Completed"
        
        statusLabel.textColor = task.completed ? .systemGreen : .systemRed
        
        updateButtonUI()
    }
    
    // MARK: - Favorite Logic
    
    private func isFavorite() -> Bool {
        return storage.getFavorites().contains(task.id)
    }
    
    private func updateButtonUI() {
        let isFav = isFavorite()
        
        let imageName = isFav ? "bookmark.fill" : "bookmark"
        saveButton.setImage(UIImage(systemName: imageName), for: .normal)
    }
    
    // MARK: - Action
    @objc private func didTapSave() {
        var favorites = storage.getFavorites()
        
        if favorites.contains(task.id) {
            favorites.removeAll { $0 == task.id }
        } else {
            favorites.append(task.id)
        }
        
        storage.saveFavorites(favorites)
        
        updateButtonUI()
    }
}
