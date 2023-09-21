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
        
        label.font = .pretendard(size: 20, weight: .bold)
        label.textColor = .gray0
        label.text = "가게 정보"
        
        return label
    }()
    
    private lazy var updatedTimeLabel: UILabel = {
        let label = UILabel()
        
        label.font = .pretendard(size: 13, weight: .regular)
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
        label.numberOfLines = 0
        label.lineBreakMode = .byCharWrapping
        label.font = .pretendard(size: 16, weight: .medium)
        
        return label
    }()
    
    private lazy var phoneIcon: UIImageView = {
        let imageView = UIImageView()
        
        imageView.image = UIImage(named: "PhoneInfo")
        
        return imageView
    }()
    
    private lazy var phoneButton: UIButton = {
        let button = UIButton()
        
        button.setTitleColor(.keywordBlue, for: .normal)
        button.backgroundColor = .gray7
        button.contentHorizontalAlignment = .left
        button.titleLabel?.font = .pretendard(size: 16, weight: .medium)
        button.titleLabel?.numberOfLines = 1
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
        button.setTitleColor(.keywordBlue, for: .normal)
        button.backgroundColor = .gray7
        button.titleLabel?.font = .pretendard(size: 16, weight: .medium)
        button.titleLabel?.textAlignment = .left
        button.addTarget(self, action: #selector(timePlusButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        
        label.font = .pretendard(size: 16, weight: .medium)
        label.textColor = .gray0
        label.numberOfLines = 1
        
        return label
    }()
    
    private lazy var timeTableShowButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("더보기", for: .normal)
        button.setTitleColor(.gray2, for: .normal)
        button.titleLabel?.font = .pretendard(size: 14, weight: .regular)
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
        
        button.setTitleColor(.keywordBlue, for: .normal)
        button.backgroundColor = .gray7
        button.titleLabel?.font = .pretendard(size: 16, weight: .medium)
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
    
    private lazy var editInfoButton: EditInfoButton = {
        let button = EditInfoButton()
        
        button.setButton("가게 정보 수정 요청하기")
        button.addTarget(self, action: #selector(editInfoButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    private var viewHeightConstraint: NSLayoutConstraint?
    
    private var addressLabelTopAnchor: NSLayoutConstraint?
    private var addressLabelCenterYAnchor: NSLayoutConstraint?
    
    private var homePageButtonTopAnchor: NSLayoutConstraint?
    private var homePageButtonCenterYAncor: NSLayoutConstraint?
    
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
        
        setupViewHeight()
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

            addressLabel.leadingAnchor.constraint(equalTo: addressIcon.trailingAnchor, constant: 10),
            addressLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -32),

            phoneIcon.topAnchor.constraint(equalTo: addressLabel.bottomAnchor, constant: 20),
            phoneIcon.leadingAnchor.constraint(equalTo: addressIcon.leadingAnchor),
            phoneIcon.widthAnchor.constraint(equalToConstant: 24),
            phoneIcon.heightAnchor.constraint(equalToConstant: 24),
            
            phoneButton.centerYAnchor.constraint(equalTo: phoneIcon.centerYAnchor),
            phoneButton.leadingAnchor.constraint(equalTo: phoneIcon.trailingAnchor, constant: 10),
            phoneButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            
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
            
            homePageButton.leadingAnchor.constraint(equalTo: homePageIcon.trailingAnchor, constant: 10),
            homePageButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -32),
            
            separatorLine.topAnchor.constraint(equalTo: homePageButton.bottomAnchor, constant: 12),
            separatorLine.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            separatorLine.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            separatorLine.heightAnchor.constraint(equalToConstant: 1),
            
            editInfoButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            editInfoButton.topAnchor.constraint(equalTo: separatorLine.bottomAnchor, constant: 18),
            editInfoButton.widthAnchor.constraint(equalToConstant: 160)
        ])
    
        // 모두 1줄일 때 기본 anchor
        addressLabelCenterYAnchor = addressLabel.centerYAnchor.constraint(equalTo: addressIcon.centerYAnchor)
        addressLabelCenterYAnchor?.isActive = true
        
        homePageButtonCenterYAncor = homePageButton.centerYAnchor.constraint(equalTo: homePageIcon.centerYAnchor)
        homePageButtonCenterYAncor?.isActive = true
        
        addressLabelTopAnchor = addressLabel.topAnchor.constraint(equalTo: addressIcon.topAnchor)
        addressLabelTopAnchor?.isActive = false
        
        homePageButtonTopAnchor = homePageButton.topAnchor.constraint(equalTo: homePageIcon.topAnchor)
        homePageButtonTopAnchor?.isActive = false
    }
       
    private func setupViewHeight() {
        let titleHeight = title.frame.height
        let addressHeight = addressLabel.countCurrentLines() == 1 ? addressIcon.frame.height : addressLabel.frame.height
        let phoneHeight = phoneIcon.frame.height
        let timeHeight = timeIcon.frame.height
        let homePageHeight = homePageButton.countCurrentLines() == 1 ? homePageIcon.frame.height : homePageButton.frame.height
        
        let lineHeight = separatorLine.frame.height
        let changeButtonHeight = editInfoButton.frame.height
        
        // 20 30 20 20 20 10 20 20
        let inset: CGFloat = 160
        
        let totalHeight =
            titleHeight + addressHeight + phoneHeight +
            timeHeight + homePageHeight + lineHeight + changeButtonHeight + inset
                        
        viewHeightConstraint?.constant = totalHeight
    }
    
    func dataBindingWhenInHomeView(_ infoModel: AVIROPlaceInfo?) {
        guard let infoModel = infoModel else { return }

        addressLabel.text = infoModel.address + " " + (infoModel.address2 ?? "")
        updatedTimeLabel.text = "업데이트 " + infoModel.updatedTime
        
        if infoModel.phone == "" {
            phoneButton.setTitle("전화번호 추가", for: .normal)
        } else {
            phoneButton.setTitle(infoModel.phone, for: .normal)
        }
        
        print(infoModel)
        
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
        
        setLayoutForLineCount()
    }
    
    private func setLayoutForLineCount() {
        if addressLabel.countCurrentLines() > 1 {
            addressLabelCenterYAnchor?.isActive = false
            addressLabelTopAnchor?.isActive = true
        } else {
            addressLabelTopAnchor?.isActive = false
            addressLabelCenterYAnchor?.isActive = true
        }
        
        if homePageButton.countCurrentLines() > 1 {
            homePageButtonCenterYAncor?.isActive = false
            homePageButtonTopAnchor?.isActive = true
        } else {
            homePageButtonTopAnchor?.isActive = false
            homePageButtonCenterYAncor?.isActive = true
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
