//
//  PlaceListHeaderView.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/08/07.
//

import UIKit

private enum Text: String {
    case setPosition = "검색 위치 설정"
    case howToSort = "정렬기준"
    case cancel = "취소"
}

final class PlaceListHeaderView: UIView {
    private lazy var locationPositionButton: UIButton = {
       let button = UIButton()
        
        let title = KakaoAPISortingQuery.shared.coordinate.value

        button.setTitle(title, for: .normal)
        button.setTitleColor(.gray3, for: .normal)
        button.titleLabel?.font = CFont.font.medium16
        button.titleLabel?.textAlignment = .left
        
        button.setImage(UIImage.sorting, for: .normal)

        button.semanticContentAttribute = .forceRightToLeft
        button.addTarget(
            self,
            action: #selector(locationPositionButtonTapped(_:)),
            for: .touchUpInside
        )
        
        return button
    }()
    
    private lazy var sortingByButton: UIButton = {
        let button = UIButton()
        
        let title = KakaoAPISortingQuery.shared.sorting.value
        
        button.setTitle(title, for: .normal)
        button.setTitleColor(.gray3, for: .normal)
        button.titleLabel?.font = CFont.font.medium16
        button.titleLabel?.textAlignment = .left

        button.setImage(UIImage.sorting, for: .normal)
        
        button.semanticContentAttribute = .forceRightToLeft
        button.addTarget(
            self,
            action: #selector(sortingByButtonTapped(_:)),
            for: .touchUpInside
        )
        
        return button
    }()
    
    var touchedLocationPositionButton: ((UIAlertController) -> Void)?
    var touchedSortingByButton: ((UIAlertController) -> Void)?
    var touchedCanActiveSort: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setupLayout() {
        self.backgroundColor = .gray7
        self.heightAnchor.constraint(equalToConstant: 55).isActive = true
        
        [
            locationPositionButton,
            sortingByButton
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            locationPositionButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            locationPositionButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            locationPositionButton.widthAnchor.constraint(equalToConstant: 98),
            
            sortingByButton.leadingAnchor.constraint(
                equalTo: locationPositionButton.trailingAnchor, constant: 10),
            sortingByButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            sortingByButton.widthAnchor.constraint(equalToConstant: 85)
            
        ])
    }
    
    // MARK: location Position Button 설정하기
    @objc private func locationPositionButtonTapped(_ sender: UIButton) {
        // 선택된것에 따른 색상관련 변수
        var isTop = false
        
        if sender.titleLabel?.text == KakaoSerachCoordinate.CenterCoordinate.value {
            isTop = true
        }
        
        let actionSheet = UIAlertController(
            title: Text.setPosition.rawValue,
            message: nil,
            preferredStyle: .actionSheet
        )
        
        let centerLocation = UIAlertAction(
            title: KakaoSerachCoordinate.CenterCoordinate.alertString,
            style: .default
        ) { _ in
            self.locationPositionButton.setTitle(
                KakaoSerachCoordinate.CenterCoordinate.value,
                for: .normal
            )
            
            KakaoAPISortingQuery.shared.coordinate = KakaoSerachCoordinate.CenterCoordinate
            
            self.touchedCanActiveSort?()
        }
        
        let myLocation = UIAlertAction(
            title: KakaoSerachCoordinate.MyCoordinate.alertString,
            style: .default
        ) { _ in
            self.locationPositionButton.setTitle(
                KakaoSerachCoordinate.MyCoordinate.value,
                for: .normal
            )
            
            KakaoAPISortingQuery.shared.coordinate = KakaoSerachCoordinate.MyCoordinate
            
            self.touchedCanActiveSort?()
        }
        
        let cancel = UIAlertAction(
            title: Text.cancel.rawValue,
            style: .cancel
        )
        
        centerLocation.setValue(
            isTop ? UIColor.main : UIColor.gray0,
            forKey: "titleTextColor"
        )
        myLocation.setValue(
            isTop ? UIColor.gray0 : UIColor.main,
            forKey: "titleTextColor"
        )
        cancel.setValue(
            UIColor.main,
            forKey: "titleTextColor"
        )
        
        [
            centerLocation,
            myLocation,
            cancel
        ].forEach {
            actionSheet.addAction($0)
        }
        
        touchedLocationPositionButton?(actionSheet)
    }
    
    // MARK: Sorting By Button 설정하기
    @objc private func sortingByButtonTapped(_ sender: UIButton) {
        var isTop = false
        
        if sender.titleLabel?.text == KakaoSearchHowToSort.accuracy.value {
            isTop = true
        }
        
        let actionSheet = UIAlertController(
            title: Text.howToSort.rawValue,
            message: nil,
            preferredStyle: .actionSheet
        )
        
        let accurancy = UIAlertAction(
            title: KakaoSearchHowToSort.accuracy.value,
            style: .default
        ) { _ in
            self.sortingByButton.setTitle(
                KakaoSearchHowToSort.accuracy.value,
                for: .normal
            )
            
            KakaoAPISortingQuery.shared.sorting = KakaoSearchHowToSort.accuracy
            
            self.touchedCanActiveSort?()
        }
    
        let distance = UIAlertAction(
            title: KakaoSearchHowToSort.distance.value,
            style: .default
        ) { _ in
            self.sortingByButton.setTitle(
                KakaoSearchHowToSort.distance.value,
                for: .normal
            )
            
            KakaoAPISortingQuery.shared.sorting = KakaoSearchHowToSort.distance
            
            self.touchedCanActiveSort?()
        }
        
        let cancel = UIAlertAction(
            title: Text.cancel.rawValue,
            style: .cancel
        )
        
        accurancy.setValue(
            isTop ? UIColor.main : UIColor.gray0,
            forKey: "titleTextColor"
        )
        distance.setValue(
            isTop ? UIColor.gray0 : UIColor.main,
            forKey: "titleTextColor"
        )
        cancel.setValue(
            UIColor.main,
            forKey: "titleTextColor"
        )
        
        [
            accurancy,
            distance,
            cancel
        ].forEach {
            actionSheet.addAction($0)
        }
        
        touchedSortingByButton?(actionSheet)
    }
}
