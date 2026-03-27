//
//  TaskCell.swift
//  TaskExplorerKnC
//
//  Created by Siti Hafsah on 26/03/26.
//

import Foundation
import UIKit
import SnapKit

final class TaskCell: UITableViewCell {
    
    static let id = "TaskCell"
    
    private let titleLabel = UILabel()
    private let statusLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private func setup() {
        contentView.addSubview(statusLabel)
        contentView.addSubview(titleLabel)
        
        // status di kiri
        statusLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(16)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(24) // biar fix & rapi
        }
        
        // title di kanan (flexible)
        titleLabel.snp.makeConstraints {
            $0.left.equalTo(statusLabel.snp.right).offset(12)
            $0.top.equalToSuperview().offset(12)
            $0.bottom.equalToSuperview().offset(-12)
            $0.right.equalToSuperview().offset(-16)
        }
        
        // penting biar title panjang bisa wrap
        titleLabel.numberOfLines = 0
    }
    
    func configure(task: Task, isCompleted: Bool) {
        
        // status tetap di kiri
        statusLabel.text = isCompleted ? "✔️" : "❌"
        
        // title TIDAK PERNAH dicoret
        titleLabel.attributedText = nil
        titleLabel.text = task.title
        titleLabel.textColor = .black
    }
}
