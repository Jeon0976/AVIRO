//
//  ReportCellView.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/08/24.
//

import UIKit

final class ReportCellView: UIView {
    
    private lazy var clickButton: UIButton = {
        let button = UIButton()
        
        button.setImage(UIImage(named: "RadioCircle"), for: .normal)
        button.setImage(UIImage(named: "RadioCircleClicked"), for: .selected)
        button.addTarget(self, action: #selector(clickButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 15, weight: .medium)
        label.textColor = .gray0
        label.numberOfLines = 1
        
        return label
    }()
    
    private var tapGesture = UITapGestureRecognizer()

    var selectedReportType: ((String) -> Void)?
    var clickedOffSelectedType: ((String) -> Void)?
    var isHiddenTextView: ((Bool) -> Void)?
    
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
            clickButton,
            titleLabel
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            clickButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            clickButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 12),
            clickButton.widthAnchor.constraint(equalToConstant: 24),
            clickButton.heightAnchor.constraint(equalToConstant: 24),
            
            titleLabel.leadingAnchor.constraint(equalTo: clickButton.trailingAnchor, constant: 10),
            titleLabel.centerYAnchor.constraint(equalTo: clickButton.centerYAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 16)
        ])
    }
    
    private func makeAttribute() {
        self.layer.cornerRadius = 10
        self.layer.borderColor = UIColor.gray4?.cgColor
        self.layer.borderWidth = 1
    }
    
    private func makeGesture() {
        tapGesture.addTarget(self, action: #selector(cellTapped))
        self.addGestureRecognizer(tapGesture)
    }
    
    private func makeViewHeight() {
        let total = clickButton.frame.height + 24
        self.heightAnchor.constraint(equalToConstant: total).isActive = true
    }
    
    @objc private func cellTapped() {
        guard let text = titleLabel.text else { return }

        clickButton.isSelected.toggle()
        
        if clickButton.isSelected {
            selectedReportType?(text)
            self.layer.borderColor = UIColor.main?.cgColor
        } else {
            self.layer.borderColor = UIColor.gray4?.cgColor
            clickedOffSelectedType?(text)
            if titleLabel.text == ReportType.others.rawValue {
                isHiddenTextView?(true)
            }
        }
    }
    
    @objc private func clickButtonTapped() {
        guard let text = titleLabel.text else { return }

        clickButton.isSelected.toggle()
        
        if clickButton.isSelected {
            selectedReportType?(text)
            self.layer.borderColor = UIColor.main?.cgColor
        } else {
            self.layer.borderColor = UIColor.gray4?.cgColor
            clickedOffSelectedType?(text)
            if titleLabel.text == ReportType.others.rawValue {
                isHiddenTextView?(true)
            }
        }
    }
    
    func makeCellView(_ text: String) {
        titleLabel.text = text
    }
    
    func initLabelView() {
        clickButton.isSelected = false
        self.layer.borderColor = UIColor.gray4?.cgColor
    }
    
    func checkCell() -> String {
        guard let text = titleLabel.text else { return "" }
        return text 
    }
}
