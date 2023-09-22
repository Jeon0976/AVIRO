//
//  MyPageViewController.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/05/23.
//

import UIKit
import MessageUI

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
//            case .displayMode:
//                self?.whenTappedDisplayMode()
            case .termsOfService:
                self?.whenTappedTermsOfService()
            case .privacyPolicy, .locationPolicy:
                self?.whenTappedPolicy()
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
        
        navigationItem.title = "마이페이지"
        navigationController?.navigationBar.isHidden = false
    }

    func updateMyData(_ myDataModel: MyDataModel) {
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
        
    }
    
    private func whenTappedPolicy() {
        
    }
    
    private func whenTappedInquiries() {
        // MARK: Login 기능 추가 시 기능 변경
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["aviro.kr.official@gmail.com"])
            mail.setSubject("[AVIRO] \(MyData.my.nickname)님의 문의 및 의견")
            mail.setMessageBody("본문 내용입니다.", isHTML: false)
            
            present(mail, animated: true)
        } else {
            // TODO: 메일 작업
            print("메일 설정하세요")
        }
    }
    
    private func whenTappedThanksTo() {
        
    }
    
    private func whenTappedLogOut() {
        let alertTitle = "로그아웃 하시겠어요?"
        
        let alertController = UIAlertController(title: alertTitle, message: nil, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "취소", style: .default)
        let logoutAction = UIAlertAction(title: "로그아웃", style: .destructive) { _ in
            self.presenter.whenAfterLogout()
        }

        [
            cancelAction,
            logoutAction
        ].forEach {
            alertController.addAction($0)
        }
        
        present(alertController, animated: true)
    }
    
    private func whenTappedWithdrawal() {
        let alertTitle = "정말로 어비로를 떠나시는 건가요?"
        let alertMessage = "회원탈퇴 이후, 내가 등록한 가게와 댓글은\n사라지지 않지만, 다시 볼 수 없어요.\n정말로 탈퇴하시겠어요?"
        
        let alertController = UIAlertController(
            title: alertTitle,
            message: alertMessage,
            preferredStyle: .alert
        )
        
        let cancelAction = UIAlertAction(title: "취소", style: .default)
        let withdrawalAction = UIAlertAction(title: "탈퇴하기", style: .destructive) { _ in
            self.presenter.whenAfterWithdrawal()
        }
        
        [
            cancelAction,
            withdrawalAction
        ].forEach {
            alertController.addAction($0)
        }
        
        present(alertController, animated: true)
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

extension MyPageViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(
        _ controller: MFMailComposeViewController,
        didFinishWith result: MFMailComposeResult,
        error: Error?
    ) {
        controller.dismiss(animated: true)
    }
}
