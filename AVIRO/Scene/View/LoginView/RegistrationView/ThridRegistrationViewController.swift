//
//  ThridRegistrationViewControll.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/07/13.
//

import UIKit

final class ThridRegistrationViewController: UIViewController {
    lazy var presenter = ThridRegistrationPresenter(viewController: self)
    
    var titleLabel = UILabel()
    var subTitleLabel = UILabel()
    
    var termsTableView = UITableView(frame: .zero, style: .insetGrouped)
    var allAcceptButton = UIButton()
    
    var isAllAccepted = false
    
    var nextButton = TutorRegisButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.viewDidLoad()
    }
}

extension ThridRegistrationViewController: ThridRegistrationProtocol {
    // MARK: Layout
    func makeLayout() {
        [
            titleLabel,
            subTitleLabel,
            termsTableView,
            nextButton
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            // titleLabel
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            
            // subTitleLabel
            subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            subTitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            
            // termsTableView
            termsTableView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            termsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            termsTableView.topAnchor.constraint(equalTo: subTitleLabel.bottomAnchor, constant: 30),
            termsTableView.heightAnchor.constraint(equalToConstant: 220),
            
            // nextButton
            nextButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40),
            nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            nextButton.heightAnchor.constraint(equalToConstant: Layout.Button.height)
        ])
    }
    
    // MARK: Attribute
    func makeAttribute() {
        // view ...
        view.backgroundColor = .white
        
        // titleLabel
        titleLabel.text = "이용약관에\n동의해주세요."
        titleLabel.font = .systemFont(ofSize: 24, weight: .bold)
        titleLabel.textColor = .allVegan
        titleLabel.numberOfLines = 2
        
        // subTitle
        subTitleLabel.text = "정책 및 약관을 클릭해 모든 내용을 확인해주세요."
        subTitleLabel.font = .systemFont(ofSize: 14, weight: .medium)
        subTitleLabel.textColor = .subTitleColor
        
        // tableView
        termsTableView.dataSource = self
        termsTableView.delegate = self
        termsTableView.register(TermsTableCell.self, forCellReuseIdentifier: TermsTableCell.identifier)
        termsTableView.separatorStyle = .none
        termsTableView.isScrollEnabled = false
        termsTableView.backgroundColor = .backField
        termsTableView.layer.cornerRadius = 26

        // all AcceptButton
        allAcceptButton.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
        allAcceptButton.tintColor = .subTitle
        allAcceptButton.addTarget(self, action: #selector(allAcceptButtonTapped(_:)), for: .touchUpInside)

        // nextButton
        nextButton.setTitle("다음으로", for: .normal)
        nextButton.addTarget(self, action: #selector(tappedNextButton), for: .touchUpInside)
        nextButton.isEnabled = false
    }
    
    func pushFinalRegistrationView() {
        let viewController = FinalRegistrationViewController()
        
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc func tappedNextButton() {
        presenter.pushUserInfo()
    }

    // MARK: All Accept Button 클릭 시
    @objc func allAcceptButtonTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected

        sender.tintColor = sender.isSelected ? .allVegan : .subTitle
        presenter.allAcceptButtonTapped(sender.isSelected)

        checkAllRequiredTerms()
        termsTableView.reloadData()
    }
}

extension ThridRegistrationViewController: UITableViewDelegate {
    // MARK: Table HeaderView
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = tableView.backgroundColor
        
        let allAcceptLabel = UILabel()
        allAcceptLabel.text = "전체 동의"
        allAcceptLabel.font = .systemFont(ofSize: 20, weight: .semibold)
        allAcceptLabel.textColor = .registrationColor
        
        [
            allAcceptLabel,
            allAcceptButton
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            headerView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            allAcceptButton.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
            allAcceptButton.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 10),
            allAcceptButton.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -10),
            
            allAcceptLabel.leadingAnchor.constraint(equalTo: allAcceptButton.trailingAnchor, constant: 10),
            allAcceptLabel.centerYAnchor.constraint(equalTo: allAcceptButton.centerYAnchor)
        ])
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        55
    }
}

extension ThridRegistrationViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.terms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TermsTableCell.identifier, for: indexPath) as? TermsTableCell
        
        let term = presenter.terms[indexPath.row]
        
        cell?.selectionStyle = .none
        cell?.backgroundColor = termsTableView.backgroundColor
        
        cell?.makeCellData(check: term.1, term: term.0)
        
        cell?.checkButtonTapped = { [unowned self] in
            self.presenter.terms[indexPath.row].1 = !self.presenter.terms[indexPath.row].1
            self.checkAllRequiredTerms()
        }
                
        return cell ?? UITableViewCell()
    }
    
    // MARK: Check All Required Terms
    private func checkAllRequiredTerms() {
        // 하나 하나 체크 해서 전부다 채크 했을 경우
        let result = presenter.checkAllRequiredTerms()
        
        if result.0 {
            allAcceptButton.tintColor = .allVegan
        } else {
            allAcceptButton.tintColor = .subTitle
        }
        
        nextButton.isEnabled = result.1
    }
}
