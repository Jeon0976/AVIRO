//
//  UnderlineSegmentedControl.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/08/11.
//

import UIKit

final class UnderlineSegmentedControl: UISegmentedControl {
    private lazy var selectedLineView: UIView = {
        let width = self.bounds.size.width / CGFloat(self.numberOfSegments)
        let height = 2.0
        let xPosition = CGFloat(self.selectedSegmentIndex * Int(width))
        let yPosition = self.bounds.size.height - height
        
        let frame = CGRect(
            x: xPosition,
            y: yPosition,
            width: width,
            height: height
        )
        
        let view = UIView(frame: frame)
        view.backgroundColor = .gray1
        
        self.addSubview(view)
        return view
    }()
    
    private lazy var underLineView: UIView = {
        let width = self.bounds.size.width
        let height = 1.0
        let yPosition = self.bounds.size.height - height
        
        let frame = CGRect(
            x: 0,
            y: yPosition,
            width: width,
            height: height
        )
        
        let view = UIView(frame: frame)
        view.backgroundColor = .gray5
        
        self.addSubview(view)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
      
        removeBackgroundAndDivider()
    }
    
    override init(items: [Any]?) {
        super.init(items: items)
        
        removeBackgroundAndDivider()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.underLineView.frame.origin.x = 0
                
        let selectedLineViewFinalXPosition =
        (self.bounds.width / CGFloat(self.numberOfSegments)) * CGFloat(self.selectedSegmentIndex)
        
        UIView.animate(withDuration: 0.2) {
                self.selectedLineView.frame.origin.x = selectedLineViewFinalXPosition
            }
    }
    
    private func removeBackgroundAndDivider() {
        let image = UIImage()
        self.setBackgroundImage(image, for: .normal, barMetrics: .default)
        self.setBackgroundImage(image, for: .selected, barMetrics: .default)
        self.setBackgroundImage(image, for: .highlighted, barMetrics: .default)
        
        self.setDividerImage(image, forLeftSegmentState: .selected, rightSegmentState: .normal, barMetrics: .default)
    }
    
    /// normal, selected 일 때 color와 font 설정
    func setAttributedTitle(
        _ normal: (UIColor?, UIFont) = (
            UIColor.gray2,
            UIFont.systemFont(ofSize: 17, weight: .medium)
        ),
        _ selected: (UIColor?, UIFont) = (
            UIColor.gray0,
            UIFont.systemFont(ofSize: 17, weight: .semibold)
        )
    ) {
        guard let normalColor = normal.0 else { return }
        guard let selectedColor = selected.0 else { return }

        setTitleTextAttributes(
            [
                NSAttributedString.Key.foregroundColor: normalColor,
                NSAttributedString.Key.font: normal.1
            ], for: .normal)
        
        setTitleTextAttributes(
            [
                NSAttributedString.Key.foregroundColor: selectedColor,
                NSAttributedString.Key.font: selected.1
            ], for: .selected)
    }
}
