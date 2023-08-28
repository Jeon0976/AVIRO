//
//  EditLocationDetailTextView.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/08/27.
//

import UIKit

final class EditLocationDetailTextView: UIView {
    
    private lazy var addressTextField: EnrollField = {
        let textField = EnrollField()
        
        let placeHolder = "예) 정자일로 195, 백현동 532"
        textField.makePlaceHolder(placeHolder)
        textField.addLeftImage()
        textField.delegate = self
        textField.addRightCancelButton()
        textField.rightButtonHidden = true
        
        return textField
    }()
    
    private lazy var subLabel: UILabel = {
        let label = UILabel()
        
        label.text = "도로명이나 지역명을 이용해서 검색해보세요."
        label.textColor = .gray1
        label.font = .systemFont(ofSize: 15, weight: .medium)
        
        return label
    }()
    
    private lazy var addressTableView: UITableView = {
        let tableView = UITableView()
        
        tableView.register(
            EditLocationDetailTextTableViewCell.self,
            forCellReuseIdentifier: EditLocationDetailTextTableViewCell.identifier
        )
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = .gray5
        tableView.estimatedRowHeight = 150
        tableView.rowHeight = UITableView.automaticDimension
        
        return tableView
    }()
    
    var searchAddress: ((String) -> Void)?
    
    private var searchTimer: DispatchWorkItem?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func makeLayout() {
        [
            addressTextField,
            addressTableView,
            subLabel
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            addressTextField.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            addressTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            addressTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            
            subLabel.topAnchor.constraint(equalTo: addressTextField.bottomAnchor, constant: 20),
            subLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            addressTableView.topAnchor.constraint(equalTo: addressTextField.bottomAnchor),
            addressTableView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            addressTableView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            addressTableView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
        subLabel.isHidden = false
        addressTableView.isHidden = true
    }
    
    func setTableViewDataSource(_ dataSource: UITableViewDataSource) {
        addressTableView.dataSource = dataSource
    }
    
    func setTableViewDelegate(_ delegate: UITableViewDelegate) {
        addressTableView.delegate = delegate
    }
    
    private func chagedView() {
        subLabel.isHidden = true
        addressTableView.isHidden = false
    }
    
    func addressTableViewReloadData() {
        addressTableView.reloadData()
    }
}

extension EditLocationDetailTextView: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        chagedView()
        
        addressTextField.rightButtonHidden = false
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        
        searchTimer?.cancel()

        // 새로운 타이머 작업을 생성합니다.
        let task = DispatchWorkItem { [weak self] in
            if let text = textField.text {
                if text != "" {
                    guard let text = textField.text else { return }
                    
                    self?.searchAddress?(text)
                }
            }
        }

        // 타이머 작업을 저장합니다.
        searchTimer = task

        // 0.5초 후에 작업을 실행합니다.
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: task)
    }
}
