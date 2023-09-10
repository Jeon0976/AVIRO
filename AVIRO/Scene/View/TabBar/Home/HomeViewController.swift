//
//  HomeViewController.swift
//  VeganRestaurant
//
//  Created by 전성훈 on 2023/05/19.
//

import UIKit

import NMapsMap
import Toast_Swift

final class HomeViewController: UIViewController {
    lazy var presenter = HomeViewPresenter(viewController: self)
        
    private lazy var naverMapView = NMFMapView()
    
    // 검색 기능 관련
    private lazy var searchTextField = MainField()

    // 내 위치 최신화 관련
    private lazy var loadLocationButton = HomeMapReferButton()
    private lazy var starButton = HomeMapReferButton()
    
    private lazy var downBackButton = HomeTopButton()
    private lazy var flagButton = HomeTopButton()
    
    private(set) lazy var placeView = PlaceView()
    private(set) var placeViewTopConstraint: NSLayoutConstraint?
    private(set) var searchTextFieldTopConstraint: NSLayoutConstraint?
    
    private lazy var tapGesture = UITapGestureRecognizer()

    /// view 위 아래 움직일때마다 height값과 layout의 시간 차 발생?하는것 같음
    private var isSlideUpView = false
    
    // store 뷰 관련
    private var upGesture = UISwipeGestureRecognizer()
    private var downGesture = UISwipeGestureRecognizer()
    // 최초 화면 뷰
    var firstPopupView = HomeFirstPopUpView()
    var blurEffectView = UIVisualEffectView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        presenter.locationAuthorization()
        presenter.viewDidLoad()
        presenter.makeNotification()
        presenter.loadVeganData()
        handleClosure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        presenter.viewWillAppear()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        presenter.viewDidAppear()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        presenter.viewWillDisappear()
    }
}

extension HomeViewController: HomeViewProtocol {
    // MARK: Layout
    func makeLayout() {
        [
            naverMapView,
            loadLocationButton,
            starButton,
            searchTextField,
            placeView,
            flagButton,
            downBackButton
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }

        NSLayoutConstraint.activate([
            // naverMapView
            naverMapView.topAnchor.constraint(
                equalTo: view.topAnchor),
            naverMapView.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 40),
            naverMapView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor),
            naverMapView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor),
            
            // loadLoactionButton
            loadLocationButton.bottomAnchor.constraint(equalTo: placeView.topAnchor, constant: -20),
            loadLocationButton.trailingAnchor.constraint(
                equalTo: naverMapView.trailingAnchor, constant: -20),
            
            // starButton
            starButton.bottomAnchor.constraint(equalTo: loadLocationButton.topAnchor, constant: -10),
            starButton.trailingAnchor.constraint(equalTo: loadLocationButton.trailingAnchor),
            
            // searchTextField
            searchTextField.leadingAnchor.constraint(
                equalTo: naverMapView.leadingAnchor, constant: Layout.Inset.leadingTop),
            searchTextField.trailingAnchor.constraint(
                equalTo: naverMapView.trailingAnchor, constant: Layout.Inset.trailingBottom),
            
            // placeView
            placeView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            placeView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            placeView.heightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.heightAnchor),
