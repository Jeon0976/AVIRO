//
//  HomeSearchViewController.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/05/26.
//

import UIKit

// MARK: Text
private enum Text: String {
    case searchFieldPlaceHolder = "어디로 이동할까요?"
    case noResultSubTitle = "알고 있는 가게가 결과에 없다면\n가게를 직접 등록해보세요."
    
    case error = "에러"
}

final class HomeSearchViewController: UIViewController {
    lazy var presenter = HomeSearchPresenter(viewController: self)
    
    // MARK: UI Property Definitions
    private lazy var searchField: SearchField = {
        let field = SearchField()
        
        field.delegate = self
        field.rightButtonHidden = true
        field.makePlaceHolder(Text.searchFieldPlaceHolder.rawValue)
        field.didTappedLeftButton = { [weak self] in
            self?.whenSearchingAndTppedBackButton()
        }
        
        return field
    }()
    
    private lazy var noHistoryView = NoHistoryView()
    
    private lazy var historyHeaderView: HistoryHeaderView = {
        let view = HistoryHeaderView()
        
        view.deleteAllCell = { [weak self] in
            self?.presenter.deleteHistoryModelAll()
            self?.ShowNoHistoryView()
        }
        
        return view
    }()
    
    private lazy var historyTableView: UITableView = {
        let tableView = UITableView()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(
            HistoryTableViewCell.self,
            forCellReuseIdentifier: TVIdentifier.homeSearchHistoryTableCell.rawValue
        )
        tableView.separatorStyle = .none
        tableView.tag = 1
        
        return tableView
    }()
    
    private lazy var placeListHeaderView: PlaceListHeaderView = {
        let view = PlaceListHeaderView()
        
        view.isHidden = true
        view.touchedLocationPositionButton = { [weak self] alert in
            self?.present(alert, animated: true)
        }
        view.touchedSortingByButton = { [weak self] alert in
            self?.present(alert, animated: true)
        }
        view.touchedCanActiveSort = { [weak self] in
            guard let query = self?.searchField.text else { return }
            self?.presenter.initSearchDataAndCompareAVIROData(query)
        }
        
        return view
    }()
    
    private lazy var placeListTableView: UITableView = {
        let tableView = UITableView()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(
            HomeSearchViewTableViewCell.self,
            forCellReuseIdentifier: TVIdentifier.homeSearchPlaceTableCell.rawValue
        )
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = .gray5
        tableView.isHidden = true
        tableView.tag = 0
        tableView.rowHeight = UITableView.automaticDimension
        
        return tableView
    }()
    
    private lazy var indicatorView: UIActivityIndicatorView = {
        let indicatorView = UIActivityIndicatorView()
        
        indicatorView.style = .large
        indicatorView.color = .gray5
        indicatorView.startAnimating()
        indicatorView.isHidden = true

        return indicatorView
    }()
    
    private lazy var noResultImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.image = UIImage.noResultCharacter
        imageView.clipsToBounds = false
        imageView.isHidden = true
        
        return imageView
    }()
    
    private lazy var noResultSubTitle: NoResultLabel = {
        let label = NoResultLabel()
        
        let text = Text.noResultSubTitle.rawValue
       
        label.setupLabel(text)
        label.isHidden = true
        
        return label
    }()
    
    private lazy var tapGesture = UITapGestureRecognizer()
    
    private var searchFieldTopConstraint: NSLayoutConstraint?
    
    // MARK: Override func
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.viewDidLoad()
    }
}

