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
            return presenter.veganTableCount
        case 1:
            return presenter.requestTableCount
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
            
            cell?.priceTextField.addTarget(
                self,
                action: #selector(changePrice(_:)),
                for: .editingDidEnd
            )
            
            let veganTable = presenter.checkVeganTable(indexPath)
            
            cell?.dataBinding(veganTable.menu,
                              veganTable.price
            )
            
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
            
            cell?.priceTextField.addTarget(
                self,
                action: #selector(changePrice(_:)),
                for: .editingDidEnd
            )
            
            cell?.detailTextField.addTarget(
                self,
                action: #selector(requestDetailTextDidChahge(_:)),
                for: .editingChanged)
            
            let requestTable = presenter.checkRequestTable(indexPath)
            
            cell?.dataBinding(requestTable.menu,
                              requestTable.price,
                              requestTable.howToRequest,
                              requestTable.isCheck
            )
            
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
            
            presenter.plusVeganTable(textFieldIndexPath,
                                     textField.text,
                                     nil
            )
            
            isPossibleReportButton()
        }
    }
    
    @objc func veganMenuPriceTextDidChange(_ textField: UITextField) {
        let pointInTable = textField.convert(textField.bounds.origin, to: veganMenuTableView)
        if let textFieldIndexPath = veganMenuTableView.indexPathForRow(at: pointInTable) {
            
            presenter.plusVeganTable(textFieldIndexPath,
                                     nil,
                                     textField.text
            )
            
            isPossibleReportButton()
        }
    }
    
    @objc func requestMenuTextDidChange(_ textField: UITextField) {
        let pointInTable = textField.convert(textField.bounds.origin, to: howToRequestVeganMenuTableView)
        if let textFieldIndexPath = howToRequestVeganMenuTableView.indexPathForRow(at: pointInTable) {
            
            presenter.plusRequestTable(textFieldIndexPath,
                                       textField.text,
                                       nil,
                                       nil
            )
            
            isPossibleReportButton()
        }
    }
    
    @objc func requestPriceTextDidChange(_ textField: UITextField) {
        let pointInTable = textField.convert(textField.bounds.origin, to: howToRequestVeganMenuTableView)
        if let textFieldIndexPath = howToRequestVeganMenuTableView.indexPathForRow(at: pointInTable) {
            
            presenter.plusRequestTable(textFieldIndexPath,
                                       nil,
                                       textField.text,
                                       nil
            )
            
            isPossibleReportButton()
        }
    }
    
    @objc func requestDetailTextDidChahge(_ textField: UITextField) {
        let pointInTable = textField.convert(textField.bounds.origin, to: howToRequestVeganMenuTableView)
        if let textFieldIndexPath = howToRequestVeganMenuTableView.indexPathForRow(at: pointInTable) {
            
            presenter.plusRequestTable(textFieldIndexPath,
                                       nil,
                                       nil,
                                       textField.text
            )
            
            isPossibleReportButton()
        }
    }
    
    @objc func changePrice(_ textField: UITextField) {
        textField.text = textField.text?.currenyKR()
    }
}
