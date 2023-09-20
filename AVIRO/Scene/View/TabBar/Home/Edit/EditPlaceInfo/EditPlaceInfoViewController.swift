//
//  EditPlaceInfoEditViewController.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/08/25.
//

import UIKit

import NMapsMap

private enum Segmented: String {
    case location = "위치"
    case phone = "전화번호"
    case operationHour = "영업시간"
    case homepage = "홈페이지"
}

final class EditPlaceInfoViewController: UIViewController {
    lazy var presenter = EditPlaceInfoPresenter(viewController: self)
    
    private let items = [
        Segmented.location.rawValue,
        Segmented.phone.rawValue,
        Segmented.operationHour.rawValue,
        Segmented.homepage.rawValue
    ]
    
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
    
    private lazy var editOperationHoursView: EditOperatingHoursView = {
        let view = EditOperatingHoursView()
        
        return view
    }()
    
    private lazy var editHomePageView: EditHomePageView = {
        let view = EditHomePageView()
        
        return view
    }()
    
    private lazy var tapGesture = UITapGestureRecognizer()
    private lazy var leftSwipeGesture = UISwipeGestureRecognizer()
    private lazy var rightSwipeGesture = UISwipeGestureRecognizer()
    
    private lazy var blurEffectView = UIVisualEffectView()
    private lazy var operationHourChangebleView = EditOperationHourChangebleView()
    
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
    func setupLayout() {
        [
            topLine,
            segmentedControl,
            safeAreaView,
            blurEffectView,
            operationHourChangebleView
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
            safeAreaView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            
            blurEffectView.topAnchor.constraint(equalTo: self.view.topAnchor),
            blurEffectView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            blurEffectView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            blurEffectView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            
            operationHourChangebleView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            operationHourChangebleView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            operationHourChangebleView.widthAnchor.constraint(
                equalTo: self.view.widthAnchor, multiplier: 1, constant: -32)
        ])
        