extension HomeSearchViewController: HomeSearchProtocol {
    // MARK: Set up func
    func setupLayout() {
        [
            searchField,
            noHistoryView,
            historyHeaderView,
            historyTableView,
            placeListHeaderView,
            placeListTableView,
            indicatorView,
            noResultImageView,
            noResultSubTitle
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        // searchField 클릭 시 navigation 위치로 이동시키기 위함
        searchFieldTopConstraint = searchField.topAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.topAnchor,
            constant: 15
        )
        searchFieldTopConstraint?.isActive = true
        
        NSLayoutConstraint.activate([
            // searchTextField
            searchField.leadingAnchor.constraint(
                equalTo: view.leadingAnchor, constant: 16),
            searchField.trailingAnchor.constraint(
                equalTo: view.trailingAnchor, constant: -16),
            
            // placeListHeaderView
            placeListHeaderView.topAnchor.constraint(equalTo: searchField.bottomAnchor),
            placeListHeaderView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            placeListHeaderView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            // placeListTableView
            placeListTableView.topAnchor.constraint(
                equalTo: placeListHeaderView.bottomAnchor),
            placeListTableView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor),
            placeListTableView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor),
            placeListTableView.bottomAnchor.constraint(
                equalTo: view.bottomAnchor),
            
            // noHistoryView
            noHistoryView.topAnchor.constraint(equalTo: searchField.bottomAnchor, constant: 15),
            noHistoryView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            noHistoryView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            // historyHeaderView
            historyHeaderView.topAnchor.constraint(equalTo: searchField.bottomAnchor),
            historyHeaderView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            historyHeaderView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            
            // historyTableView
            historyTableView.topAnchor.constraint(equalTo: historyHeaderView.bottomAnchor, constant: 10),
            historyTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            historyTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            historyTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            indicatorView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            indicatorView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            
            noResultImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            noResultImageView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            
            noResultSubTitle.topAnchor.constraint(equalTo: noResultImageView.bottomAnchor, constant: 20),
            noResultSubTitle.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ])
    }
    
    func setupAttribute() {
        view.addGestureRecognizer(tapGesture)
        
        tapGesture.cancelsTouchesInView = false
        tapGesture.delegate = self
        
        view.backgroundColor = .gray7
        
        navigationItem.title = "검색하기"
        navigationController?.navigationBar.isHidden = false
        
        setupBack()

        if let tabBarController = self.tabBarController as? TabBarViewController {
            tabBarController.hiddenTabBar(true)
        }
    }
    
    // MARK: UI Interactions
    func howToShowViewWhenViewWillAppear(_ isShowHistoryTable: Bool) {
        if isShowHistoryTable {
            ShowHistoryTable()
        } else {
            ShowNoHistoryView()
        }
    }
    
    private func ShowHistoryTable() {
        historyHeaderView.isHidden = false
        historyTableView.isHidden = false
        noHistoryView.isHidden = true
    }
    
    private func ShowNoHistoryView() {
        historyHeaderView.isHidden = true
        historyTableView.isHidden = true
        noHistoryView.isHidden = false
    }
    
    private func showPlaceListTable() {
        placeListTableView.isHidden = false
        placeListHeaderView.isHidden = false
        historyTableView.isHidden = true
        historyHeaderView.isHidden = true
        noHistoryView.isHidden = true
    }
    
    func historyListTableReload() {
        historyTableView.reloadData()
    }
    
    func afterDidSelectedHistoryCell(_ query: String) {
        searchField.text = query
        
        whenStartSearchingChangedView()
        presenter.initSearchDataAndCompareAVIROData(query)
    }
    
    func activeIndicatorView() {
        indicatorView.isHidden = true
    }
    
    func placeListNoResultData() {
        DispatchQueue.main.async { [weak self] in
            self?.placeListTableView.reloadData()

            self?.searchField.activeHshakeEffect()
            
            self?.howToShowWhenAfterSearchDataResult(haveDatas: false)
        }
    }
    
    func placeListTableReloadData() {
        DispatchQueue.main.async { [weak self] in
            self?.placeListTableView.reloadData()
            
            self?.howToShowWhenAfterSearchDataResult(haveDatas: true)
        }
    }
    
    private func howToShowWhenAfterSearchDataResult(haveDatas: Bool) {
        placeListTableView.isHidden = !haveDatas
        placeListHeaderView.isHidden = !haveDatas
        
        noResultImageView.isHidden = haveDatas
        noResultSubTitle.isHidden = haveDatas
        
        indicatorView.isHidden = true
    }
    
    private func whenSearchingAndTppedBackButton() {
        self.navigationController?.navigationBar.isHidden = false
                
        searchField.initLeftButton()
        UIView.animate(withDuration: 0.2) {
            self.presenter.checkHistoryTableValues()
            self.placeListTableView.isHidden = true
            self.placeListHeaderView.isHidden = true
            self.noResultImageView.isHidden = true
            self.noResultSubTitle.isHidden = true
            
            self.searchFieldTopConstraint?.constant = 15
            self.view.layoutIfNeeded()
        }
    }
    
    // MARK: Push & Pop Interactions
    func popViewController() {
        navigationController?.popViewController(animated: false)
    }
    
    // MARK: Alert Interactions
    func showErrorAlert(with error: String, title: String? = nil) {
        DispatchQueue.main.async { [weak self] in
            if let title = title {
                self?.showAlert(title: title, message: error)
            } else {
                self?.showAlert(title: Text.error.rawValue, message: error)
            }
        }
    }
}

