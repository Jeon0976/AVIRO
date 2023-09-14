//
//  OperationHourView.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/09/11.
//

import UIKit

final class OperationHourView: UIView {
    private lazy var dayLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 15, weight: .medium)
        label.textColor = .gray1
        
        return label
    }()
    
    private lazy var operatingHourLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 15, weight: .medium)
        label.textColor = .gray1
        
        return label
    }()
    
    private lazy var breakTimeLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 15, weight: .medium)
        label.textColor = .gray3
        
        return label
    }()
    
    private var viewHeight: NSLayoutConstraint?
    
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
            dayLabel,
            operatingHourLabel,
            breakTimeLabel
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            dayLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            dayLabel.topAnchor.constraint(equalTo: self.topAnchor),
            
            operatingHourLabel.leadingAnchor.constraint(equalTo: dayLabel.trailingAnchor, constant: 5),
            operatingHourLabel.topAnchor.constraint(equalTo: self.topAnchor),
            
            breakTimeLabel.topAnchor.constraint(equalTo: operatingHourLabel.bottomAnchor, constant: 9),
            breakTimeLabel.leadingAnchor.constraint(equalTo: operatingHourLabel.leadingAnchor)
        ])
    }
    
    private func setupAttribute() {
        self.backgroundColor = .gray7
    }
    
    func dataBinding(_ model: EditOperationHoursModel) {
        dayLabel.text = model.day.rawValue
        
        if model.operatingHours != "정보 없음" {
            operatingHourLabel.text = model.operatingHours
            operatingHourLabel.textColor = .gray1
        } else {
            operatingHourLabel.text = "정보없음"
            operatingHourLabel.textColor = .gray3
        }
        
        if model.breakTime != "" {
            breakTimeLabel.text = model.breakTime + " 휴식시간"
            breakTimeLabel.isHidden = false
        } else {
            breakTimeLabel.text = model.breakTime
            breakTimeLabel.isHidden = true
        }
        
        if model.isToday {
            isToday()
        } else {
            isNotToday()
        }
    }
    
    private func isToday() {
        dayLabel.font = .systemFont(ofSize: 15, weight: .semibold)
        dayLabel.textColor = .main
        
        operatingHourLabel.font = .systemFont(ofSize: 15, weight: .semibold)
        operatingHourLabel.textColor = .main

        breakTimeLabel.font = .systemFont(ofSize: 15, weight: .semibold)
        breakTimeLabel.textColor = .main
    }
    
    private func isNotToday() {
        dayLabel.font = .systemFont(ofSize: 15, weight: .medium)
        dayLabel.textColor = .gray1

        operatingHourLabel.font = .systemFont(ofSize: 15, weight: .medium)
        breakTimeLabel.font = .systemFont(ofSize: 15, weight: .medium)
        breakTimeLabel.textColor = .gray3
    }
    
    private func setupViewHeight() {
        if breakTimeLabel.isHidden {
            whenNoBreakTimeMakeViewHeight()
        } else {
            whenHasBreakTimeMakeViewHeight()
        }
    }
    
    private func whenNoBreakTimeMakeViewHeight() {
        let operationHeight = operatingHourLabel.frame.height
        
        let totalHeight = operationHeight
        
        viewHeight?.constant = totalHeight
    }
    
    private func whenHasBreakTimeMakeViewHeight() {
        let operationHeight = operatingHourLabel.frame.height
        let breackTimeHeight = breakTimeLabel.frame.height
        
        let inset: CGFloat = 9
        
        let totalHeight = operationHeight + breackTimeHeight + inset
        
        viewHeight?.constant = totalHeight
    }
    
}
