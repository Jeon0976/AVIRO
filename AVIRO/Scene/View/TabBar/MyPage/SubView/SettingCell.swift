//
//  SettingCell.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/09/08.
//

import UIKit

final class SettingCell: UITableViewCell {
    static let identifier = "SettingCell"
    
    private lazy var settingButton: UIButton = {
        let button = UIButton()
        
        button.setTitleColor(.gray0, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .medium)
        button.addTarget(self,
                         action: #selector(buttonTapped),
                         for: .touchUpInside
        )
        
        return button
    }()
    
    private lazy var pushButton: UIButton = {
        let button = UIButton()
        
        button.setImage(UIImage(named: "PushView"), for: .normal)
        button.addTarget(self,
                         action: #selector(buttonTapped),
                         for: .touchUpInside
        )
        
        return button
    }()
    
    //TODO: 업데이트 후 변경 예정
    private lazy var versionLabel: UILabel = {
        let label = UILabel()
        
        label.text = "현재 1.0.0 / 최신 1.0.0"
        label.textColor = .gray2
        label.font = .systemFont(ofSize: 15, weight: .medium)
        
        return label
    }()
    
    private var settingValue: SettingsRow!
    
    var tappedAfterSettingValue: ((SettingsRow) -> Void)?
    
    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupLayout()
        setupAttribute()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setupLayout() {
        [
            settingButton,
            pushButton,
            versionLabel
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.contentView.addSubview($0)
        }
                
        NSLayoutConstraint.activate([
            settingButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            settingButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            
            pushButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            pushButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            
            versionLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            versionLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20)
        ])
        
        pushButton.isHidden = true
        versionLabel.isHidden = true
    }
    
    private func setupAttribute() {
        self.backgroundColor = .gray7
    }
    
    func dataBinding(_ settingsRow: SettingsRow) {
        if settingsRow == .displayMode {
            pushButton.isHidden = false
        }
        
        if settingsRow == .versionInfo {
            versionLabel.isHidden = false
        }
        
        if settingsRow == .logout {
            settingButton.setTitleColor(.red, for: .normal)
        }
        
        self.settingValue = settingsRow
        settingButton.setTitle(settingsRow.rawValue, for: .normal)
    }
    
    @objc private func buttonTapped() {
        tappedAfterSettingValue?(settingValue)
    }
}
