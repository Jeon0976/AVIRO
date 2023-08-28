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
    
    private lazy var locationScrollView = UIScrollView()
    
    private lazy var editLocationTopView: EditLocationTopView = {
        let view = EditLocationTopView()
        
        return view
    }()
    
    private lazy var editLocationBottomView: EditLocationBottomView = {
        let view = EditLocationBottomView()
        
        view.tappedPushViewButton = { [weak self] in
            self?.presenter.pushAddressEditViewController()
        }
        
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
    
    private lazy var tapGesture = UITapGestureRecognizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        presenter.viewWillAppear()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        presenter.viewWillDisappear()
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
            locationScrollView,
            editPhoneView,
            editWorkingHoursView,
            editHomePageView
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            safeAreaView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            locationScrollView.topAnchor.constraint(equalTo: safeAreaView.topAnchor),
            locationScrollView.leadingAnchor.constraint(equalTo: safeAreaView.leadingAnchor),
            locationScrollView.trailingAnchor.constraint(equalTo: safeAreaView.trailingAnchor),
            locationScrollView.bottomAnchor.constraint(equalTo: safeAreaView.bottomAnchor),
            
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
            locationScrollView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            editLocationTopView.topAnchor.constraint(
                equalTo: locationScrollView.contentLayoutGuide.topAnchor, constant: 20),
            editLocationTopView.leadingAnchor.constraint(
                equalTo: locationScrollView.frameLayoutGuide.leadingAnchor, constant: 16),
            editLocationTopView.trailingAnchor.constraint(
                equalTo: locationScrollView.frameLayoutGuide.trailingAnchor, constant: -16),
            
            editLocationBottomView.topAnchor.constraint(
                equalTo: editLocationTopView.bottomAnchor, constant: 15),
            editLocationBottomView.leadingAnchor.constraint(
                equalTo: locationScrollView.frameLayoutGuide.leadingAnchor, constant: 16),
            editLocationBottomView.trailingAnchor.constraint(
                equalTo: locationScrollView.frameLayoutGuide.trailingAnchor, constant: -16),
            editLocationBottomView.bottomAnchor.constraint(
                equalTo: locationScrollView.contentLayoutGuide.bottomAnchor, constant: -20)
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
        
       activeLocation()
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
        
        locationScrollView.isHidden = false
    }
    
    private func activePhone() {
        locationScrollView.isHidden = true
        editHomePageView.isHidden = true
        editWorkingHoursView.isHidden = true
        
        editPhoneView.isHidden = false
    }
    
    private func activeWorkingHours() {
        editHomePageView.isHidden = true
        locationScrollView.isHidden = true
        editPhoneView.isHidden = true
        
        editWorkingHoursView.isHidden = false
    }
    
    private func activeHomepage() {
        editWorkingHoursView.isHidden = true
        locationScrollView.isHidden = true
        editPhoneView.isHidden = true
        
        editHomePageView.isHidden = false
    }
    
    func makeGesture() {
        view.addGestureRecognizer(tapGesture)
        tapGesture.delegate = self
    }
    
    func isDetailFieldCheckBeforeKeyboardShowAndHide(notification: NSNotification) -> Bool {
        return self.editLocationBottomView.checkIsDetailField(notification: notification)
    }
    
    func keyboardWillShow(height: CGFloat) {
        self.navigationController?.isNavigationBarHidden = true
        UIView.animate(
            withDuration: 0.3,
            animations: { self.safeAreaView.transform = CGAffineTransform(
                translationX: 0,
                y: -(height))
            }
        )
    }
    
    func keyboardWillHide() {
        self.navigationController?.isNavigationBarHidden = false

        self.safeAreaView.transform = .identity
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
    
    func dataBindingPhone(phone: String) {
        editPhoneView.dataBinding(phone)
    }
    
    func dataBindingHomepage(homepage: String) {
        editHomePageView.dataBinding(homepage)
    }
    
    func pushAddressEditViewController(placeMarkerModel: MarkerModel) {
        let vc = EditLocationDetailViewController()
        let presenter = EditLocationDetailPresenter(
            viewController: vc,
            placeMarkerModel: placeMarkerModel
        )
        
        presenter.afterChangedAddress = { [weak self] address in
            guard let address = address else { return }
            
            // TODO: 수정 예정
            self?.editLocationBottomView.changedAddressLabel(address)
        }
        
        vc.presenter = presenter
        
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension EditPlaceInfoViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view is EnrollField {
            return false
        }
        
        view.endEditing(true)
        return true
    }
}
