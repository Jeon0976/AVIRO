//
//  PlaceInfoView.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/08/11.
//

import UIKit

final class PlaceInfoView: UIView {
    private var title: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .gray0
        label.text = "가게 정보"
        
        return label
    }()
    
    private lazy var updatedTimeLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 13, weight: .medium)
        label.textAlignment = .right
        label.textColor = .gray2
        
        return label
    }()
    
    private lazy var addressIcon: UIImageView = {
        let imageView = UIImageView()
        
        imageView.image = UIImage(named: "MapInfo")
        
        return imageView
    }()
    
    private lazy var addressLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = .gray0
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: 16, weight: .medium)
        
        return label
    }()
    
    private lazy var phoneIcon: UIImageView = {
        let imageView = UIImageView()
        
        imageView.image = UIImage(named: "PhoneInfo")
        
        return imageView
    }()
    
    private lazy var phoneButton: UIButton = {
        let button = UIButton()
        
        button.setTitleColor(.changeButton, for: .normal)
        button.backgroundColor = .gray7
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.addTarget(self, action: #selector(phoneButtonTapped(_:)), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var timeIcon: UIImageView = {
        let imageView = UIImageView()
        
        imageView.image = UIImage(named: "TimeInfo")

        return imageView
    }()
    
    private lazy var timePlusButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("영업 시간 추가", for: .normal)
        button.setTitleColor(.changeButton, for: .normal)
        button.backgroundColor = .gray7
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.titleLabel?.textAlignment = .left
        button.addTarget(self, action: #selector(timePlusButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .gray0
        
        return label
    }()
    
    private lazy var timeTableShowButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("더보기", for: .normal)
        button.setTitleColor(.gray2, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        button.addTarget(self, action: #selector(timeTableShowButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var homePageIcon: UIImageView = {
        let imageView = UIImageView()
        
        imageView.image = UIImage(named: "HomeInfo")
        
        return imageView
    }()
    
    private lazy var homePageButton: UIButton = {
        let button = UIButton()
        
        button.setTitleColor(.changeButton, for: .normal)
        button.backgroundColor = .gray7
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.titleLabel?.numberOfLines = 2
        button.titleLabel?.lineBreakMode = .byCharWrapping
        button.contentHorizontalAlignment = .left
        button.addTarget(self, action: #selector(homePageButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var separatorLine: UIView = {
        let view = UIView()
        
        view.backgroundColor = .gray5
        
        return view
    }()
    
    private lazy var editInfoButton: EditButton = {
        let button = EditButton()
        
        button.setButton("가게 정보 수정 요청하기")
        button.addTarget(self, action: #selector(editInfoButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    private var viewHeightConstraint: NSLayoutConstraint?
    
    var afterPhoneButtonTappedWhenNoData: (() -> Void)?
    var afterTimePlusButtonTapped: (() -> Void)?
    var afterTimeTableShowButtonTapped: (() -> Void)?
    var afterHomePageButtonTapped: ((String) -> Void)?
    var afterEditInfoButtonTapped: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        initPlaceInfoViewHeight()
    }
    
    private func makeLayout() {
        self.backgroundColor = .gray7
        [
            title,
            updatedTimeLabel,
            addressIcon,
            addressLabel,
            phoneIcon,
            phoneButton,
            timeIcon,
            timePlusButton,
            timeLabel,
            timeTableShowButton,
            homePageIcon,
            homePageButton,
            separatorLine,
            editInfoButton
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
        
        viewHeightConstraint = self.heightAnchor.constraint(equalToConstant: 300)
        viewHeightConstraint?.isActive = true

        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            title.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            
            updatedTimeLabel.topAnchor.constraint(equalTo: title.topAnchor),
            updatedTimeLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            
            addressIcon.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 30),
            addressIcon.leadingAnchor.constraint(equalTo: title.leadingAnchor),
            addressIcon.widthAnchor.constraint(equalToConstant: 24),
            addressIcon.heightAnchor.constraint(equalToConstant: 24),
            
            addressLabel.centerYAnchor.constraint(equalTo: addressIcon.centerYAnchor),
            addressLabel.leadingAnchor.constraint(equalTo: addressIcon.trailingAnchor, constant: 10),
            addressLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            
            phoneIcon.topAnchor.constraint(equalTo: addressIcon.bottomAnchor, constant: 20),
            phoneIcon.leadingAnchor.constraint(equalTo: addressIcon.leadingAnchor),
            phoneIcon.widthAnchor.constraint(equalToConstant: 24),
            phoneIcon.heightAnchor.constraint(equalToConstant: 24),
            
            phoneButton.centerYAnchor.constraint(equalTo: phoneIcon.centerYAnchor),
            phoneButton.leadingAnchor.constraint(equalTo: phoneIcon.trailingAnchor, constant: 10),
            
            timeIcon.topAnchor.constraint(equalTo: phoneIcon.bottomAnchor, constant: 20),
            timeIcon.leadingAnchor.constraint(equalTo: addressIcon.leadingAnchor),
            timeIcon.widthAnchor.constraint(equalToConstant: 24),
            timeIcon.heightAnchor.constraint(equalToConstant: 24),
            
            timePlusButton.centerYAnchor.constraint(equalTo: timeIcon.centerYAnchor),
            timePlusButton.leadingAnchor.constraint(equalTo: timeIcon.trailingAnchor, constant: 10),
            
            timeLabel.centerYAnchor.constraint(equalTo: timeIcon.centerYAnchor),
            timeLabel.leadingAnchor.constraint(equalTo: timeIcon.trailingAnchor, constant: 10),
            timeLabel.trailingAnchor.constraint(equalTo: timeTableShowButton.leadingAnchor, constant: -10),
            
            timeTableShowButton.centerYAnchor.constraint(equalTo: timeLabel.centerYAnchor),
            timeTableShowButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            timeTableShowButton.widthAnchor.constraint(equalToConstant: 50),
            
            homePageIcon.topAnchor.constraint(equalTo: timeIcon.bottomAnchor, constant: 20),
            homePageIcon.leadingAnchor.constraint(equalTo: title.leadingAnchor),
            homePageIcon.widthAnchor.constraint(equalToConstant: 24),
            homePageIcon.heightAnchor.constraint(equalToConstant: 24),
            
            homePageButton.centerYAnchor.constraint(equalTo: homePageIcon.centerYAnchor),
            homePageButton.leadingAnchor.constraint(equalTo: homePageIcon.trailingAnchor, constant: 10),
            homePageButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            
            separatorLine.topAnchor.constraint(equalTo: homePageIcon.bottomAnchor, constant: 10),
            separatorLine.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            separatorLine.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            separatorLine.heightAnchor.constraint(equalToConstant: 1),
            
            editInfoButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            editInfoButton.topAnchor.constraint(equalTo: separatorLine.bottomAnchor, constant: 20),
            editInfoButton.widthAnchor.constraint(equalToConstant: 160)
        ])
    
    }
       
    private func initPlaceInfoViewHeight() {
        let titleHeight = title.frame.height
        let addressHeight = addressLabel.frame.height
        let phoneHeight = phoneIcon.frame.height
        let timeHeight = timeIcon.frame.height
        let homePageHeight = homePageIcon.frame.height
        
        let lineHeight = separatorLine.frame.height
        let changeButtonHeight = editInfoButton.frame.height
        
        // 20 30 20 20 20 10 20 20
        let inset: CGFloat = 160
        
        let totalHeight =
            titleHeight + addressHeight + phoneHeight +
            timeHeight + homePageHeight + lineHeight + changeButtonHeight + inset
                
        viewHeightConstraint?.constant = totalHeight
    }
    
    // TODO: Back end 수정 되면 수정
    func dataBindingWhenInHomeView(_ infoModel: PlaceInfoData?) {
        guard let infoModel = infoModel else { return }

        addressLabel.text = infoModel.address
        updatedTimeLabel.text = "업데이트 " + infoModel.updatedTime
        
        if infoModel.phone == "" {
            phoneButton.setTitle("전화번호 추가", for: .normal)
        } else {
            phoneButton.setTitle(infoModel.phone, for: .normal)
        }
        
        if !infoModel.haveTime {
            showOperationButton()
        } else {
            showOperationLabel(infoModel.shopStatus, infoModel.shopHours)
        }
                
        if let homePage = infoModel.url {
            homePageButton.setTitle(homePage, for: .normal)
        } else {
            homePageButton.setTitle("홈페이지 링크 추가", for: .normal)
        }
    }
    
    private func showOperationButton() {
        timePlusButton.isHidden = false
        timeLabel.isHidden = true
        timeTableShowButton.isHidden = true

    }
    
    private func showOperationLabel(_ state: String, _ operating: String) {
        timeLabel.isHidden = false
        timeTableShowButton.isHidden = false
        timePlusButton.isHidden = true
        
        timeLabel.text = state + " " + operating
    }
    
    @objc private func phoneButtonTapped(_ sender: UIButton) {
        guard let text = sender.titleLabel?.text else { return }
        if text != "전화번호 추가" {
            self.telViewPush(text)
        } else {
            self.afterPhoneButtonTappedWhenNoData?()
        }
    }
    
    private func telViewPush(_ phoneNumber: String) {
        let urlPhone = "tel:" + phoneNumber
        
        guard let url = URL(string: urlPhone) else { return }
        
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }

    }
    
    @objc private func timeTableShowButtonTapped() {
        self.afterTimeTableShowButtonTapped?()
    }
    
    @objc private func timePlusButtonTapped() {
        self.afterTimePlusButtonTapped?()
    }
    
    @objc private func homePageButtonTapped(_ sender: UIButton) {
        guard let text = sender.titleLabel?.text else { return }
        
        afterHomePageButtonTapped?(text)
    }
    
    @objc private func editInfoButtonTapped() {
        afterEditInfoButtonTapped?()
    }
    
}
