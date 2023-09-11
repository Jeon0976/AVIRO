//
//  EdiOperatingHoursView.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/08/25.
//

import UIKit

final class EditOperatingHoursView: UIView {
    private lazy var operatingHourLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = .gray0
        label.text = "영업시간"
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        
        return label
    }()

    private var operatingHourViews: [EditOperatingHourView] = []
    
    var openChangebleOperationHourView: ((EditOperationHoursModel) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeLayout()
        makeAttribute()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    private func makeLayout() {
        self.addSubview(operatingHourLabel)
        operatingHourLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            operatingHourLabel.topAnchor.constraint(equalTo: self.topAnchor),
            operatingHourLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor)
        ])
        
        var lastView: EditOperatingHourView?
        
        for _ in 0..<7 {
            let cellView = EditOperatingHourView()
            
            cellView.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(cellView)
            
            NSLayoutConstraint.activate([
                cellView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                cellView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                
                lastView == nil ?
                cellView.topAnchor.constraint(equalTo: operatingHourLabel.bottomAnchor, constant: 15) :
                cellView.topAnchor.constraint(equalTo: lastView!.bottomAnchor, constant: 15)
            ])
            
            cellView.tappedOperatingHoursView = { [weak self] model in
                self?.openChangebleOperationHourView?(model)
            }
            
            operatingHourViews.append(cellView)
            
            lastView = cellView
        }
    }
    
    private func makeAttribute() {
        self.backgroundColor = .gray6
    }
    
    func dataBinding(_ operatingHourModels: [EditOperationHoursModel]) {
        if operatingHourModels.count == operatingHourViews.count {
            for (index, model) in operatingHourModels.enumerated() {
                operatingHourViews[index].dataBinding(day: model.day, operatingHours: model.operatingHours, breakTime: model.breakTime)
            }
        }
    }
    
    func editOperationHour(_ model: EditOperationHoursModel) {
        operatingHourViews.forEach {
            if $0.checkDay() == model.day {
                $0.changeData(
                    operatingHours: model.operatingHours,
                    breakTime: model.breakTime
                )
            }
        }
    }
}
