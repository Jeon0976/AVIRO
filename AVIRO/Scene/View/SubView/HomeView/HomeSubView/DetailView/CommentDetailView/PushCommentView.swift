//
//  PushCommentView.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/06/27.
//

import UIKit

final class PushCommentView: UIView {
    lazy var textView: UITextView = {
        let textView = UITextView()
        
        textView.text = StringValue.CommentView.commentPlaceHolder
        textView.font = .systemFont(ofSize: 16, weight: .medium)
        textView.textColor = .gray4
        
        textView.isEditable = true
        textView.isScrollEnabled = false

        textView.delegate = self

        textView.textContainer.lineBreakMode = .byWordWrapping
        textView.textContainer.lineFragmentPadding = 0
   
        return textView
    }()
    
    lazy var button: UIButton = {
        let button = UIButton()
        
        button.setTitle(StringValue.CommentView.reportButton, for: .normal)
        button.setTitleColor(.separateLine, for: .normal)
        
        return button
    }()
    
    lazy var separator: UIView = {
       let separator = UIView()
        
        separator.backgroundColor = .gray3
        separator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        return separator
    }()
    
    var viewHeight: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .white
        
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
                equalTo: separator.bottomAnchor),
            textView.leadingAnchor.constraint(
                equalTo: self.leadingAnchor, constant: Layout.Inset.leadingTop),
            textView.trailingAnchor.constraint(
                equalTo: button.leadingAnchor, constant: Layout.Inset.trailingBottom),
            
            // button
            button.topAnchor.constraint(
                equalTo: separator.bottomAnchor),
            button.trailingAnchor.constraint(
                equalTo: self.trailingAnchor, constant: Layout.Inset.trailingBottom),
            button.widthAnchor.constraint(
                equalTo: button.heightAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let separatorHeight = separator.frame.height
        let textView = textView.frame.height
        
        viewHeight?.constant = separatorHeight + textView
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
            button.setTitleColor(.gray3, for: .normal)
        }
        
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
}
