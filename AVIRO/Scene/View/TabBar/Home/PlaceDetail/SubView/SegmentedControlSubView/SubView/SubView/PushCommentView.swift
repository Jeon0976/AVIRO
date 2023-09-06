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
    
    private lazy var button: UIButton = {
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
    
    private var viewHeight: NSLayoutConstraint?
    private var originalTextViewHeight: CGFloat?    
    
    var enrollReview: ((String) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .gray7
        
        [
            separator,
            textView,
            button
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview($0)
        }
        
        viewHeight = heightAnchor.constraint(equalToConstant: 0)
        viewHeight?.isActive = true
        
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
            textView.leadingAnchor.constraint(
                equalTo: self.leadingAnchor, constant: 16),
            textView.trailingAnchor.constraint(
                equalTo: button.leadingAnchor, constant: -10),
            
            // button
            button.centerYAnchor.constraint(
                equalTo: self.centerYAnchor),
            button.trailingAnchor.constraint(
                equalTo: self.trailingAnchor, constant: Layout.Inset.trailingBottom)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        makeViewHeight()
        
        if originalTextViewHeight == nil {
            originalTextViewHeight = textView.frame.height
        }
        
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
            textView.text = "식당에 대한 경험과 팁을 알려주세요!"
            textView.textColor = .gray4
            textView.resignFirstResponder()
            button.setTitleColor(.gray4, for: .normal)
            
            resetTextViewHeight()
        } else {
            return
        }
    }
    
    private func resetTextViewHeight() {
        guard let originalHeight = originalTextViewHeight else { return }

        textView.constraints.forEach { constraint in
            if constraint.firstAttribute == .height {
                constraint.constant = originalHeight
            }
        }
    }
    
    func editMyReview(_ text: String) {
        textView.text = text
        textView.textColor = .gray0
        button.setTitleColor(.gray0, for: .normal)
    }
    
    private func updateTextviewHeight() {
        let size = CGSize(width: textView.frame.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        
        if estimatedSize.height <= textView.font!.lineHeight * 5 {
            textView.isScrollEnabled = false

            textView.constraints.forEach { constraint in
                if constraint.firstAttribute == .height {
                    constraint.constant = estimatedSize.height
                }
            }
        } else {
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
    
    func initTextView() {
        textView.text = "식당에 대한 경험과 팁을 알려주세요!"
        textView.textColor = .gray4
        button.setTitleColor(.gray4, for: .normal)
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
            button.setTitleColor(.gray0, for: .normal)
        } else {
            button.setTitleColor(.gray4, for: .normal)
            
        }
        
        updateTextviewHeight()
    }
}
