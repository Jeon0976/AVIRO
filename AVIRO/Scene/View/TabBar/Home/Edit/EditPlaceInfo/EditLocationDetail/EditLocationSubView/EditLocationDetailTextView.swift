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
        
        
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
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
    }
    
    func setTableViewDataSource(_ dataSource: UITableViewDataSource) {
        addressTableView.dataSource = dataSource
    }
}

extension EditLocationDetailTextView: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        addressTextField.rightButtonHidden = false
        
    }
}