//
            flagButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16),
            flagButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 18),
            flagButton.widthAnchor.constraint(equalToConstant: 40),
            flagButton.heightAnchor.constraint(equalToConstant: 40),
            
            downBackButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
            downBackButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 18),
            downBackButton.widthAnchor.constraint(equalToConstant: 40),
            downBackButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        searchTextFieldTopConstraint = searchTextField.topAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16)
        searchTextFieldTopConstraint?.isActive = true
        
        placeViewTopConstraint = placeView.topAnchor.constraint(
            equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        placeViewTopConstraint?.isActive = true
    }
    
    // MARK: Attribute
    func makeAttribute() {
        // Navigation, View, TabBar
        view.backgroundColor = .gray7

        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem

        // NFMAP
        naverMapView.addCameraDelegate(delegate: self)
        naverMapView.touchDelegate = self
        naverMapView.mapType = .basic
        naverMapView.isIndoorMapEnabled = true
        naverMapView.minZoomLevel = 5.0
        naverMapView.extent = NMGLatLngBounds(southWestLat: 31.43, southWestLng: 122.37, northEastLat: 44.35, northEastLng: 132)
        
        // searchTextField
        searchTextField.makePlaceHolder("어디로 이동할까요?")
        searchTextField.makeShadow()
        searchTextField.delegate = self
        
        // downBack
        downBackButton.setImage(UIImage(named: "DownBack"), for: .normal)
        downBackButton.addTarget(self, action: #selector(downBackButtonTapped(_:)), for: .touchUpInside)
        
        // flag
        flagButton.setImage(UIImage(named: "Flag"), for: .normal)
        flagButton.addTarget(self, action: #selector(flagButtonTapped(_:)), for: .touchUpInside)
        
        // lodeLocationButton
        loadLocationButton.setImage(UIImage(named: "current-location")?.withTintColor(.gray1!), for: .normal)
        loadLocationButton.setImage(UIImage(named: "current-locationDisable")?.withTintColor(.gray4!), for: .disabled)
        loadLocationButton.addTarget(self, action: #selector(locationButtonTapped(_:)), for: .touchUpInside)
        
        // starButton
        starButton.setImage(UIImage(named: "star")?.withTintColor(.gray1!), for: .normal)
        starButton.setImage(UIImage(named: "selectedStar"), for: .selected)
        starButton.setImage(UIImage(named: "starDisable")?.withTintColor(.gray4!), for: .disabled)
        starButton.addTarget(self, action: #selector(starButtonTapped(_ :)), for: .touchUpInside)
        
    }
    
    // MARK: Gesture 설정
    func makeGesture() {
        placeView.addGestureRecognizer(upGesture)
        placeView.addGestureRecognizer(downGesture)

        upGesture.direction = .up
        downGesture.direction = .down
        
        upGesture.addTarget(self, action: #selector(swipeGestureActived(_:)))
        downGesture.addTarget(self, action: #selector(swipeGestureActived(_:)))
        
        view.addGestureRecognizer(tapGesture)
        tapGesture.delegate = self
    }
    
    // MARK: SlideView 설정
    func makeSlideView() {
        // first popup view
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        blurEffectView.effect = blurEffect
        blurEffectView.frame = view.bounds
        blurEffectView.alpha = 0.4
        
        firstPopupView.cancelButton.addTarget(self,
                                              action: #selector(firstPopupViewDelete),
                                              for: .touchUpInside
        )
        firstPopupView.reportButton.addTarget(self,
                                              action: #selector(firstPopupViewReport(_:)),
                                              for: .touchUpInside
        )
        
        [
            blurEffectView,
            firstPopupView
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            // firstPopUpView
            firstPopupView.bottomAnchor.constraint(
                equalTo: view.bottomAnchor),
            firstPopupView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor),
            firstPopupView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor),
            firstPopupView.heightAnchor.constraint(
                equalToConstant: Layout.SlideView.firstHeight)
        ])
    }
    
    // MARK: Keyboard Will Show
    func keyboardWillShow(height: CGFloat) {
        let tabbarHeight = tabBarController?.tabBar.frame.height ?? 0
        let result = height - tabbarHeight
        
        placeView.keyboardWillShow(height: result)
    }
    
    // MARK: Keyboard Will Hide
    func keyboardWillHide() {
        placeView.keyboardWillHide()
    }
    
    // MARK: View Will Appear할 때 navigation & Tab Bar hidden Setting
    func whenViewWillAppear() {
        navigationController?.navigationBar.isHidden = true
        
        // TabBar Controller
        if let tabBarController = self.tabBarController as? TabBarViewController {
            tabBarController.hiddenTabBarIncludeIsTranslucent(false)
        }
        
        naverMapView.isHidden = false
    }

    func whenAfterPopEditPage() {
        naverMapView.isHidden = true
    }
    
    func whenViewWillAppearAfterSearchDataNotInAVIRO() {
        whenViewWillAppearInitPlaceView()
    }

    // MARK: 위치 denided or approval
    // 위치 denied 할 때
    func ifDenied() {
        MyCoordinate.shared.longitude = 129.118924
        MyCoordinate.shared.latitude = 35.153354
        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: 35.153354, lng: 129.118924))
        naverMapView.moveCamera(cameraUpdate)
    }
    
    // 위치 승인 되었을 때
    func requestSuccess() {
        naverMapView.positionMode = .direction
    }
    
    // MARK: center 위치 coordinate 저장하기
    func saveCenterCoordinate() {
        let center = naverMapView.cameraPosition.target
        presenter.saveCenterCoordinate(center)
    }
    
    // MARK: Marker Map에 대입하는 메소드
    func loadMarkers(_ markers: [NMFMarker]) {
        markers.forEach {
            $0.mapView = naverMapView
        }
    }
    
    // MARK: Map Star button True
    func afterLoadStarButton(noMarkers: [NMFMarker],
                             starMarkers: [NMFMarker]
    ) {
        noMarkers.forEach {
            $0.mapView = nil
        }
        
        starMarkers.forEach {
            $0.mapView = naverMapView
        }
    }

    // MARK: AVIRO에 데이터가 없을 때 지도 이동
    func moveToCameraWhenNoAVIRO(_ lng: Double, _ lat: Double) {
        let latlng = NMGLatLng(lat: lat, lng: lng)
        let cameraUpdate = NMFCameraUpdate(scrollTo: latlng, zoomTo: 14)
        cameraUpdate.animation = .fly
        cameraUpdate.animationDuration = 0.25

        naverMapView.moveCamera(cameraUpdate)
    }
    
    // MARK: AVIRO에 데이터가 있을 때 지도 이동
    func moveToCameraWhenHasAVIRO(_ markerModel: MarkerModel) {
        let latlng = markerModel.marker.position
        let cameraUpdate = NMFCameraUpdate(scrollTo: latlng, zoomTo: 14)
        cameraUpdate.animation = .easeIn
        cameraUpdate.animationDuration = 0.25
        popupPlaceView()
        naverMapView.moveCamera(cameraUpdate)
    }
    
    // 최초 데이터를 받기 전 popup
    private func popupPlaceView() {
        placeViewPopUp()
        isSlideUpView = false
        placeView.isLoadingTopView = true
    }
    
    // MARK: place view에 data binding
    // TODO: 수정 예정
    func afterClickedMarker(placeModel: PlaceTopModel,
                            placeId: String,
                            isStar: Bool
    ) {
        placeView.summaryDataBinding(placeModel: placeModel,
                                     placeId: placeId,
                                     isStar: isStar
        )
    }
    
    func afterSlideupPlaceView(infoModel: PlaceInfoData?,
                               menuModel: PlaceMenuData?,
                               reviewsModel: PlaceReviewsData?
    ) {
        // MARK: 다 하나씩 쪼겔 필요 있음
        placeView.allDataBinding(infoModel: infoModel,
                                 menuModel: menuModel,
                                 reviewsModel: reviewsModel
        )
    }
    
    func isSuccessReportPlaceActionSheet() {
        let alertController = UIAlertController(
            title: "신고가 완료되었어요",
            message: "3건 이상의 신고가 들어오면\n가게는 자동으로 삭제돼요.",
            preferredStyle: .alert
        )
        
        let check = UIAlertAction(title: "확인", style: .cancel)
        
        [
            check
        ].forEach {
            alertController.addAction($0)
        }
        
        present(alertController, animated: true)
    }
    
    func pushEditPlaceInfoViewController(placeMarkerModel: MarkerModel,
                                         placeId: String,
                                         placeSummary: PlaceSummaryData,
                                         placeInfo: PlaceInfoData
    ) {
        let vc = EditPlaceInfoViewController()
        let presenter = EditPlaceInfoPresenter(viewController: vc,
                                               placeMarkerModel: placeMarkerModel,
                                               placeId: placeId,
                                               placeSummary: placeSummary,
                                               placeInfo: placeInfo
        )
        
        vc.presenter = presenter
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func pushEditMenuViewController(placeId: String,
                                    isAll: Bool,
                                    isSome: Bool,
                                    isRequest: Bool,
                                    menuArray: [MenuArray]) {
        let vc = EditMenuViewController()
        let presenter = EditMenuPresenter(viewController: vc,
                                          placeId: placeId,
                                          isAll: isAll,
                                          isSome: isSome,
                                          isRequest: isRequest,
                                          menuArray: menuArray
        )
        
        presenter.afterEditMenuChangedMenus = { [weak self] in
            self?.presenter.afterEditMenu()
        }
        
        presenter.afterEditMenuChangedVeganMarker = { [weak self] changedMarkerModel in
            self?.presenter.afterEditMenuChangedMarker(changedMarkerModel)
        }
        
        vc.presenter = presenter
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func refreshMenuView(_ menuData: PlaceMenuData?) {
        placeView.menuModelBinding(menuModel: menuData)
    }
    
    func refreshMapPlace(_ mapPlace: MapPlace) {
        placeView.updateMapPlace(mapPlace)
    }
    
    func deleteMyReviewInView(_ commentId: String) {
        placeView.deleteMyReview(commentId)
    }
}

// MARK: View Refer & Objc Action
extension HomeViewController {
    func homeButtonIsHidden(_ hidden: Bool) {
        loadLocationButton.isHidden = hidden
        starButton.isHidden = hidden
    }
    
    func viewNaviButtonHidden(_ hidden: Bool) {
        downBackButton.isHidden = hidden
        flagButton.isHidden = hidden
    }
    
    // MARK: Slide UP View 할때 지도 이동
    func moveToCameraWhenSlideUpView() {
        let yPosition = naverMapView.frame.height * 1/4
        let point = CGPoint(x: 0, y: -yPosition)
        
        let cameraUpdate = NMFCameraUpdate(scrollBy: point)
        cameraUpdate.animation = .linear
        cameraUpdate.animationDuration = 0.2
        
        naverMapView.moveCamera(cameraUpdate)
    }
    
    // MARK: Slide -> Pop Up View 할때 지도 이동
    func moveToCameraWhenPopupView() {
        let yPosition = naverMapView.frame.height * 1/4
        let point = CGPoint(x: 0, y: yPosition)
        
        let cameraUpdate = NMFCameraUpdate(scrollBy: point)
        cameraUpdate.animation = .linear
        cameraUpdate.animationDuration = 0.2
        
        naverMapView.moveCamera(cameraUpdate)
    }
    
    // MARK: 클로저 함수 Binding 처리
    private func handleClosure() {
        placeView.whenFullBack = { [weak self] in
            self?.naverMapView.isHidden = false
            self?.placeViewPopUpAfterInitPlacePopViewHeight()
        }
        
        placeView.whenShareTapped = { [weak self] shareObject in
            let vc = UIActivityViewController(activityItems: shareObject, applicationActivities: nil)
            vc.popoverPresentationController?.permittedArrowDirections = []
            
            vc.popoverPresentationController?.sourceView = self?.view
            self?.present(vc, animated: true)
        }
        
        placeView.whenTopViewStarTapped = { [weak self] selected in
            let title: String = selected ? "즐겨찾기가 추가되었습니다." : "즐겨찾기가 삭제되었습니다."
            self?.makeToastButton(title)
            self?.presenter.updateBookmark(selected)
        }
        
        placeView.editPlaceInfo = { [weak self] in
            self?.presenter.editPlaceInfo()
        }
        
        placeView.editMenu = { [weak self] in
            self?.presenter.editMenu()
        }
        
        // TODO: api 요청 성공 하면 view 바뀌게 수정
        placeView.whenUploadReview = { [weak self] postReviewModel in
            self?.presenter.uploadReview(postReviewModel)
        }
        
        placeView.whenAfterEditReview = { [weak self] postReviewEditModel in
            self?.presenter.editMyReview(postReviewEditModel)
        }
        
        placeView.reportReview = { [weak self] commentId in
            self?.makeReportReviewAlert(commentId)
        }
        
        placeView.editMyReview = { [weak self] commentId in
            self?.makeEditMyReviewAlert(commentId)
        }
    }
    
    private func makeToastButton(_ title: String) {
        var style = ToastStyle()
        style.cornerRadius = 14
        style.backgroundColor = .gray3?.withAlphaComponent(0.7) ?? .lightGray
        
        style.titleColor = .gray7 ?? .white
        style.titleFont = .systemFont(ofSize: 17, weight: .semibold)
        
        let centerX = (self.view.frame.size.width) / 2
        let viewHeight = self.view.safeAreaLayoutGuide.layoutFrame.height + (self.tabBarController?.tabBar.frame.height ?? 0)
        
        let yPosition: CGFloat = viewHeight - 70
        
        self.view.makeToast(title,
                            duration: 1.0,
                            point: CGPoint(x: centerX, y: yPosition),
                            title: nil,
                            image: nil,
                            style: style,
                            completion: nil
        )
    }
    
    private func makeReportReviewAlert(_ commentId: String) {
        let alertController = UIAlertController(
            title: nil,
            message: "더보기",
            preferredStyle: .actionSheet
        )
        
        let reportAction = UIAlertAction(title: "후기 신고하기", style: .destructive) { _ in
            self.presentReportReview(commentId)
        }
        
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        
        [
            reportAction,
            cancel
        ].forEach {
            alertController.addAction($0)
        }
        
        present(alertController, animated: true)
    }
    
    private func makeEditMyReviewAlert(_ commentId: String) {
        let alertController = UIAlertController(
            title: nil,
            message: "댓글 더보기",
            preferredStyle: .actionSheet
        )
        
        let editMyReview = UIAlertAction(title: "수정하기", style: .default) { _ in
            self.editMyReview(commentId)
        }
        
        let deleteMyReview = UIAlertAction(title: "삭제하기", style: .destructive) { _ in
            self.showDeleteMyReviewAlert(commentId)
        }
        
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        
        [
            editMyReview,
            deleteMyReview,
            cancel
        ].forEach {
            alertController.addAction($0)
        }
        
        present(alertController, animated: true)
    }
    
    private func editMyReview(_ commentId: String) {
        placeView.editMyReview(commentId)
    }
    
    private func showDeleteMyReviewAlert(_ commentId: String) {
        let alertController = UIAlertController(
            title: "삭제하기",
            message: "정말로 삭제하시겠어요?\n삭제하면 다시 복구할 수 없어요.",
            preferredStyle: .alert
        )
        
        let deleteMyReview = UIAlertAction(title: "예", style: .default) { _ in
            let deleteCommentModel = AVIRODeleteCommentPost(commentId: commentId,
                                                            userId: UserId.shared.userId
            )
            
            self.presenter.deleteMyReview(deleteCommentModel)
        }
        
        deleteMyReview.setValue(UIColor.red, forKey: "titleTextColor")
        
        let cancel = UIAlertAction(title: "아니오", style: .default)
        
        [
            deleteMyReview,
            cancel
        ].forEach {
            alertController.addAction($0)
        }
        
        present(alertController, animated: true)
    }
    
    private func presentReportReview(_ commentId: String) {
        let vc = ReportReviewViewController()
        let presenter = ReportReviewPresenter(
            viewController: vc,
            reviewId: commentId
        )
        
        vc.presenter = presenter
        
        present(vc, animated: true)
    }
    
    // MARK: Down Back Button Tapped
    @objc private func downBackButtonTapped(_ sender: UIButton) {
        placeViewPopUpAfterInitPlacePopViewHeight()
        isSlideUpView = false
    }
    // MARK: Flag Button Tapped
    @objc private func flagButtonTapped(_ sender: UIButton) {
        presenter.checkReportPlaceDuplecated()
    }
    
    func isDuplicatedReport() {
        let alertController = UIAlertController(
            title: "이미 신고한 가계예요",
            message: "3건 이상의 신고가 들어오면\n가게는 자동으로 삭제돼요.",
            preferredStyle: .alert
        )
        
        let check = UIAlertAction(title: "확인", style: .cancel)
        
        alertController.addAction(check)
        
        present(alertController, animated: true)
    }
    
    func showReportPlaceAlert() {
        let alertController = UIAlertController(
            title: nil,
            message: "신고하기",
            preferredStyle: .actionSheet
        )
            
        let reportPlace = UIAlertAction(title: "가게 신고하기", style: .destructive) { _ in
            self.reasonForReportPlaceActionSheet( )
        }
        
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        
        [
            reportPlace,
            cancel
        ].forEach {
            alertController.addAction($0)
        }
        
        present(alertController, animated: true)
    }
    
    private func reasonForReportPlaceActionSheet() {
        let alertController = UIAlertController(
            title: "신고 이유가 궁금해요!",
            message: "3건 이상의 신고가 들어오면\n가게는 자동으로 삭제돼요.",
            preferredStyle: .alert
        )
        
        let lostPlace = UIAlertAction(title: "없어진 가게예요", style: .default) { _ in
            let type = AVIROPlaceReportEnum.noPlace
            self.presenter.reportPlace(type)
        }
        
        let notVeganPlace = UIAlertAction(title: "비건 메뉴가 없는 가게예요", style: .default) { _ in
            let type = AVIROPlaceReportEnum.noVegan
            self.presenter.reportPlace(type)
        }
         
        let duplicatedPlace = UIAlertAction(title: "중복 등록된 가게예요", style: .default) { _ in
            let type = AVIROPlaceReportEnum.dubplicatedPlace
            self.presenter.reportPlace(type)
        }
        
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        
        [
            lostPlace,
            notVeganPlace,
            duplicatedPlace,
            cancel
        ].forEach {
            alertController.addAction($0)
        }
        
        present(alertController, animated: true)
    }
    
    // MARK: Star Button Tapped
    @objc private func starButtonTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
        presenter.loadBookmark(sender.isSelected)
    }
    
    // MARK: Location Button Tapped
    @objc private func locationButtonTapped(_ sender: UIButton) {
        self.presenter.locationUpdate()
    }
    
    // MARK: Swipte Gestrue Actived
    @objc private func swipeGestureActived(_ gesture: UISwipeGestureRecognizer) {
        if gesture.direction == .up {
            // TopView가 로딩이 다 끝난 후 가능
            if !placeView.isLoadingTopView {
                // view가 slideup되고, detail view가 loading이 끝난 후 가능
                if isSlideUpView && !placeView.isLoadingDetail {
                    placeViewFullUp()
                    naverMapView.isHidden = true
                    isSlideUpView = false
                // view가 아직 slideup 안 되었고, popup일때 가능
                } else if !isSlideUpView && placeView.placeViewStated == .PopUp {
                    placeViewSlideUp()
                    presenter.getPlaceModelDetail()
                    isSlideUpView = true
                }
            }
        } else if gesture.direction == .down {
            // view가 slideup일때만 down gesture 가능
            if isSlideUpView {
                placeViewPopUpAfterInitPlacePopViewHeight()
                isSlideUpView = false
            }
        }
    }
}

// MARK: Text Field Delegate
extension HomeViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        animateTextFieldExpansion(textField: textField)
        return false
    }
    
    func animateTextFieldExpansion(textField: UITextField) {
        
        textField.placeholder = ""
        textField.leftView?.isHidden = true
        
        let startingFrame = textField.convert(textField.bounds, to: nil)
        let snapshot = textField.snapshotView(afterScreenUpdates: true)
        snapshot?.frame = startingFrame
        
        guard let snapshot = snapshot else { return }
        view.addSubview(snapshot)
        
        let targetScaleX = view.frame.width / startingFrame.width
        let targetScaleY = view.frame.height / startingFrame.height
        
        UIView.animate(withDuration: 0.15, animations: {
            snapshot.transform = CGAffineTransform(scaleX: targetScaleX, y: targetScaleY)
            snapshot.center = self.view.center
            
        }, completion: { _ in
            let vc = HomeSearchViewController()
            
            self.navigationController?.pushViewController(vc, animated: false)
            snapshot.removeFromSuperview()
            
            textField.leftView?.isHidden = false
            textField.placeholder = "어디로 이동할까요?"
        })
    }
    
}

