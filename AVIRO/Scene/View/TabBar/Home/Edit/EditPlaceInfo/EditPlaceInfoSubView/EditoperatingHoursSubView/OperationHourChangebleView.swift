//
//  OperationHourChangebleView.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/09/06.
//

import UIKit

final class OperationHourChangebleView: UIView {
    private lazy var operatingHoursButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("영업일", for: .normal)
        button.setTitleColor(.gray3, for: .normal)
        button.setTitleColor(.main, for: .selected)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        
        button.setImage(UIImage(named: "RadioCircle"), for: .normal)
        button.setImage(UIImage(named: "RadioCircleClicked"), for: .selected)
        
        button.semanticContentAttribute = .forceLeftToRight
        button.imageEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: 2)
        button.titleEdgeInsets = .init(top: 0, left: 2, bottom: 0, right: 0)
        
        button.addTarget(self, action: #selector(operatingHourButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var dayOffButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("휴무일", for: .normal)
        button.setTitleColor(.gray3, for: .normal)
        button.setTitleColor(.main, for: .selected)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        
        button.setImage(UIImage(named: "RadioCircle"), for: .normal)
        button.setImage(UIImage(named: "RadioCircleClicked"), for: .selected)
        
        button.semanticContentAttribute = .forceLeftToRight
        button.imageEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: 2)
        button.titleEdgeInsets = .init(top: 0, left: 2, bottom: 0, right: 0)
        
        button.addTarget(self, action: #selector(dayOffButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        
        button.setImage(UIImage(named: "X-Circle"), for: .normal)
        button.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var separatedLine1: UIView = {
        let view = UIView()
        
        view.backgroundColor = .gray5
        
        return view
    }()
    
    private lazy var operatingHoursLabel: UILabel = {
        let label = UILabel()
        
        label.text = "영업 시간"
        label.textColor = .gray0
        label.font = .systemFont(ofSize: 17, weight: .bold)
        
        return label
    }()
    
    private lazy var open24hoursButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("24시간", for: .normal)

        button.setTitleColor(.gray0, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        
        button.setImage(UIImage(named: "EmptyFrame"), for: .normal)
        button.setImage(UIImage(named: "Frame"), for: .selected)
        
        button.semanticContentAttribute = .forceLeftToRight
        button.imageEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: 7)
        button.titleEdgeInsets = .init(top: 0, left: 7, bottom: 0, right: 0)
        
        button.addTarget(self, action: #selector(open24hoursButtonTapped), for: .touchUpInside)
                
        return button
    }()
    
    private lazy var operationTimeOpen: TimeChangebleView = {
        let view = TimeChangebleView()
        
        view.isChangedTime = { [weak self] in
            self?.whenAddTimeLabelCheckIsEnabledEditButton()
        }
        
        return view
    }()
    
    private lazy var operationTimeClosed: TimeChangebleView = {
        let view = TimeChangebleView()
        
        view.isChangedTime = { [weak self] in
            self?.whenAddTimeLabelCheckIsEnabledEditButton()
        }
        
        return view
    }()
    
    private lazy var openClosedLine1: UIView = {
        let view = UIView()
        
        view.backgroundColor = .gray0
        
        return view
    }()
    
    private lazy var separatedLine2: UIView = {
        let view = UIView()
        
        view.backgroundColor = .gray5
        
        return view
    }()
    
    private lazy var breakTimeLabel: UILabel = {
        let label = UILabel()
        
        label.text = "휴식 시간"
        label.textColor = .gray0
        label.font = .systemFont(ofSize: 17, weight: .bold)
        
        return label
    }()
    
    private lazy var breakTimeOpen: TimeChangebleView = {
        let view = TimeChangebleView()
        
        view.isChangedTime = { [weak self] in
            self?.whenAddTimeLabelCheckIsEnabledEditButton()
        }
        
        return view
    }()
    
    private lazy var breakTimeClosed: TimeChangebleView = {
        let view = TimeChangebleView()
        
        view.isChangedTime = { [weak self] in
            self?.whenAddTimeLabelCheckIsEnabledEditButton()
        }
        
        return view
    }()
    
    private lazy var openClosedLine2: UIView = {
        let view = UIView()
        
        view.backgroundColor = .gray0
        
        return view
    }()
    
    private lazy var separatedLine3: UIView = {
        let view = UIView()
        
        view.backgroundColor = .gray5
        
        return view
    }()
    
    private lazy var editButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("수정하기", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        button.setTitleColor(.gray2, for: .normal)
        button.backgroundColor = .gray6
        button.contentEdgeInsets = .init(top: 15, left: 25, bottom: 15, right: 25)
        
        button.layer.cornerRadius = 27
        
        button.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    private var viewHeightConstraint: NSLayoutConstraint?
    
    private var day = ""
    private var initDayOff = ""
    private var initOperationOpen = ""
    private var initOperationClosed = ""
    private var initBreakOpen = ""
    private var initBreakClosed = ""
    
    var cancelTapped: (() -> Void)?
    var editTapped: ((EditOperationHoursModel) -> Void)?
    
    private var editButtonIsEnabled = false {
        didSet {
            isEnabledEditButton(editButtonIsEnabled)
        }
    }
    
    private func isEnabledEditButton(_ enabled: Bool) {
        if enabled {
            editButton.backgroundColor = .main
            editButton.setTitleColor(.gray7, for: .normal)
        } else {
            editButton.backgroundColor = .gray6
            editButton.setTitleColor(.gray2, for: .normal)
        }
    }
    
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
        
        makeViewHeight()
    }
    
    private func makeLayout() {
        viewHeightConstraint = self.heightAnchor.constraint(equalToConstant: 410)
        viewHeightConstraint?.isActive = true
        
        [
            operatingHoursButton,
            dayOffButton,
            cancelButton,
            separatedLine1,
            
            operatingHoursLabel,
            open24hoursButton,
            operationTimeOpen,
            operationTimeClosed,
            openClosedLine1,
            
            separatedLine2,
            breakTimeLabel,
            breakTimeOpen,
            breakTimeClosed,
            openClosedLine2,
            
            separatedLine3,
            editButton
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            operatingHoursButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            operatingHoursButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            operatingHoursButton.widthAnchor.constraint(equalToConstant: 70),
            
            dayOffButton.topAnchor.constraint(equalTo: operatingHoursButton.topAnchor),
            dayOffButton.leadingAnchor.constraint(equalTo: operatingHoursButton.trailingAnchor, constant: 10),
            dayOffButton.widthAnchor.constraint(equalToConstant: 70),
            
            cancelButton.centerYAnchor.constraint(equalTo: operatingHoursButton.centerYAnchor),
            cancelButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            
            separatedLine1.topAnchor.constraint(equalTo: operatingHoursButton.bottomAnchor, constant: 20),
            separatedLine1.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            separatedLine1.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1, constant: -32),
            separatedLine1.heightAnchor.constraint(equalToConstant: 1),
            
            operatingHoursLabel.topAnchor.constraint(equalTo: separatedLine1.bottomAnchor, constant: 20),
            operatingHoursLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            
            open24hoursButton.topAnchor.constraint(equalTo: operatingHoursLabel.topAnchor),
            open24hoursButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            open24hoursButton.widthAnchor.constraint(equalToConstant: 80),
            
            operationTimeOpen.topAnchor.constraint(equalTo: operatingHoursLabel.bottomAnchor, constant: 20),
            operationTimeOpen.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            operationTimeOpen.trailingAnchor.constraint(equalTo: openClosedLine1.leadingAnchor, constant: -9),
            
            openClosedLine1.centerYAnchor.constraint(equalTo: operationTimeOpen.centerYAnchor),
            openClosedLine1.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            openClosedLine1.widthAnchor.constraint(equalToConstant: 12),
            openClosedLine1.heightAnchor.constraint(equalToConstant: 2),
            
            operationTimeClosed.topAnchor.constraint(equalTo: operationTimeOpen.topAnchor),
            operationTimeClosed.leadingAnchor.constraint(equalTo: openClosedLine1.trailingAnchor, constant: 9),
            operationTimeClosed.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            
            separatedLine2.topAnchor.constraint(equalTo: operationTimeOpen.bottomAnchor, constant: 20),
            separatedLine2.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            separatedLine2.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1, constant: -32),
            separatedLine2.heightAnchor.constraint(equalToConstant: 1),
            
            breakTimeLabel.topAnchor.constraint(equalTo: separatedLine2.bottomAnchor, constant: 20),
            breakTimeLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            
            breakTimeOpen.topAnchor.constraint(equalTo: breakTimeLabel.bottomAnchor, constant: 20),
            breakTimeOpen.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            breakTimeOpen.trailingAnchor.constraint(equalTo: openClosedLine2.leadingAnchor, constant: -9),
            
            openClosedLine2.centerYAnchor.constraint(equalTo: breakTimeOpen.centerYAnchor),
            openClosedLine2.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            openClosedLine2.widthAnchor.constraint(equalToConstant: 12),
            openClosedLine2.heightAnchor.constraint(equalToConstant: 2),
            
            breakTimeClosed.topAnchor.constraint(equalTo: breakTimeOpen.topAnchor),
            breakTimeClosed.leadingAnchor.constraint(equalTo: openClosedLine1.trailingAnchor, constant: 9),
            breakTimeClosed.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            
            separatedLine3.topAnchor.constraint(equalTo: breakTimeOpen.bottomAnchor, constant: 20),
            separatedLine3.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            separatedLine3.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1, constant: -32),
            separatedLine3.heightAnchor.constraint(equalToConstant: 1),
            
            editButton.topAnchor.constraint(equalTo: separatedLine3.bottomAnchor, constant: 20),
            editButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            editButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            editButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func makeAttribute() {
        self.layer.cornerRadius = 12
        self.backgroundColor = .gray7
    }
    
    private func makeViewHeight() {
        // inset 20, 20, separatedLine 1
        let topHeight = cancelButton.frame.height + 20 + 20 + 1
        // inset 20 20 20, separatedLine 1
        let operationHeight = operatingHoursLabel.frame.height + operationTimeOpen.frame.height + 20 + 20 + 20 + 1
        let breakHegiht = breakTimeLabel.frame.height + breakTimeOpen.frame.height + 20 + 20 + 20 + 1
        // inset 20, 20
        let bottomHeight = editButton.frame.height + 20 + 20
        
        let totalHeight = topHeight + operationHeight + breakHegiht + bottomHeight
        
        viewHeightConstraint?.constant = totalHeight
    }
    
    func makeBindingData(_ operationHoursModel: EditOperationHoursModel) {
        day = operationHoursModel.day
        editButtonIsEnabled = false
        open24hoursButton.isSelected = false
        initDayOff = ""
        
        if operationHoursModel.operatingHours == "휴무" {
            initDayOff = operationHoursModel.operatingHours
            initOperationOpen = "시간 선택"
            initOperationClosed = "시간 선택"
            initBreakOpen = "시간 선택"
            initBreakClosed = "시간 선택"
            
            dayOffButton.isSelected = true
            operatingHoursButton.isSelected = false
            
            operationTimeOpen.makeLabelText("시간 선택")
            operationTimeClosed.makeLabelText("시간 선택")
            breakTimeOpen.makeLabelText("시간 선택")
            breakTimeClosed.makeLabelText("시간 선택")
        } else if operationHoursModel.operatingHours == "정보 없음" {
            initOperationOpen = "시간 선택"
            initOperationClosed = "시간 선택"
            
            dayOffButton.isSelected = false
            operatingHoursButton.isSelected = true
            
            operationTimeOpen.makeLabelText("시간 선택")
            operationTimeClosed.makeLabelText("시간 선택")
        } else {
            dayOffButton.isSelected = false
            operatingHoursButton.isSelected = true
            let times = operationHoursModel.operatingHours.split(separator: "-")
            var open00 = false
            var closed24 = false
            
            if let openTime = times.first {
                let open = String(openTime)
                operationTimeOpen.makeLabelText(open)
                initOperationOpen = open
                if open == "00:00" {
                    open00 = true
                }
            }
            
            if let closedTime = times.last {
                let closed = String(closedTime)
                operationTimeClosed.makeLabelText(closed)
                initOperationClosed = closed
                if closed == "24:00" {
                    closed24 = true
                }
            }
   
            if open00 && closed24 {
                open24hoursButton.isSelected = true
                operationTimeOpen.isEnabledButton(false)
                operationTimeClosed.isEnabledButton(false)
            }
        }
        
        if operationHoursModel.breakTime != "" {
            let breakTimes = operationHoursModel.breakTime
            let times = breakTimes.split(separator: "-")
            
            if let openTime = times.first {
                let open = String(openTime)
                breakTimeOpen.makeLabelText(open)
                initBreakOpen = open
            }
            
            if let closedTime = times.last {
                let closed = String(closedTime)
                breakTimeClosed.makeLabelText(closed)
                initBreakClosed = closed
            }
        } else {
            initBreakOpen = "시간 선택"
            initBreakClosed = "시간 선택"
            
            breakTimeOpen.makeLabelText("시간 선택")
            breakTimeClosed.makeLabelText("시간 선택")
        }
    }
    
    @objc private func operatingHourButtonTapped() {
        if !operatingHoursButton.isSelected {
            operatingHoursButton.isSelected.toggle()
            dayOffButton.isSelected.toggle()
            operationTimeOpen.isEnabledButton(true)
            operationTimeClosed.isEnabledButton(true)
            breakTimeOpen.isEnabledButton(true)
            breakTimeClosed.isEnabledButton(true)
            
            editButtonIsEnabled = false
        }
    }
    
    @objc private func dayOffButtonTapped() {
        if !dayOffButton.isSelected {
            operatingHoursButton.isSelected.toggle()
            dayOffButton.isSelected.toggle()
            open24hoursButton.isSelected = false
            
            operationTimeOpen.makeLabelText("시간 선택")
            operationTimeClosed.makeLabelText("시간 선택")
            breakTimeOpen.makeLabelText("시간 선택")
            breakTimeClosed.makeLabelText("시간 선택")
            operationTimeOpen.isEnabledButton(false)
            operationTimeClosed.isEnabledButton(false)
            breakTimeOpen.isEnabledButton(false)
            breakTimeClosed.isEnabledButton(false)
            
            if initDayOff != "휴무" {
                editButtonIsEnabled = true
            }
        }
    }
    
    @objc private func cancelButtonTapped() {
        cancelTapped?()
    }
    
    @objc private func open24hoursButtonTapped() {
        if !dayOffButton.isSelected {
            open24hoursButton.isSelected.toggle()
            
            if open24hoursButton.isSelected {
                operationTimeOpen.makeLabelText("00:00")
                operationTimeClosed.makeLabelText("24:00")
                operationTimeOpen.isEnabledButton(false)
                operationTimeClosed.isEnabledButton(false)
                
                whenAddTimeLabelCheckIsEnabledEditButton()
            } else {
                operationTimeOpen.isEnabledButton(true)
                operationTimeClosed.isEnabledButton(true)
            }
        }

    }
    
    @objc private func editButtonTapped() {
        if editButtonIsEnabled {
            var operatingHours = "정보 없음"
            var breakTime = ""
            
            if dayOffButton.isSelected {
                operatingHours = "휴무"
                breakTime = ""
            } else {
                let open = operationTimeOpen.loadTimeData()
                let closed = operationTimeClosed.loadTimeData()
                
                operatingHours = open + "-" + closed
            }
            
            if breakTimeOpen.loadTimeData() != "시간 선택" && breakTimeClosed.loadTimeData() != "시간 선택" {
                let open = breakTimeOpen.loadTimeData()
                let closed = breakTimeClosed.loadTimeData()
                
                breakTime = open + "-" + closed
            }
            
            let model = EditOperationHoursModel(
                day: self.day,
                operatingHours: operatingHours,
                breakTime: breakTime
            )
            
            editTapped?(model)
        }
    }

    private func whenAddTimeLabelCheckIsEnabledEditButton() {
        let operationIsInit = operationTimeOpen.loadTimeData() == "시간 선택" || operationTimeClosed.loadTimeData() == "시간 선택"
        
        let operationCheck = operationTimeOpen.loadTimeData() != initOperationOpen || operationTimeClosed.loadTimeData() != initOperationClosed
        
        
        let breakTimeCheck = breakTimeOpen.loadTimeData() != initBreakOpen || breakTimeClosed.loadTimeData() != initBreakClosed
        
        if operationIsInit {
            editButtonIsEnabled = false
            print(operationIsInit)
        } else {
            if operationCheck || breakTimeCheck {
                print(operationCheck)
                print(breakTimeCheck)
                editButtonIsEnabled = true
            } else {
                print(operationCheck)
                print(breakTimeCheck)
                editButtonIsEnabled = false
            }
        }
    }
}