// MARK: UIGestureRecognizerDelegate
extension HomeSearchViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldReceive touch: UITouch
    ) -> Bool {
        if touch.view is SearchField {
            return false
        }

        view.endEditing(true)
        return true
    }
}

// MARK: UITextFieldDelegate
extension HomeSearchViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        whenStartSearchingChangedView()
     }
    
    private func whenStartSearchingChangedView() {
        self.navigationController?.navigationBar.isHidden = true
        
        searchField.changeLeftButton()
        UIView.animate(withDuration: 0.2) {
            self.showPlaceListTable()
             
            self.searchFieldTopConstraint?.constant = 16
            self.view.layoutIfNeeded()
        }
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        searchField.rightButtonHidden = false
                
        if let text = textField.text, text != "" {
            presenter.query = text
        }
    }
}

// MARK: UITableViewDataSource
extension HomeSearchViewController: UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        switch tableView.tag {
        case 0:
            return presenter.matchedPlaceModelCount
        case 1:
            return presenter.historyPlaceModelCount
        default:
            return 0
        }
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        switch tableView.tag {
        case 0:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: TVIdentifier.homeSearchPlaceTableCell.rawValue,
                for: indexPath
            ) as? HomeSearchViewTableViewCell

            guard let data = presenter.matchedPlaceListRow(indexPath.row) else { return UITableViewCell() }

            let title = data.title
            let address = data.address
            let distance = data.distance
            
            var icon: UIImage?
            
            switch (data.allVegan, data.someVegan, data.requestVegan) {
            case (true, _, _):
                icon = UIImage.allCell
            case (_, true, _):
                icon = UIImage.someCell
            case (_, _, true):
                icon = UIImage.requestCell
            default:
                icon = UIImage.listCell
            }
            
            let cellData = MatchedPlaceCellModel(
                icon: icon ?? UIImage.listCell,
                title: title,
                address: address,
                distance: distance
            )
            
            let attributedTitle = title.changeColor(changedText: presenter.query)
            let attributedAddress = address.changeColor(changedText: presenter.query)
            
            cell?.setupCellData(
                cellData,
                attributedTitle: attributedTitle,
                attributedAddress: attributedAddress
            )

            cell?.backgroundColor = .gray7
            cell?.selectionStyle = .none

            return cell ?? UITableViewCell()
        case 1:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: TVIdentifier.homeSearchHistoryTableCell.rawValue,
                for: indexPath
            ) as? HistoryTableViewCell
            
            let cellData = presenter.historyPlaceListRow(indexPath.row)
            
            cell?.setupCellData(cellData)
            
            cell?.cancelButtonTapped = { [weak self] in
                self?.presenter.deleteHistoryModel(indexPath)
            }
            
            cell?.backgroundColor = .gray7
            cell?.selectionStyle = .none
            
            return cell ?? UITableViewCell()
        default:
            return UITableViewCell()
        }
    }
}

// MARK: UITableViewDelegate
extension HomeSearchViewController: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        if scrollView == placeListTableView {
            // 더 빠른 API 호출을 위한 상수 300
            if offsetY > contentHeight - height {
                let query = searchField.text ?? ""
                presenter.afterPagingSearchAndCompareAVIROData(query)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch tableView.tag {
        case 0:
            presenter.insertHistoryModel(indexPath)
            presenter.afterMainSearch(indexPath)
        case 1:
            presenter.historyTableCellTapped(indexPath)
        default:
            break
        }
    }
}
