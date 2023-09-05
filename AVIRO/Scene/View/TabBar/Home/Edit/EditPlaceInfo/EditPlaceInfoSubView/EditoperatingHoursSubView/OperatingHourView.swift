//
//  OperatingHoursView.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/09/05.
//

import UIKit

final class OperatingHourView: UIView {
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
    
    private var tapGesture = UITapGestureRecognizer()
    
    var tappedOperatingHoursView: ((String?, String?) -> Void)?
    
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
        tappedOperatingHoursView?(operatinghourLabel.text, breakTimeLabel.text)
    }
    
    func dataBinding(day: String, operatingHours: String?, breakTime: String?) {
        dayLabel.text = day
        
        if let operatingHours = operatingHours {
            operatinghourLabel.text = operatingHours
            operatinghourLabel.textColor = .gray0
        } else {
            operatinghourLabel.text = "입력해주세요"
            operatinghourLabel.textColor = .gray2
        }
        
        if let breakTime = breakTime {
            breakTimeLabel.text = "[휴식시간] " + breakTime
        } else {
            breakTimeLabel.isHidden = true
        }
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
        
        self.heightAnchor.constraint(equalToConstant: totalHeight).isActive = true
    }
    
    private func whenHasBreakTimeMakeViewHeight() {
        let operationHeight = operatinghourLabel.frame.height
        let breackTimeHeight = breakTimeLabel.frame.height
        
        // 15 + 15 + 5
        let inset: CGFloat = 35
        
        let totalHeight = operationHeight + breackTimeHeight + inset
        
        self.heightAnchor.constraint(equalToConstant: totalHeight).isActive = true
    }
}
