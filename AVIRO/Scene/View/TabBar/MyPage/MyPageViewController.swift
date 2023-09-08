//
//  MyPageViewController.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/05/23.
//

import UIKit
import MessageUI

import KeychainSwift

final class MyPageViewController: UIViewController {
    private lazy var presenter = MyPageViewPresenter(viewController: self)
    
    private let keychain = KeychainSwift()
    
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
            case .displayMode:
                self?.whenTappedDisplayMode()
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
    func makeLayout() {
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
    
    func makeAttribute() {
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
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["AVRIO@example.com"])
            mail.setSubject("[AVIRO] \(UserId.shared.userNickName)님의 문의 및 의견")
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
        let result = self.keychain.delete("userIdentifier")
        
        print("성공적인 로그아웃: \(result)")
        
        let vc = LoginViewController()
        let presenter = LoginViewPresenter(viewController: vc)
        vc.presenter = presenter
        
        let rootViewController = UINavigationController(rootViewController: vc)
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            windowScene.windows.first?.rootViewController = rootViewController
            windowScene.windows.first?.makeKeyAndVisible()
        }

    }
    
    private func whenTappedWithdrawal() {
        
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
