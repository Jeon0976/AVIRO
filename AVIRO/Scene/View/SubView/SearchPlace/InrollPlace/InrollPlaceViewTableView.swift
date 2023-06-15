//
//  InrollPlaceViewTableView.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/06/15.
//

import UIKit

// MARK: TableView Data Source
extension InrollPlaceViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView.tag {
        case 0:
            return presenter.notRequestMenu.count
        case 1:
            return presenter.requestMenu.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView.tag {
        case 0:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: VeganMenuTableViewCell.identifier
                , for: indexPath
            ) as? VeganMenuTableViewCell
            
            cell?.selectionStyle = .none
            
            cell?.menuTextField.addTarget(
                self,
                action: #selector(veganMenuTextDidChange(_:)),
                for: .editingChanged
            )
            cell?.priceTextField.addTarget(
                self,
                action: #selector(veganMenuPriceTextDidChange(_:)),
                for: .editingChanged
            )
            
            let name = presenter.notRequestMenu[indexPath.row].menu
            let price = presenter.notRequestMenu[indexPath.row].price
            
            cell?.dataBinding(name, price)
            
            return cell ?? UITableViewCell()
        case 1:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: IfRequestVeganMenuTableViewCell.identifier,
                for: indexPath
            ) as? IfRequestVeganMenuTableViewCell
            
            cell?.selectionStyle = .none
            
            cell?.menuTextField.addTarget(
                self,
                action: #selector(requestMenuTextDidChange(_:)),
                for: .editingChanged
            )
            cell?.priceTextField.addTarget(
                self,
                action: #selector(requestPriceTextDidChange(_:)),
                for: .editingChanged
            )
            cell?.detailTextField.addTarget(
                self,
                action: #selector(requestDetailTextDidChahge(_:)),
                for: .editingChanged)
            
            let name = presenter.requestMenu[indexPath.row].menu
            let price = presenter.requestMenu[indexPath.row].price
            let detail = presenter.requestMenu[indexPath.row].howToRequest
            let check = presenter.requestMenu[indexPath.row].isCheck
            
            cell?.dataBinding(name, price, detail, check)
            return cell ?? UITableViewCell()
        default:
            return UITableViewCell()
        }
    }
}

// MARK: Table TextField 데이터 기입 할때 불러 들이는 메서드
extension InrollPlaceViewController {
    @objc func veganMenuTextDidChange(_ textField: UITextField) {
        let pointInTable = textField.convert(textField.bounds.origin, to: veganMenuTableView)
        if let textFieldIndexPath = veganMenuTableView.indexPathForRow(at: pointInTable) {
            presenter.notRequestMenu[textFieldIndexPath.row].menu = textField.text ?? ""
            
            isPossibleReportButton()
        }
    }
    
    @objc func veganMenuPriceTextDidChange(_ textField: UITextField) {
        let pointInTable = textField.convert(textField.bounds.origin, to: veganMenuTableView)
        if let textFieldIndexPath = veganMenuTableView.indexPathForRow(at: pointInTable) {
            presenter.notRequestMenu[textFieldIndexPath.row].price = textField.text ?? ""
            
            isPossibleReportButton()
        }
    }
    
    @objc func requestMenuTextDidChange(_ textField: UITextField) {
        let pointInTable = textField.convert(textField.bounds.origin, to: howToRequestVeganMenuTableView)
        if let textFieldIndexPath = howToRequestVeganMenuTableView.indexPathForRow(at: pointInTable) {
            presenter.requestMenu[textFieldIndexPath.row].menu = textField.text ?? ""
            
            isPossibleReportButton()
        }
    }
    
    @objc func requestPriceTextDidChange(_ textField: UITextField) {
        let pointInTable = textField.convert(textField.bounds.origin, to: howToRequestVeganMenuTableView)
        if let textFieldIndexPath = howToRequestVeganMenuTableView.indexPathForRow(at: pointInTable) {
            presenter.requestMenu[textFieldIndexPath.row].price = textField.text ?? ""
            
            isPossibleReportButton()
        }
    }
    
    @objc func requestDetailTextDidChahge(_ textField: UITextField) {
        let pointInTable = textField.convert(textField.bounds.origin, to: howToRequestVeganMenuTableView)
        if let textFieldIndexPath = howToRequestVeganMenuTableView.indexPathForRow(at: pointInTable) {
            presenter.requestMenu[textFieldIndexPath.row].howToRequest = textField.text ?? ""
            if textField.text != "" {
                presenter.requestMenu[textFieldIndexPath.row].isCheck = true
                
                isPossibleReportButton()
            }
        }
    }
}

// MARK: 다른곳 클릭할 때 키보드 없애기
extension InrollPlaceViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        view.endEditing(true)
    }
}
