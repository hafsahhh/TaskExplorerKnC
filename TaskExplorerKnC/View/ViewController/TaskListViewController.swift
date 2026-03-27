//
//  TaskListViewController.swift
//  TaskExplorerKnC
//
//  Created by Siti Hafsah on 26/03/26.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class TaskListViewController: UIViewController {
    
    private let tableView = UITableView()
    private let searchBar = UISearchBar()
    
    // Bottom Filter
    private let stackView = UIStackView()
    private let allButton = UIButton()
    private let completedButton = UIButton()
    private let notCompletedButton = UIButton()
    private let favoriteButton = UIButton()
    private let spinner = UIActivityIndicatorView(style: .large)
    
    private let viewModel: TaskListViewModel
    private let disposeBag = DisposeBag()
    
    init(viewModel: TaskListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        title = "Tasks"
        
        view.backgroundColor = .white
        
        setupUI()
        setupFilterBar()
        bind()
        updateFilterUI(selected: allButton)
        viewModel.fetchTasks()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        reloadDataWithLoading()
    }
    
    private func reloadDataWithLoading() {
        viewModel.isLoading.accept(true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            self?.viewModel.refreshFavorites()
            self?.viewModel.isLoading.accept(false)
        }
    }
    
    // MARK: - UI
    
    private func setupUI() {
        view.addSubview(searchBar)
        view.addSubview(tableView)
        view.addSubview(spinner)

        spinner.hidesWhenStopped = true
        
        spinner.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        searchBar.placeholder = "Search tasks..."
        
        searchBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.left.right.equalToSuperview()
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom)
            $0.left.right.equalToSuperview()
        }
        
        tableView.register(TaskCell.self, forCellReuseIdentifier: TaskCell.id)
    }
    
    private func setupFilterBar() {
        view.addSubview(stackView)
        
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        
        let buttons = [
            (allButton, "All"),
            (completedButton, "Done"),
            (notCompletedButton, "Not Done"),
            (favoriteButton, "Favorite")
        ]
        
        buttons.forEach { button, title in
            button.setTitle(title, for: .normal)
            button.setTitleColor(.systemBlue, for: .normal)
            button.layer.borderColor = UIColor.systemBlue.cgColor
            button.layer.borderWidth = 1
            button.layer.cornerRadius = 8
            stackView.addArrangedSubview(button)
        }
        
        stackView.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(12)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-8)
            $0.height.equalTo(50)
        }
        
        tableView.snp.makeConstraints {
            $0.bottom.equalTo(stackView.snp.top).offset(-8)
        }
    }
    
    // MARK: - Bind
    
    private func bind() {
        
        viewModel.isLoading
            .bind(onNext: { [weak self] loading in
                if loading {
                    self?.spinner.startAnimating()
                } else {
                    self?.spinner.stopAnimating()
                }
            })
            .disposed(by: disposeBag)
        
        // Table binding
        viewModel.tasks
            .bind(to: tableView.rx.items(
                cellIdentifier: TaskCell.id,
                cellType: TaskCell.self
            )) { [weak self] _, task, cell in
                
                guard let self = self else { return }
                cell.configure(task: task, isCompleted: self.viewModel.isCompleted(task))
            }
            .disposed(by: disposeBag)
        
        // Navigation
        tableView.rx.modelSelected(Task.self)
            .subscribe(onNext: { [weak self] task in
                let detailVC = TaskDetailViewController(task: task)
                self?.navigationItem.backButtonTitle = "back"
                self?.navigationController?.pushViewController(detailVC, animated: true)
            })
            .disposed(by: disposeBag)
        
        // Search
        searchBar.rx.text.orEmpty
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] query in
                self?.viewModel.search(query: query)
            })
            .disposed(by: disposeBag)
        
        // Filter buttons
        allButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.viewModel.setFilter(.all)
                self?.updateFilterUI(selected: self?.allButton ?? UIButton())
            })
            .disposed(by: disposeBag)

        completedButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.viewModel.setFilter(.completed)
                self?.updateFilterUI(selected: self?.completedButton ?? UIButton())
            })
            .disposed(by: disposeBag)

        notCompletedButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.viewModel.setFilter(.notCompleted)
                self?.updateFilterUI(selected: self?.notCompletedButton ?? UIButton())
            })
            .disposed(by: disposeBag)

        favoriteButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.viewModel.setFilter(.favorite)
                self?.updateFilterUI(selected: self?.favoriteButton ?? UIButton())
            })
            .disposed(by: disposeBag)
        
        // Error
        viewModel.error
            .subscribe(onNext: { message in
                print("Error:", message)
            })
            .disposed(by: disposeBag)
    }
    
    private func updateFilterUI(selected: UIButton) {
        let buttons = [allButton, completedButton, notCompletedButton, favoriteButton]
        
        buttons.forEach { button in
            if button == selected {
                button.backgroundColor = .systemBlue
                button.setTitleColor(.white, for: .normal)
            } else {
                button.backgroundColor = .clear
                button.setTitleColor(.systemBlue, for: .normal)
            }
        }
    }
}
