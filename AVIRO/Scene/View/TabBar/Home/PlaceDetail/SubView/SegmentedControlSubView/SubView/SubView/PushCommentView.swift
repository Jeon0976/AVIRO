//
//  PushCommentView.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/06/27.
//

import UIKit

final class PushCommentView: UIView {
    private lazy var textView: UITextView = {
        let textView = UITextView()
        
        textView.text = "식당에 대한 경험과 팁을 알려주세요!"
        textView.font = .systemFont(ofSize: 16, weight: .medium)
        textView.textColor = .gray4
        textView.textContainerInset = UIEdgeInsets(top: 8, left: 10, bottom: 8, right: 10)
        
        textView.layer.cornerRadius = 5
        textView.layer.borderColor = UIColor.gray4?.cgColor
        textView.layer.borderWidth = 0.5
        
        textView.isEditable = true
        textView.isScrollEnabled = false

        textView.backgroundColor = .gray7
        textView.delegate = self

        textView.textContainer.lineBreakMode = .byWordWrapping
        textView.textContainer.lineFragmentPadding = 0
   
        return textView
    }()
    
    private lazy var enrollButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("등록", for: .normal)
        button.setTitleColor(.gray4, for: .normal)
        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var separator: UIView = {
       let separator = UIView()
        
        separator.backgroundColor = .gray3
        separator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        return separator
    }()
    
    private lazy var cancelEditButton: UIButton = {
        let button = UIButton()
       
        button.setImage(UIImage(named: "Close"), for: .normal)
        button.addTarget(self, action: #selector(cancelEditTapped), for: .touchUpInside)
        
        return button
    }()
    
    private var viewHeight: NSLayoutConstraint?
    
    private var temparyTextViewHeightConstraint: NSLayoutConstraint?
    private var textViewLeadingWhenHiddenCancelButton: NSLayoutConstraint?
    private var textViewLeadingWhenShowCancelButton: NSLayoutConstraint?
    
    var enrollReview: ((String) -> Void)?
    var initView: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
        setupAttribute()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        makeViewHeight()
    }
    
    private func setupLayout() {
        [
            separator,
            textView,
            enrollButton,
            cancelEditButton
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview($0)
        }
        
        viewHeight = heightAnchor.constraint(equalToConstant: 0)
        viewHeight?.isActive = true
        
        textViewLeadingWhenHiddenCancelButton = textView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10)
        textViewLeadingWhenHiddenCancelButton?.isActive = true
        
        textViewLeadingWhenShowCancelButton = textView.leadingAnchor.constraint(equalTo: cancelEditButton.trailingAnchor, constant: 10)
        textViewLeadingWhenShowCancelButton?.isActive = false
        
        temparyTextViewHeightConstraint = textView.heightAnchor.constraint(equalToConstant: 0)
        temparyTextViewHeightConstraint?.isActive = false
        
        NSLayoutConstraint.activate([
            // separator
            separator.topAnchor.constraint(
                equalTo: self.topAnchor),
            separator.leadingAnchor.constraint(
                equalTo: self.leadingAnchor),
            separator.trailingAnchor.constraint(
                equalTo: self.trailingAnchor),
            
            // textView
            textView.topAnchor.constraint(
                equalTo: separator.bottomAnchor, constant: 12.5),
            textView.trailingAnchor.constraint(
                equalTo: enrollButton.leadingAnchor, constant: -10),
            
            // CancelButton
            cancelEditButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            cancelEditButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            cancelEditButton.widthAnchor.constraint(equalToConstant: 15),
            cancelEditButton.heightAnchor.constraint(equalToConstant: 15),
            
            // EnrollButton
            enrollButton.centerYAnchor.constraint(
                equalTo: self.centerYAnchor),
            enrollButton.trailingAnchor.constraint(
                equalTo: self.trailingAnchor, constant: Layout.Inset.trailingBottom),
            enrollButton.widthAnchor.constraint(equalToConstant: 32),
            enrollButton.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    private func setupAttribute() {
        self.backgroundColor = .gray7
        cancelEditButton.isHidden = true
    }
    
    private func makeViewHeight() {
        let separatorHeight = separator.frame.height
        let textView = textView.frame.height

        let inset: CGFloat = 25
        
        viewHeight?.constant = separatorHeight + textView + inset
    }
    
    @objc private func buttonTapped(_ sender: UIButton) {
        if sender.titleLabel?.textColor == .gray0 {
            guard let text = textView.text else { return }
            enrollReview?(text)

            initTextView()
        } else {
            return
        }
    }
    
    @objc private func cancelEditTapped() {
        initTextView()
    }
    
    func autoStartWriteComment() {
        textView.becomeFirstResponder()
    }
    
    func editMyReview(_ text: String) {
        textView.text = text
        textView.textColor = .gray0
        enrollButton.setTitleColor(.gray0, for: .normal)
        
        whenEditUpdateTextViewHeight()
        updateViewWhenEditComment(true)
        textView.becomeFirstResponder()
    }
    
    func initTextView() {
        initAttribute()
        updateTextviewHeight()
        updateViewWhenEditComment(false)
        textView.resignFirstResponder()
        
        initView?()
    }
    
    private func initAttribute() {
        textView.text = "식당에 대한 경험과 팁을 알려주세요!"
        textView.textColor = .gray4
        enrollButton.setTitleColor(.gray4, for: .normal)
    }
    
    private func updateViewWhenEditComment(_ isShow: Bool) {
        cancelEditButton.isHidden = !isShow
        
        if isShow {
            textViewLeadingWhenHiddenCancelButton?.isActive = false
            textViewLeadingWhenShowCancelButton?.isActive = true
        } else {
            textViewLeadingWhenShowCancelButton?.isActive = false
            textViewLeadingWhenHiddenCancelButton?.isActive = true
        }
        
        UIView.animate(withDuration: 0.1) {
            self.layoutIfNeeded()
        }
    }
    
    private func updateTextviewHeight() {
        temparyTextViewHeightConstraint?.isActive = false

        let size = CGSize(width: textView.frame.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        
        let maxLines = 5
        let maxHeight = textView.font!.lineHeight * CGFloat(maxLines)
        
        if estimatedSize.height <= maxHeight {
            textView.isScrollEnabled = false
        } else {
            textView.isScrollEnabled = true
        }
    }
    
    private func whenEditUpdateTextViewHeight() {
        let size = CGSize(width: textView.frame.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        
        let maxLines = 5
        let maxHeight = textView.font!.lineHeight * CGFloat(maxLines)

        if estimatedSize.height <= maxHeight {
            textView.isScrollEnabled = false
        } else {
            temparyTextViewHeightConstraint?.constant = maxHeight
            temparyTextViewHeightConstraint?.isActive = true
            textView.isScrollEnabled = true
        }
    }
    
    // MARK: Keyboard Method 처리
    func keyboardWillShow(height: CGFloat) {
        UIView.animate(
            withDuration: 0.3,
            animations: { self.transform = CGAffineTransform(
                translationX: 0,
                y: -(height))
            }
        )
    }
    
    func keyboardWillHide() {
        self.transform = .identity
    }
}

extension PushCommentView: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .gray4 {
            textView.textColor = .gray0
            textView.text = ""
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text != "" {
            enrollButton.setTitleColor(.gray0, for: .normal)
        } else {
            enrollButton.setTitleColor(.gray4, for: .normal)
        }
        
        updateTextviewHeight()
    }
}
