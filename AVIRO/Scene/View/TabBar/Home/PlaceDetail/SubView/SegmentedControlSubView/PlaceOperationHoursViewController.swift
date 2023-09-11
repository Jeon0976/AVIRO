//
//  PlaceOperationHoursViewController.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/09/11.
//

import UIKit

final class PlaceOperationHoursViewController: UIViewController {
    
    private lazy var operationHoursView = OperationHoursView()

    var model: [EditOperationHoursModel]?
    
    init(_ model: [EditOperationHoursModel] = [EditOperationHoursModel]()) {
        super.init(nibName: nil, bundle: nil)

        self.model = model
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        setupAttribute()
        setupDataBinding(model)
    }
    
    private func setupLayout() {
        [
            operationHoursView
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            operationHoursView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            operationHoursView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
            operationHoursView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16)
        ])
    }
    
    private func setupAttribute() {
        self.view.backgroundColor = .black.withAlphaComponent(0.4)
        
        operationHoursView.cancelTapped = { [weak self] in
            self?.dismiss(animated: false)
        }
    }
    
    private func setupDataBinding(_ model: [EditOperationHoursModel]?) {
        guard let model = model else { return }
        operationHoursView.setupData(model)
    }
}
