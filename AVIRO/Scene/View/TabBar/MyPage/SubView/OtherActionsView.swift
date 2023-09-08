//
//  OtherActionsView.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/08/29.
//

import UIKit

enum SettingsSection: Int, CaseIterable {
    case displayMode
    case information
    case account
    
    var rows: [SettingsRow] {
        switch self {
        case .displayMode:
            return [.displayMode]
        case .information:
            return [.termsOfService, .privacyPolicy, .locationPolicy, .inquiries, .thanksTo]
        case .account:
            return [.logout, .versionInfo]
        }
    }
}

enum SettingsRow: String {
    case displayMode = "화면 모드 설정"
    case termsOfService = "서비스 이용약관"
    case privacyPolicy = "개인정보 수집 및 이용"
    case locationPolicy = "위치정보 수집 및 이용"
    case inquiries = "문의사항"
    case thanksTo = "Thanks to"
    case logout = "로그아웃"
    case versionInfo = "버전 정보"
}

final class OtherActionsView: UIView {
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        
        tableView.register(SettingCell.self, forCellReuseIdentifier: SettingCell.identifier)
        tableView.backgroundColor = .gray6
        tableView.rowHeight = 50
        
        return tableView
    }()
    
    private var viewHeightConstrant: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setupViewHeight()
    }
    
    private func setupViewHeight() {
        viewHeightConstrant?.constant = tableView.frame.height
    }
    
    private func setupLayout() {
        viewHeightConstrant = self.heightAnchor.constraint(equalToConstant: 550)
        viewHeightConstrant?.isActive = true
        
        addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
    }
}

extension OtherActionsView: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return SettingsSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sectionType = SettingsSection(rawValue: section) else { return 0 }
        return sectionType.rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingCell.identifier, for: indexPath) as? SettingCell
        
        if let sectionType = SettingsSection(rawValue: indexPath.section) {
            let rowType = sectionType.rows[indexPath.row]
            
            cell?.selectionStyle = .none
            cell?.dataBinding(rowType)
        }
        
        return cell ?? UITableViewCell()
    }
}

extension OtherActionsView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == SettingsSection.account.rawValue {
            return makeUserWithdrwalView()
        }
        return nil
    }
    
    private func makeUserWithdrwalView() -> UIView {
        let footerView = UIView()
        footerView.backgroundColor = .gray6
        
        let button = UIButton(frame: CGRect(x: 20, y: 20, width: 60, height: 20))
        
        let attributedString = NSMutableAttributedString(string: "회원탈퇴")
        attributedString.addAttribute(
            NSAttributedString.Key.underlineStyle,
            value: NSUnderlineStyle.single.rawValue,
            range: NSRange(location: 0, length: attributedString.length)
        )
        
        button.setAttributedTitle(attributedString, for: .normal)
        button.setTitleColor(.gray2, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        
        footerView.addSubview(button)
        
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == SettingsSection.account.rawValue {
            return 50
        }
        return 10
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath)
        
    }
    
}
