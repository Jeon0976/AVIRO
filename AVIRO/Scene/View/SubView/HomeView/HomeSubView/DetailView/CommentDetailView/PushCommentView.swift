//
//  PushCommentView.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/06/27.
//

import UIKit

final class PushCommentView: UIView {
    let textView: UITextView = {
        let textView = UITextView()
        
        textView.text = "이 식당에 대한 경험을 적어주세요!"
        textView.font = .systemFont(ofSize: 17, weight: .medium)
        textView.textColor = .separateLine
        
        textView.isEditable = true
        textView.isScrollEnabled = false
        
        textView.textContainer.lineBreakMode = .byWordWrapping
        textView.textContainer.lineFragmentPadding = 0
   
        return textView
    }()
    
    let button: UIButton = {
        let button = UIButton()
        
        button.setTitle("게시", for: .normal)
        button.setTitleColor(.separateLine, for: .normal)
        
        return button
    }()
    
    let separator: UIView = {
       let separator = UIView()
        
        separator.backgroundColor = .separateLine
        separator.layer.cornerRadius = 2.5
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
            separator.topAnchor.constraint(equalTo: self.topAnchor),
            separator.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            separator.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            // textView
            textView.topAnchor.constraint(equalTo: separator.bottomAnchor),
            textView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            textView.trailingAnchor.constraint(equalTo: button.leadingAnchor, constant: -16),
            
            // button
            button.topAnchor.constraint(equalTo: separator.bottomAnchor),
            button.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            button.widthAnchor.constraint(equalTo: button.heightAnchor)
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
