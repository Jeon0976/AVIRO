//
//  MyInfoView.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/08/29.
//

import UIKit

final class MyInfoView: UIView {
    private lazy var userImage: UIImageView = {
        let imageView = UIImageView()
        
        imageView.backgroundColor = .gray5
        imageView.layer.cornerRadius = 40
        
        return imageView
    }()
    
    private lazy var nicknameLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.text = UserId.shared.userId
        label.textColor = .gray0
        
        return label
    }()
    
    private lazy var editNickname: EditNicNameButton = {
        let button = EditNicNameButton()
        
        button.makeButton("닉네임 수정하기")
        
        return button
    }()
    
    private lazy var myPlaceLabel: UILabel = {
        let label = UILabel()
        
        label.text = "등록한 가게"
        label.textColor = .gray1
        label.font = .systemFont(ofSize: 15, weight: .bold)
        
        return label
    }()
    
    private lazy var myPlaceButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("0개", for: .normal)
        button.setTitleColor(.gray0, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        
        return button
    }()
    
    private lazy var myPlaceStackView: UIStackView = {
        let stackView = UIStackView()
       
        stackView.axis = .vertical
        stackView.spacing = 11
        stackView.alignment = .center
        
        return stackView
    }()
    
    private lazy var myReviewLabel: UILabel = {
        let label = UILabel()
        
        label.text = "작성 후기"
        label.textColor = .gray1
        label.font = .systemFont(ofSize: 15, weight: .bold)
        
        return label
    }()

    private lazy var myReviewButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("0개", for: .normal)
        button.setTitleColor(.gray0, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        
        return button
    }()
    
    private lazy var myReviewStackView: UIStackView = {
        let stackView = UIStackView()
       
        stackView.axis = .vertical
        stackView.spacing = 11
        stackView.alignment = .center

        return stackView
    }()
    
    private lazy var myStarLabel: UILabel = {
        let label = UILabel()
        
        label.text = "즐겨찾기"
        label.textColor = .gray1
        label.font = .systemFont(ofSize: 15, weight: .bold)
        
        return label
    }()
    
    private lazy var myStarButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("0개", for: .normal)
        button.setTitleColor(.gray0, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        
        return button
    }()
    
    private lazy var myStarStackView: UIStackView = {
        let stackView = UIStackView()
       
        stackView.axis = .vertical
        stackView.spacing = 11
        stackView.alignment = .center

        return stackView
    }()
    
    private lazy var myStateStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        
        return stackView
    }()
    
    private lazy var checkButtonStackView: UIStackView = {
        let stackView = UIStackView()
        
        return stackView
    }()
    
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
        // TODO: 임시
        self.heightAnchor.constraint(equalToConstant: 280).isActive = true
        
        [
            userImage,
            nicknameLabel,
            editNickname,
            myStateStackView
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            userImage.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            userImage.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            userImage.heightAnchor.constraint(equalToConstant: 80),
            userImage.widthAnchor.constraint(equalToConstant: 80),
            
            nicknameLabel.topAnchor.constraint(equalTo: userImage.bottomAnchor, constant: 20),
            nicknameLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            editNickname.topAnchor.constraint(equalTo: nicknameLabel.bottomAnchor, constant: 7),
            editNickname.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            editNickname.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            editNickname.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            myStateStackView.topAnchor.constraint(equalTo: editNickname.bottomAnchor, constant: 32),
            myStateStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            myStateStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
        
        makeStackViewLayout()
    }
    
    private func makeStackViewLayout() {
        [
            myPlaceStackView,
            myReviewStackView,
            myStarStackView
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            myStateStackView.addArrangedSubview($0)
        }
        
        [
            myPlaceLabel,
            myPlaceButton
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            myPlaceStackView.addArrangedSubview($0)
        }
        
        [
            myReviewLabel,
            myReviewButton
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            myReviewStackView.addArrangedSubview($0)
        }
        
        [
            myStarLabel,
            myStarButton
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            myStarStackView.addArrangedSubview($0)
        }
    }
    
    private func makeAttribute() {
        self.backgroundColor = .gray7
        self.layer.cornerRadius = 15
        self.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    }
    
    func updateId(_ id: String) {
        self.nicknameLabel.text = id
    }
    
    func updateMyPlace(_ place: String) {
        myPlaceButton.setTitle("\(place)개", for: .normal)
    }
    
    func updateMyReview(_ review: String) {
        myReviewButton.setTitle("\(review)개", for: .normal)
    }
    
    func updateMyStar(_ star: String) {
        myStarButton.setTitle("\(star)개", for: .normal)
    }
}