        setupSafeAreaViewLayout()
    }
    
    private func setupSafeAreaViewLayout() {
        [
            scrollView
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            safeAreaView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeAreaView.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: safeAreaView.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: safeAreaView.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeAreaView.bottomAnchor)
        ])
        
        [
            editLocationTopView,
            editLocationBottomView,
            editPhoneView,
            editOperationHoursView,
            editHomePageView
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
                equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -20),
            
            editPhoneView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 20),
            editPhoneView.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor, constant: 16),
            editPhoneView.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor, constant: -16),
            
            editOperationHoursView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 20),
            editOperationHoursView.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor, constant: 16),
            editOperationHoursView.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor, constant: -16),
            editOperationHoursView.bottomAnchor.constraint(equalTo: scrollView.frameLayoutGuide.bottomAnchor),
            
            editHomePageView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 20),
            editHomePageView.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor, constant: 16),
            editHomePageView.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor, constant: -16)
        ])
        
    }
    
    func setupAttribute() {
        self.view.backgroundColor = .gray7
        
        self.setupCustomBackButton()
        navigationController?.navigationBar.isHidden = false
        
        navigationItem.title = "정보 수정 요청하기"
        
        let rightBarButton = UIBarButtonItem(
            title: "요청하기",
            style: .plain,
            target: self,
            action: #selector(editStoreButtonTapped)
        )
        
        navigationItem.rightBarButtonItem = rightBarButton
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        if let tabBarController = self.tabBarController as? TabBarViewController {
            tabBarController.hiddenTabBarIncludeIsTranslucent(true)
        }
        
        activeLocationView()
    }
    
    func setupBlurEffect() {
        let blurEffectStyle = UIBlurEffect(style: UIBlurEffect.Style.dark)
        
        blurEffectView.effect = blurEffectStyle
        blurEffectView.frame = view.bounds
        blurEffectView.alpha = 0.6
        blurEffectView.isHidden = true
        operationHourChangebleView.isHidden = true
    }
    
    
    func setupGesture() {
        [
            leftSwipeGesture,
            rightSwipeGesture,
            tapGesture
        ].forEach {
            view.addGestureRecognizer($0)
        }
        
        tapGesture.delegate = self
        leftSwipeGesture.direction = .left
        rightSwipeGesture.direction = .right
        
        leftSwipeGesture.addTarget(self, action: #selector(swipeGestureActive(_:)))
        rightSwipeGesture.addTarget(self, action: #selector(swipeGestureActive(_:)))
    }
    
    func whenViewWillAppearSelectedIndex(_ index: Int) {
        segmentedControl.selectedSegmentIndex = index
        whenActiveSegmentedChanged()
    }
    
    func handleClosure() {
        editLocationTopView.afterChangedTitle = { [weak self] title in
            self?.presenter.afterChangedTitle = title
        }
        
        editLocationTopView.afterChangedCategory = { [weak self] category in
            self?.presenter.afterChangedCategory = category
        }
        
        editLocationBottomView.tappedPushViewButton = { [weak self] in
            self?.presenter.pushAddressEditViewController()
        }
        
        editLocationBottomView.afterChangedAddress = { [weak self] address in
            self?.presenter.afterChangedAddress = address
        }
        
        editLocationBottomView.afterChangedDetailAddress = { [weak self] addressDetail in
            self?.presenter.afterChangedAddressDetail = addressDetail
        }

        editPhoneView.afterChangedPhone = { [weak self] phone in
            self?.presenter.afterChangedPhone = phone
        }
        
        editOperationHoursView.openChangebleOperationHourView = { [weak self] timeModel in
            self?.showOperationHourChangebleView(true, timeModel)
        }
        
        editOperationHoursView.afterChangedOperationHour = { [weak self] editOperationHourModel in
            self?.presenter.afterChangedOperationHour = editOperationHourModel
        }
        
        operationHourChangebleView.cancelTapped = { [weak self] in
            self?.showOperationHourChangebleView(false, nil)
        }
        
        editHomePageView.afterChagnedURL = { [weak self] url in
            self?.presenter.afterChangedURL = url
        }
        
        operationHourChangebleView.afterEditButtonTapped = { [weak self] editOperationHoursModel in
            self?.showOperationHourChangebleView(false, nil)
            self?.editOperationHoursView.editOperationHour(editOperationHoursModel)
        }
    }
    
    private func showOperationHourChangebleView(
        _ show: Bool,
        _ operationHoursModel: EditOperationHoursModel?
    ) {
        navigationController?.navigationBar.isUserInteractionEnabled = !show
        blurEffectView.isHidden = !show
        operationHourChangebleView.isHidden = !show
        
        guard let operationHoursModel = operationHoursModel else { return }
        operationHourChangebleView.setupDataBinding(operationHoursModel)
    }
    
    @objc private func editStoreButtonTapped() {
        presenter.afterEditButtonTapped()
        self.view.isUserInteractionEnabled = false
    }
    
    @objc private func swipeGestureActive(_ gesture: UISwipeGestureRecognizer) {
        if blurEffectView.isHidden {
            if gesture.direction == .right && segmentedControl.selectedSegmentIndex != 0 {
                segmentedControl.selectedSegmentIndex -= 1
            } else if gesture.direction == .left && segmentedControl.selectedSegmentIndex != 3 {
                segmentedControl.selectedSegmentIndex += 1
            }
            
            whenActiveSegmentedChanged()
        }
    }
    
    @objc private func segmentedChanged(segment: UISegmentedControl) {
        if blurEffectView.isHidden {
            whenActiveSegmentedChanged()
        }
    }
    
    private func whenActiveSegmentedChanged() {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            activeLocationView()
        case 1:
            activePhoneView()
        case 2:
            activeOperationHoursView()
        case 3:
            activeHomepageView()
        default:
            break
        }
    }
    
    private func activeLocationView() {
        editPhoneView.isHidden = true
        editHomePageView.isHidden = true
        editOperationHoursView.isHidden = true
        
        editLocationTopView.isHidden = false
        editLocationBottomView.isHidden = false
    }
    
    private func activePhoneView() {
        editLocationTopView.isHidden = true
        editLocationBottomView.isHidden = true
        editHomePageView.isHidden = true
        editOperationHoursView.isHidden = true
        
        editPhoneView.isHidden = false
    }
    
    private func activeOperationHoursView() {
        editHomePageView.isHidden = true
        editLocationTopView.isHidden = true
        editLocationBottomView.isHidden = true
        editPhoneView.isHidden = true
        
        editOperationHoursView.isHidden = false
    }
    
    private func activeHomepageView() {
        editOperationHoursView.isHidden = true
        editLocationTopView.isHidden = true
        editLocationBottomView.isHidden = true
        editPhoneView.isHidden = true
        
        editHomePageView.isHidden = false
    }
    
    func isDetailFieldCheckBeforeKeyboardShowAndHide(notification: NSNotification) -> Bool {
        return self.editLocationBottomView.checkIsDetailField(notification: notification)
    }
    
    func keyboardWillShow(height: CGFloat) {
        self.navigationController?.isNavigationBarHidden = true
        self.segmentedControl.isHidden = true
        
        UIView.animate(
            withDuration: 0.3,
            animations: { self.scrollView.transform = CGAffineTransform(
                translationX: 0,
                y: -(height))
            }
        )
    }
    
    func keyboardWillHide() {
        self.navigationController?.isNavigationBarHidden = false
        self.segmentedControl.isHidden = false
        
        self.scrollView.transform = .identity
    }
    
    func dataBindingLocation(title: String,
                             category: String,
                             marker: NMFMarker,
                             address: String,
                             address2: String
    ) {
        editLocationTopView.dataBinding(
            title: title,
            category: category
        )
        editLocationBottomView.dataBinding(
            marker: marker,
            address: address,
            address2: address2
        )
    }
    
    func dataBindingPhone(phone: String) {
        editPhoneView.dataBinding(phone)
    }
    
    func dataBindingOperatingHours(operatingHourModels: [EditOperationHoursModel]) {
        editOperationHoursView.dataBinding(operatingHourModels)
    }
    
    func dataBindingHomepage(homepage: String) {
        editHomePageView.dataBinding(homepage)
    }
    
    func pushAddressEditViewController(placeMarkerModel: MarkerModel) {
        let vc = ChangeableAddressViewController()
        let presenter = ChangeableAddressPresenter(
            viewController: vc,
            placeMarkerModel: placeMarkerModel
        )
        
        // MARK: Address가 봐뀐 후 메소드
        presenter.afterChangedAddress = { [weak self] address in
            guard let address = address else { return }
            
            self?.editLocationBottomView.changedAddressLabel(address)
        }
        
        vc.presenter = presenter
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func updateNaverMap(_ latLng: NMGLatLng) {
        editLocationBottomView.changedNaverMap(latLng)
    }
    
    func editStoreButtonChangeableState(_ state: Bool) {
        navigationItem.rightBarButtonItem?.isEnabled = state
    }
    
    func popViewController() {
        navigationController?.popViewController(animated: true)
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
