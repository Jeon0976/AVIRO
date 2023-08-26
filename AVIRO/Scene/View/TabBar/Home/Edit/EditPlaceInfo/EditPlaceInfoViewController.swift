//
//  EditPlaceInfoEditViewController.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/08/25.
//

import UIKit

import NMapsMap

final class EditPlaceInfoViewController: UIViewController {
    lazy var presenter = EditPlaceInfoPresenter(viewController: self)
    
    private let items = ["위치", "전화번호", "영업시간", "홈페이지"]
    
    private lazy var topLine: UIView = {
        let view = UIView()
        
        view.backgroundColor = .gray5
        
        return view
    }()
    
    private lazy var segmentedControl: UnderlineSegmentedControl = {
        let segmented = UnderlineSegmentedControl(items: items)
        
        segmented.setAttributedTitle()
        segmented.backgroundColor = .gray7
        segmented.selectedSegmentIndex = 0
        segmented.addTarget(self, action: #selector(segmentedChanged(segment:)), for: .valueChanged)
        
        return segmented
    }()
    
    private lazy var safeAreaView: UIView = {
        let view = UIView()
        
        view.backgroundColor = .gray6
        
        return view
    }()
    
    private lazy var scrollView = UIScrollView()
    
    private lazy var editLocationTopView: EditLocationTopView = {
        let view = EditLocationTopView()
        
        return view
    }()
    
    private lazy var editLocationBottomView: EditLocationBottomView = {
        let view = EditLocationBottomView()
        
        return view
    }()
    
    private lazy var editPhoneView: EditPhoneView = {
        let view = EditPhoneView()
        
        return view
    }()
    
    private lazy var editWorkingHoursView: EditWorkingHoursView = {
        let view = EditWorkingHoursView()
        
        return view
    }()
    
    private lazy var editHomePageView: EditHomePageView = {
        let view = EditHomePageView()
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        presenter.dataBinding()
    }
}

extension EditPlaceInfoViewController: EditPlaceInfoProtocol {
    func makeLayout() {
        [
            topLine,
            segmentedControl,
            safeAreaView
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            topLine.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            topLine.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1),
            topLine.heightAnchor.constraint(equalToConstant: 0.5),
            
            segmentedControl.topAnchor.constraint(equalTo: topLine.bottomAnchor),
            segmentedControl.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            segmentedControl.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            segmentedControl.heightAnchor.constraint(equalToConstant: 50),
            
            safeAreaView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor),
            safeAreaView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            safeAreaView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            safeAreaView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        
        makeSafeAreaViewLayout()
    }
    
    private func makeSafeAreaViewLayout() {
        [
            scrollView,
            editPhoneView,
            editWorkingHoursView,
            editHomePageView
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            safeAreaView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeAreaView.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: safeAreaView.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: safeAreaView.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeAreaView.bottomAnchor),
            
            editPhoneView.topAnchor.constraint(equalTo: safeAreaView.topAnchor, constant: 20),
            editPhoneView.leadingAnchor.constraint(equalTo: safeAreaView.leadingAnchor, constant: 16),
            editPhoneView.trailingAnchor.constraint(equalTo: safeAreaView.trailingAnchor, constant: -16),
            
            editWorkingHoursView.topAnchor.constraint(equalTo: safeAreaView.topAnchor, constant: 20),
            editWorkingHoursView.leadingAnchor.constraint(equalTo: safeAreaView.leadingAnchor, constant: 16),
            editWorkingHoursView.trailingAnchor.constraint(equalTo: safeAreaView.trailingAnchor, constant: -16),
            
            editHomePageView.topAnchor.constraint(equalTo: safeAreaView.topAnchor, constant: 20),
            editHomePageView.leadingAnchor.constraint(equalTo: safeAreaView.leadingAnchor, constant: 16),
            editHomePageView.trailingAnchor.constraint(equalTo: safeAreaView.trailingAnchor, constant: -16)
        ])
        
        [
            editLocationTopView,
            editLocationBottomView
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            scrollView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            editLocationTopView.topAnchor.constraint(
                equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 20),
            editLocationTopView.leadingAnchor.constraint(
                equalTo: scrollView.frameLayoutGuide.leadingAnchor, constant: 16),
            editLocationTopView.trailingAnchor.constraint(
                equalTo: scrollView.frameLayoutGuide.trailingAnchor, constant: -16),
            
            editLocationBottomView.topAnchor.constraint(
                equalTo: editLocationTopView.bottomAnchor, constant: 15),
            editLocationBottomView.leadingAnchor.constraint(
                equalTo: scrollView.frameLayoutGuide.leadingAnchor, constant: 16),
            editLocationBottomView.trailingAnchor.constraint(
                equalTo: scrollView.frameLayoutGuide.trailingAnchor, constant: -16),
            editLocationBottomView.bottomAnchor.constraint(
                equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -20)
        ])
        
    }
    
    func makeAttribute() {
        self.view.backgroundColor = .gray7

        self.setupCustomBackButton()
        navigationController?.navigationBar.isHidden = false
        
        navigationItem.title = "정보 수정 요청하기"
        
        let rightBarButton = UIBarButtonItem(title: "요청하기", style: .plain, target: self, action: #selector(editStore))
        navigationItem.rightBarButtonItem = rightBarButton
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        if let tabBarController = self.tabBarController as? TabBarViewController {
            tabBarController.hiddenTabBarIncludeIsTranslucent(true)
        }
        
        editPhoneView.isHidden = true
        editHomePageView.isHidden = true
        editWorkingHoursView.isHidden = true
        
        scrollView.isHidden = false
    }
    
    @objc private func segmentedChanged(segment: UISegmentedControl) {
        switch segment.selectedSegmentIndex {
        case 0:
            activeLocation()
        case 1:
            activePhone()
        case 2:
            activeWorkingHours()
        case 3:
            activeHomepage()
        default:
            break
        }
    }
    
    private func activeLocation() {
        editPhoneView.isHidden = true
        editHomePageView.isHidden = true
        editWorkingHoursView.isHidden = true
        
        scrollView.isHidden = false
    }
    
    private func activePhone() {
        scrollView.isHidden = true
        editHomePageView.isHidden = true
        editWorkingHoursView.isHidden = true
        
        editPhoneView.isHidden = false
    }
    
    private func activeWorkingHours() {
        editHomePageView.isHidden = true
        scrollView.isHidden = true
        editPhoneView.isHidden = true
        
        editWorkingHoursView.isHidden = false
    }
    
    private func activeHomepage() {
        editWorkingHoursView.isHidden = true
        scrollView.isHidden = true
        editPhoneView.isHidden = true
        
        editHomePageView.isHidden = false
    }
    
    @objc private func editStore() {

    }
    
    func dataBindingLocation(title: String,
                             category: String,
                             marker: NMFMarker,
                             address: String
    ) {
        editLocationTopView.dataBinding(title: title, category: category)
        editLocationBottomView.dataBinding(marker: marker, address: address)
    }
}
