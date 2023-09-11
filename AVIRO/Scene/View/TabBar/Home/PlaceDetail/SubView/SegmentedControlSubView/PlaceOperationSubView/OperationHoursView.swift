//
//  OperationHoursView.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/09/11.
//

import UIKit

final class OperationHoursView: UIView {
    private lazy var mainTitle: UILabel = {
        let label = UILabel()
        
        label.text = "영업 시간"
        label.textColor = .gray0
        label.font = .systemFont(ofSize: 20, weight: .bold)
        
        return label
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        
        button.setImage(UIImage(named: "X-Circle"), for: .normal)
        button.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var monView = OperationHourView()
    private lazy var tueView = OperationHourView()
    private lazy var wedView = OperationHourView()
    private lazy var thuView = OperationHourView()
    private lazy var friView = OperationHourView()
    private lazy var satView = OperationHourView()
    private lazy var sunView = OperationHourView()
    
    private var viewHeight: NSLayoutConstraint?
    
    var cancelTapped: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
        setupAttribute()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
     
        setupViewHeight()
    }
    
    private func setupLayout() {
        self.viewHeight = heightAnchor.constraint(equalToConstant: 0)
        viewHeight?.isActive = true
        
        [
            mainTitle,
            cancelButton,
            monView,
            tueView,
            wedView,
            thuView,
            friView,
            satView,
            sunView
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            mainTitle.topAnchor.constraint(equalTo: self.topAnchor, constant: 15),
            mainTitle.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            
            cancelButton.centerYAnchor.constraint(equalTo: mainTitle.centerYAnchor),
            cancelButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            
            monView.topAnchor.constraint(equalTo: mainTitle.bottomAnchor, constant: 15),
            monView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            monView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            
            tueView.topAnchor.constraint(equalTo: monView.bottomAnchor, constant: 9),
            tueView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            tueView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            
            wedView.topAnchor.constraint(equalTo: tueView.bottomAnchor, constant: 9),
            wedView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            wedView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            
            thuView.topAnchor.constraint(equalTo: wedView.bottomAnchor, constant: 9),
            thuView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            thuView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            
            friView.topAnchor.constraint(equalTo: thuView.bottomAnchor, constant: 9),
            friView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            friView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            
            satView.topAnchor.constraint(equalTo: friView.bottomAnchor, constant: 9),
            satView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            satView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            
            sunView.topAnchor.constraint(equalTo: satView.bottomAnchor, constant: 9),
            sunView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            sunView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16)
        ])
    }
    
    private func setupAttribute() {
        self.backgroundColor = .gray7
        self.layer.cornerRadius = 12
    }
    
    func setupData(_ model: [EditOperationHoursModel]) {
        guard model.count == 7 else { return }
        
        monView.dataBinding(model[0])
        tueView.dataBinding(model[1])
        wedView.dataBinding(model[2])
        thuView.dataBinding(model[3])
        friView.dataBinding(model[4])
        satView.dataBinding(model[5])
        sunView.dataBinding(model[6])
    }
    
    private func setupViewHeight() {
        let mainTitleHeight = mainTitle.frame.height
        let monHeight = monView.frame.height
        let tueHeight = tueView.frame.height
        let wedHeight = wedView.frame.height
        let thuHeight = thuView.frame.height
        let friHeight = friView.frame.height
        let satHeight = satView.frame.height
        let sunHeight = sunView.frame.height
        
        // 15 15 15 + 9 9 9 9 9 9
        let inset: CGFloat = 99
        
        let totalHeight = mainTitleHeight + monHeight + tueHeight + wedHeight + thuHeight + friHeight + satHeight + sunHeight + inset
        
        self.viewHeight?.constant = totalHeight
    }
     
    @objc private func cancelButtonTapped() {
        cancelTapped?()
    }
}
