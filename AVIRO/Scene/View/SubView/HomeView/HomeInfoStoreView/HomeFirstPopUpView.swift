//
//  HomeFirstPopUpView.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/05/27.
//
import UIKit

class HomeFirstPopUpView: UIView {
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: Image.bigGilraim)
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()

    let cancelButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: Image.close), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        
        return button
    }()
    
    let reportButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .plusButton
        button.setTitle(StringValue.HomeView.reportButton, for: .normal)
        button.setTitleColor(.mainTitle, for: .normal)
        
        button.layer.cornerRadius = Layout.Button.cornerRadius
        button.titleLabel?.font = Layout.Button.font
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    
        self.backgroundColor = .white
        self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        self.layer.cornerRadius = Layout.SlideView.cornerRadius
        
        [
            imageView,
            cancelButton,
            reportButton
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            // imageView
            imageView.centerXAnchor.constraint(
                equalTo: self.centerXAnchor),
            imageView.topAnchor.constraint(
                equalTo: self.topAnchor, constant: Layout.Inset.leadingTopPlus),
            imageView.bottomAnchor.constraint(
                equalTo: reportButton.topAnchor, constant: Layout.Inset.trailingBottomHalf),
            
            // cancelButton
            cancelButton.topAnchor.constraint(
                equalTo: self.topAnchor, constant: Layout.Inset.leadingTopPlus),
            cancelButton.trailingAnchor.constraint(
                equalTo: self.trailingAnchor, constant: Layout.Inset.trailingBottom),
            
            reportButton.leadingAnchor.constraint(
                equalTo: self.leadingAnchor, constant: Layout.Inset.leadingTop),
            reportButton.trailingAnchor.constraint(
                equalTo: self.trailingAnchor, constant: Layout.Inset.trailingBottom),
            reportButton.heightAnchor.constraint(
                equalToConstant: Layout.Button.height)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