// MARK: TapGestureDelegate
extension HomeViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view is UITextView || touch.view is UIButton {
            return false
        }
        
        view.endEditing(true)
        return true
    }
}
extension HomeViewController: NMFMapViewCameraDelegate {
    func mapView(_ mapView: NMFMapView, cameraDidChangeByReason reason: Int, animated: Bool) {
        
        saveCenterCoordinate()
    }
    
    // 카메라 움직일 때
    func mapView(_ mapView: NMFMapView, cameraWillChangeByReason reason: Int, animated: Bool) {
        loadLocationButton.isEnabled = false
        
        if !starButton.isSelected {
            starButton.isEnabled = false
        }
    }
    
    // 카메라 멈출 때
    func mapViewCameraIdle(_ mapView: NMFMapView) {
        loadLocationButton.isEnabled = true
        
        if !starButton.isSelected {
            starButton.isEnabled = true
        }
    }
}

// MARK: Map 빈 공간 클릭 할 때
extension HomeViewController: NMFMapViewTouchDelegate {
    func mapView(_ mapView: NMFMapView, didTapMap latlng: NMGLatLng, point: CGPoint) {
        loadLocationButton.isEnabled = true

        if !starButton.isSelected {
            starButton.isEnabled = true
        }
        
        whenClosedPlaceView()
        isSlideUpView = false
    }
}
