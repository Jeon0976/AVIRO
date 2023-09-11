//
//  OperatingHoursView.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/09/05.
//

import UIKit

final class EditOperatingHourView: UIView {
    private lazy var dayLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = .gray0
        label.font = .systemFont(ofSize: 15, weight: .medium)
        
        return label
    }()
    
    private lazy var operatinghourLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 15, weight: .medium)
        
        return label
    }()
    
    private lazy var breakTimeLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 15, weight: .medium)
        label.textColor = .gray2
        
        return label
    }()
    
    private var viewHeight: NSLayoutConstraint?
    
    private var tapGesture = UITapGestureRecognizer()
    
    var tappedOperatingHoursView: ((EditOperationHoursModel) -> Void)?
    
    private var operationText = ""
    private var breakTimeText = ""
    private var isToday: Bool!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeLayout()
        makeAttribute()
        makeGesture()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        makeViewHeight()
    }
    
    private func makeLayout() {
        viewHeight = heightAnchor.constraint(equalToConstant: 70)
        viewHeight?.isActive = true
        
        [
            dayLabel,
            operatinghourLabel,
            breakTimeLabel
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            dayLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 15),
            dayLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            
            operatinghourLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 15),
            operatinghourLabel.leadingAnchor.constraint(equalTo: dayLabel.trailingAnchor, constant: 30),
            
            breakTimeLabel.topAnchor.constraint(equalTo: operatinghourLabel.bottomAnchor, constant: 5),
            breakTimeLabel.leadingAnchor.constraint(equalTo: operatinghourLabel.leadingAnchor)
        ])
    }
    
    private func makeAttribute() {
        self.backgroundColor = .gray7
        self.layer.cornerRadius = 10
    }
    
    private func makeGesture() {
        tapGesture.addTarget(self, action: #selector(cellTapped))
        
        self.addGestureRecognizer(tapGesture)
    }
    
    @objc private func cellTapped() {
        guard let day = dayLabel.text else { return }
        
        let operationHourModel = EditOperationHoursModel(
            day: day,
            operatingHours: operationText,
            breakTime: breakTimeText,
            isToday: isToday
        )
        
        tappedOperatingHoursView?(operationHourModel)
    }
    
    func dataBinding(day: String, operatingHours: String, breakTime: String, isToday: Bool) {
        dayLabel.text = day + "요일"
        self.isToday = isToday
        operationText = operatingHours
        breakTimeText = breakTime
        
        if operatingHours != "정보 없음" {
            operatinghourLabel.text = operatingHours
            operatinghourLabel.textColor = .gray0
        } else {
            operatinghourLabel.text = "입력해주세요"
            operatinghourLabel.textColor = .gray2
        }
        
        if breakTime != "" {
            breakTimeLabel.text = "[휴식시간] " + breakTime
            breakTimeLabel.isHidden = false
        } else {
            breakTimeLabel.text = breakTime
            breakTimeLabel.isHidden = true
        }
    }
    
    func changeData(operatingHours: String, breakTime: String) {
        operationText = operatingHours
        breakTimeText = breakTime
        
        if operatingHours != "정보 없음" {
            operatinghourLabel.text = operatingHours
            operatinghourLabel.textColor = .gray0
        } else {
            operatinghourLabel.text = "입력해주세요"
            operatinghourLabel.textColor = .gray2
        }
        
        if breakTime != "" {
            breakTimeLabel.text = "[휴식시간] " + breakTime
            breakTimeLabel.isHidden = false
        } else {
            breakTimeLabel.text = breakTime
            breakTimeLabel.isHidden = true
        }
        
        makeViewHeight()
    }
    
    private func makeViewHeight() {
        if breakTimeLabel.isHidden {
            whenNoBreakTimeMakeViewHeight()
        } else {
            whenHasBreakTimeMakeViewHeight()
        }
    }
    
    private func whenNoBreakTimeMakeViewHeight() {
        let operationHeight = operatinghourLabel.frame.height
        
        // 15 + 15
        let inset: CGFloat = 30
        
        let totalHeight = operationHeight + inset
        
        viewHeight?.constant = totalHeight
    }
    
    private func whenHasBreakTimeMakeViewHeight() {
        let operationHeight = operatinghourLabel.frame.height
        let breackTimeHeight = breakTimeLabel.frame.height
        
        // 15 + 15 + 5
        let inset: CGFloat = 35
        
        let totalHeight = operationHeight + breackTimeHeight + inset
        
        viewHeight?.constant = totalHeight
    }
    
    func checkDay() -> String {
        guard let day = dayLabel.text else { return "" }
        return day
    }
}
