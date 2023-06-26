//
//  LoginViewController.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/06/14.
//

import UIKit

final class LoginViewController: UIViewController {
    lazy var presenter = LoginViewPresenter(viewController: self)
    
    var scrollView = UIScrollView()
    var viewPageControl = UIPageControl()
    var appleLoginButton = UIButton()
    var noLoginButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.viewDidLoad()
    }
    
}

extension LoginViewController: LoginViewProtocol {
    func makeLayout() {
        [
            scrollView,
            viewPageControl,
            appleLoginButton,
            noLoginButton
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            viewPageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            viewPageControl.bottomAnchor.constraint(equalTo: appleLoginButton.topAnchor, constant: -16),
            viewPageControl.topAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 16),
            
            appleLoginButton.bottomAnchor.constraint(equalTo: noLoginButton.topAnchor, constant: -16),
            appleLoginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            appleLoginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            appleLoginButton.heightAnchor.constraint(equalToConstant: 52),
            
            noLoginButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            noLoginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    func makeAttribute() {
        navigationController?.navigationBar.isHidden = true
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false

        scrollView.backgroundColor = .brown
        
        viewPageControl.numberOfPages = 5
        viewPageControl.currentPageIndicatorTintColor = .plusButton
        viewPageControl.pageIndicatorTintColor = .gray
        
        appleLoginButton.setTitle("애플로 로그인", for: .normal)
        appleLoginButton.setTitleColor(.mainTitle, for: .normal)
        appleLoginButton.layer.borderColor = UIColor.mainTitle?.cgColor
        appleLoginButton.layer.borderWidth = 2
        appleLoginButton.layer.cornerRadius = 28
        
        noLoginButton.setTitle("로그인 없이 둘러보기", for: .normal)
        noLoginButton.setTitleColor(.subTitle, for: .normal)
        noLoginButton.titleLabel?.font = .systemFont(ofSize: 14)
        noLoginButton.addTarget(self, action: #selector(tapNoLoginButton), for: .touchUpInside)
    }
    
    @objc func tapNoLoginButton() {
        let viewController = TabBarViewController()
        
        navigationController?.pushViewController(viewController, animated: true)
    }
}
