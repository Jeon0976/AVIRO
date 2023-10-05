//
//  NoHistoryView.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/08/04.

import UIKit

private enum Text: String {
    case topStore = "원하는 가게를 찾고 싶을 때"
    case bottomStore = "'가게 이름'을 검색해보세요"
    
    case topStation = "원하는 지역으로 이동하고 싶을 때"
    case bottomStation = "'지역명'또는 '지하철역명'을 검색해보세요"
}

final class NoHistoryView: UIView {
    
    private lazy var topLabelView = {
        let labelView = NoHistoryLabelView()
                
        labelView.setupData(
            topText: Text.topStore.rawValue,
            bottomText: Text.bottomStore.rawValue,
            icon: UIImage.mainSearchStore
        )
        
        return labelView
    }()
    
    private lazy var bottomLabelView = {
        let labelView = NoHistoryLabelView()
        
        labelView.setupData(
            topText: Text.topStation.rawValue,
            bottomText: Text.bottomStation.rawValue,
            icon: UIImage.mainSearchStation
        )
        
        return labelView
    }()
    
    private lazy var line: UIView = {
        let line = UIView()
        
        line.backgroundColor = .gray6
        
        return line
    }()

    private var viewHeightConstraint: NSLayoutConstraint?
    
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

    private func setupLayout() {
        [
            topLabelView,
            bottomLabelView,
            line
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview($0)
        }
        
        viewHeightConstraint = self.heightAnchor.constraint(equalToConstant: 250)
        viewHeightConstraint?.isActive = true
        
        NSLayoutConstraint.activate([
            topLabelView.topAnchor.constraint(equalTo: self.topAnchor),
            topLabelView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            topLabelView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            line.topAnchor.constraint(equalTo: topLabelView.bottomAnchor),
            line.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            line.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            line.heightAnchor.constraint(equalToConstant: 1),
            
            bottomLabelView.topAnchor.constraint(equalTo: line.bottomAnchor),
            bottomLabelView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            bottomLabelView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
    
    private func setupViewHeight() {
        let topHeight = topLabelView.frame.height
        let bottomHeight = bottomLabelView.frame.height
        let lineHeight = line.frame.height
        
        let totalHeight = topHeight + bottomHeight + lineHeight
        viewHeightConstraint?.constant = totalHeight
    }

}
