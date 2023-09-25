//
//  MyPageViewController.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/05/23.
//

import UIKit
import MessageUI

private enum Text: String {
    case title = "마이페이지"

    case cancel = "취소"

    case logoutTitle = "로그아웃 하시겠어요?"
    case logoutAction = "로그아웃"
    case withdrawalTitle = "정말로 어비로를 떠나시는 건가요?"
    case withdrawalSubtitle = "회원탈퇴 이후, 내가 등록한 가게와 댓글은\n사라지지 않지만, 다시 볼 수 없어요.\n정말로 탈퇴하시겠어요?"
    case withdrawalAction = "탈퇴하기"
}

final class MyPageViewController: UIViewController {
    private lazy var presenter = MyPageViewPresenter(viewController: self)
        
    private lazy var myInfoView: MyInfoView = {
        let view = MyInfoView()
        
        view.editNickNameTapped = { [weak self] in
            self?.whenTappedEditNickName()
        }
        
        return view
    }()
    
    private lazy var otherActionsView: OtherActionsView = {
        let view = OtherActionsView()
        
        view.afterTappedCell = { [weak self] settingValue in
            switch settingValue {
            case .termsOfService:
                self?.whenTappedTermsOfService()
            case .privacyPolicy:
                self?.whenTappedPrivacyPolicy()
            case .locationPolicy:
                self?.whenTappedLocationPlicy()
            case .inquiries:
                self?.whenTappedInquiries()
            case .thanksTo:
                self?.whenTappedThanksTo()
            case .logout:
                self?.whenTappedLogOut()
            default:
                break
            }
        }
        
        view.withdrawaButtonTapped = { [weak self] in
            self?.whenTappedWithdrawal()
        }
        
        return view
    }()
    
    private lazy var scrollView = UIScrollView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        presenter.viewWillAppear()
    }
}

extension MyPageViewController: MyPageViewProtocol {
    func setupLayout() {
       [
            myInfoView,
            otherActionsView
       ].forEach {
           $0.translatesAutoresizingMaskIntoConstraints = false
           self.scrollView.addSubview($0)
       }
        
        NSLayoutConstraint.activate([
            myInfoView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            myInfoView.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor),
            myInfoView.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor),
            
            otherActionsView.topAnchor.constraint(equalTo: myInfoView.bottomAnchor),
            otherActionsView.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor),
            otherActionsView.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor),
            otherActionsView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor)
        ])
        
        [
            scrollView
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
    
    func setupAttribute() {
        view.backgroundColor = .gray7
        
        scrollView.backgroundColor = .gray6
        
        navigationItem.title = Text.title.rawValue
        navigationController?.navigationBar.isHidden = false
    }

    func updateMyData(_ myDataModel: MyDataModel) {
        myInfoView.updateImage()
        myInfoView.updateId(myDataModel.id)
        myInfoView.updateMyPlace(myDataModel.place)
        myInfoView.updateMyReview(myDataModel.review)
        myInfoView.updateMyStar(myDataModel.star)
    }
    
    private func whenTappedEditNickName() {
        let vc = NickNameChangebleViewController()
        let presenter = NickNameChangeblePresenter(viewController: vc)
        
        vc.presenter = presenter
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func whenTappedDisplayMode() {
        
    }
    
    private func whenTappedTermsOfService() {
        if let url = URL(string: Policy.termsOfService.rawValue) {
            showWebView(with: url)
        }
    }
    
    private func whenTappedPrivacyPolicy() {
        if let url = URL(string: Policy.privacy.rawValue) {
            showWebView(with: url)
        }
    }
    
    private func whenTappedLocationPlicy() {
        if let url = URL(string: Policy.location.rawValue) {
            showWebView(with: url)
        }
    }
    
    private func whenTappedInquiries() {
        showMailView()
    }
    
    private func whenTappedThanksTo() {
        if let url = URL(string: Policy.thanksto.rawValue) {
            showWebView(with: url)
        }
    }
    
    private func whenTappedLogOut() {
        let cancelAction: AlertAction = (
            title: Text.cancel.rawValue,
            style: .default,
            handler: nil
        )
        
        let logoutAction: AlertAction = (
            title: Text.logoutAction.rawValue,
            style: .destructive,
            handler: {
                self.presenter.whenAfterLogout()
            }
        )
        
        showAlert(
            title: Text.logoutTitle.rawValue,
            message: nil,
            actions: [cancelAction, logoutAction]
        )
    }
    
    private func whenTappedWithdrawal() {
        
        let cancelAction: AlertAction = (
            title: Text.cancel.rawValue,
            style: .default,
            handler: nil
        )
        
        let withdrawalAction: AlertAction = (
            title: Text.withdrawalAction.rawValue,
            style: .destructive,
            handler: {
                self.presenter.whenAfterWithdrawal()
            }
        )
        
        showAlert(
            title: Text.withdrawalTitle.rawValue,
            message: Text.withdrawalSubtitle.rawValue,
            actions: [cancelAction, withdrawalAction]
        )
    }
    
    func pushLoginViewController(with: LoginRedirectReason) {
        let vc = LoginViewController()
        let presenter = LoginViewPresenter(viewController: vc)
        vc.presenter = presenter

        switch with {
        case .logout:
            presenter.whenAfterLogout = true
        case .withdrawal:
            presenter.whenAfterWithdrawal = true

        }
        
        let rootViewController = UINavigationController(rootViewController: vc)
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            windowScene.windows.first?.rootViewController = rootViewController
            windowScene.windows.first?.makeKeyAndVisible()
        }
    }
}
