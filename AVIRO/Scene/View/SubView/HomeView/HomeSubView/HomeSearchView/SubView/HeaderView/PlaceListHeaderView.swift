//
//  PlaceListHeaderView.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/08/07.
//

import UIKit

final class PlaceListHeaderView: UIView {
    private lazy var locationPositionButton: UIButton = {
       let button = UIButton()
        
        button.setTitle("내 위치 중심", for: .normal)
        button.setImage(UIImage(named: "DownSorting"), for: .normal)
        button.setTitleColor(.gray3, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.semanticContentAttribute = .forceRightToLeft
        button.addTarget(self, action: #selector(locationPositionButtonTapped(_:)), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var sortingByButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("정확도순", for: .normal)
        button.setImage(UIImage(named: "DownSorting"), for: .normal)
        button.setTitleColor(.gray3, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.semanticContentAttribute = .forceRightToLeft
        button.addTarget(self, action: #selector(sortingByButtonTapped(_:)), for: .touchUpInside)
        
        return button
    }()
    
    var touchedLocationPositionButton: ((UIAlertController) -> Void)?
    var touchedSortingByButton: ((UIAlertController) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func makeLayout() {
        self.backgroundColor = .gray7
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
            
            sortingByButton.leadingAnchor.constraint(equalTo: locationPositionButton.trailingAnchor, constant: 10),
            sortingByButton.centerYAnchor.constraint(equalTo: locationPositionButton.centerYAnchor)
        ])
    }
    
    // MARK: location Position Button 설정하기
    @objc private func locationPositionButtonTapped(_ sender: UIButton) {
        var isTop = false
        
        if sender.titleLabel?.text == "지도 중심" {
            isTop = true
        }
        
        let actionSheet = UIAlertController(title: "검색 위치 설정", message: nil, preferredStyle: .actionSheet)
        
        let centerLocation = UIAlertAction(title: "지도 중심", style: .default) { _ in
            self.locationPositionButton.setTitle("지도 중심", for: .normal)
        }
    
        let myLocation = UIAlertAction(title: "내 위치 중심", style: .default) { _ in
            self.locationPositionButton.setTitle("내 위치 중심", for: .normal)
        }
        
        let cancel = UIAlertAction(title: "취소하기", style: .cancel)
        
        centerLocation.setValue(isTop ? UIColor.systemBlue : UIColor.gray2, forKey: "titleTextColor")
        myLocation.setValue(isTop ? UIColor.gray2 : UIColor.systemBlue, forKey: "titleTextColor")
        cancel.setValue(UIColor.systemRed, forKey: "titleTextColor")
        
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
        
        if sender.titleLabel?.text == "정확도순" {
            isTop = true
        }
        
        let actionSheet = UIAlertController(title: "정렬기준", message: nil, preferredStyle: .actionSheet)
        
        let accurancy = UIAlertAction(title: "정확도순", style: .default) { _ in
            self.sortingByButton.setTitle("정확도순", for: .normal)
        }
    
        let distance = UIAlertAction(title: "거리순", style: .default) { _ in
            self.sortingByButton.setTitle("거리순", for: .normal)
        }
        
        let cancel = UIAlertAction(title: "취소하기", style: .cancel)
        
        accurancy.setValue(isTop ? UIColor.systemBlue : UIColor.gray2, forKey: "titleTextColor")
        distance.setValue(isTop ? UIColor.gray2 : UIColor.systemBlue, forKey: "titleTextColor")
        cancel.setValue(UIColor.systemRed, forKey: "titleTextColor")
        
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
