//
//  EditMenuViewController.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/08/25.
//

import UIKit

final class EditMenuViewController: UIViewController {
    lazy var presenter = EditMenuPresenter(viewController: self)
    
    private lazy var editMenuTopView = EditMenuTopView()
    
    private lazy var editMenuBottomView =  EditMenuBottomView()
    
    private lazy var scrollView = UIScrollView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
}

extension EditMenuViewController: EditMenuProtocol {
    func makeLayout() {
        [
            editMenuTopView,
            editMenuBottomView
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            scrollView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            editMenuTopView.topAnchor.constraint(
                equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 15),
            editMenuTopView.leadingAnchor.constraint(
                equalTo: scrollView.frameLayoutGuide.leadingAnchor, constant: 16),
            editMenuTopView.trailingAnchor.constraint(
                equalTo: scrollView.frameLayoutGuide.trailingAnchor, constant: -16),
            
            editMenuBottomView.topAnchor.constraint(
                equalTo: editMenuTopView.bottomAnchor, constant: 15),
            editMenuBottomView.leadingAnchor.constraint(
                equalTo: scrollView.frameLayoutGuide.leadingAnchor, constant: 16),
            editMenuBottomView.trailingAnchor.constraint(
                equalTo: scrollView.frameLayoutGuide.trailingAnchor, constant: -16),
            editMenuBottomView.bottomAnchor.constraint(
                equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -25)
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
        self.view.backgroundColor = .gray7
        self.scrollView.backgroundColor = .gray6
        
        self.setupCustomBackButton()
        
        navigationController?.navigationBar.isHidden = false
        
        navigationItem.title = "메뉴 수정하기"
        
        let rightBarButton = UIBarButtonItem(title: "수정하기", style: .plain, target: self, action: #selector(editMenu))
        navigationItem.rightBarButtonItem = rightBarButton
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        if let tabBarController = self.tabBarController as? TabBarViewController {
            tabBarController.hiddenTabBarIncludeIsTranslucent(true)
        }
        
        editMenuBottomView.setTableViewDelegate(self)
    }
    
    @objc private func editMenu() {
        
    }
    
    func updateEditMenuButton(_ isEnabled: Bool) {
        navigationItem.rightBarButtonItem?.isEnabled = isEnabled
    }
    
    func handleClosure() {
        editMenuTopView.veganOptionsTapped = { [weak self] (text, selected) in
            self?.presenter.changedVeganOption(text, selected)
        }
        
        editMenuBottomView.plusButtonTapped = { [weak self] in
            self?.presenter.plusMenu()
        }
    }
    
    func makeGesture() {
        
    }
    
    func dataBindingTopView(isAll: Bool, isSome: Bool, isRequest: Bool) {
        editMenuTopView.dataBinding(isAll: isAll, isSome: isSome, isRequest: isRequest)
    }
    
    func dataBindingBottomView(_ isPresentingDefaultTable: Bool) {
        editMenuBottomView.initMenuTableView(isPresentingDefaultTable, presenter.menuArrayCount)
    }
    
    func updateMenuTableView(_ isPresentingDefaultTable: Bool) {
        if isPresentingDefaultTable {
            editMenuBottomView.changeMenuTable(isPresentingDefaultTable, presenter.veganMenuCount)
        } else {
            editMenuBottomView.changeMenuTable(isPresentingDefaultTable, presenter.requestVeganMenuCount)
        }
    }
    
    func menuTableReload(_ isPresentingDefaultTable: Bool) {
        editMenuBottomView.menuTableReload(isPresentingDefaultTable)
    }
    
}

extension EditMenuViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView.tag {
        case 0:
            return presenter.veganMenuCount
        case 1:
            return presenter.requestVeganMenuCount
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView.tag {
        case 0:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: NormalTableViewCell.identifier,
                for: indexPath
            ) as? NormalTableViewCell

            guard let menuData = presenter.checkVeganMenuData(indexPath) else { return UITableViewCell() }
                        
            cell?.setData(menu: menuData.menu,
                          price: menuData.price
            )
            
            cell?.selectionStyle = .none
            
            // MARK: DataBinding
            cell?.editingMenuField = { [weak self] menu in
                self?.presenter.editingMenuField(menu, indexPath)
            }
            
            cell?.editingPriceField = { [weak self] price in
                self?.presenter.editingPriceField(price, indexPath)
            }
            
            cell?.onMinusButtonTapped = { [weak self] in
                self?.presenter.deleteMenu(indexPath)
            }

            return cell ?? UITableViewCell()
        case 1:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: RequestTableViewCell.identifier,
                for: indexPath
            ) as? RequestTableViewCell
            
            guard let menuData = presenter.checkRequestVeanMenuData(indexPath) else { return UITableViewCell() }
                                    
            cell?.setData(menu: menuData.menu,
                          price: menuData.price,
                          request: menuData.howToRequest,
                          isSelected: menuData.isCheck,
                          isEnabled: menuData.isEnabled
            )
            
            cell?.selectionStyle = .none

            // MARK: DataBinding
            cell?.editingMenuField = { [weak self] menu in
                self?.presenter.editingMenuField(menu, indexPath)
            }
            
            cell?.editingPriceField = { [weak self] price in
                self?.presenter.editingPriceField(price, indexPath)
            }
            
            cell?.onRequestButtonTapped = { [weak self] selected in
                self?.presenter.editingRequestButton(selected, indexPath)
            }
            
            cell?.editingRequestField = { [weak self] request in
                self?.presenter.editingRequestField(request, indexPath)
            }
            
            cell?.onMinusButtonTapped = { [weak self] in
                self?.presenter.deleteMenu(indexPath)
            }
            
            return cell ?? UITableViewCell()
        default:
            return UITableViewCell()
        }
    }
}
