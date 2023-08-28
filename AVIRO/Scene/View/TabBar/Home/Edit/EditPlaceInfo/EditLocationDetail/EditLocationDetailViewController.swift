//
//  EditLocationDetailViewController.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/08/27.
//

import UIKit

import NMapsMap

final class EditLocationDetailViewController: UIViewController {
    lazy var presenter = EditLocationDetailPresenter(viewController: self)
    
    private let items = ["주소 검색", "지도에서 검색"]
    
    private lazy var topLine: UIView = {
        let view = UIView()
        
        view.backgroundColor = .gray5
        
        return view
    }()
    
    private lazy var segmentedControl: UnderlineSegmentedControl = {
        let segmented = UnderlineSegmentedControl(items: items)
        
        segmented.setAttributedTitle()
        segmented.backgroundColor = .gray7
        segmented.selectedSegmentIndex = 0
        segmented.addTarget(self, action: #selector(segmentedChanged(segment:)), for: .valueChanged)
        
        return segmented
    }()
    
    private lazy var editLocationDetailTextView: EditLocationDetailTextView = {
        let view = EditLocationDetailTextView()
        
        view.searchAddress = { [weak self] text in
            self?.presenter.whenAfterSearchAddress(text)
        }
        
        return view
    }()
    
    private lazy var editLocationDetailMapView: EditLocationDetailMapView = {
        let view = EditLocationDetailMapView()
        
        view.isChangedCoordinate = { [weak self] coordinate in
            self?.presenter.whenAfterChangedCoordinate(coordinate)
        }
        
        view.isTappedEditButtonWhemMapView = { [weak self] in
            self?.presenter.editAddress()
        }
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        presenter.viewWillAppear()
    }
}

extension EditLocationDetailViewController: EditLocationDetailProtocol {
    func makeLayout() {
        [
            topLine,
            segmentedControl,
            editLocationDetailTextView,
            editLocationDetailMapView
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            topLine.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            topLine.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1),
            topLine.heightAnchor.constraint(equalToConstant: 0.5),
            
            segmentedControl.topAnchor.constraint(equalTo: topLine.bottomAnchor),
            segmentedControl.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            segmentedControl.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            segmentedControl.heightAnchor.constraint(equalToConstant: 50),
            
            editLocationDetailTextView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor),
            editLocationDetailTextView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            editLocationDetailTextView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            editLocationDetailTextView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            
            editLocationDetailMapView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor),
            editLocationDetailMapView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            editLocationDetailMapView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            editLocationDetailMapView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
    
    func makeAttribute() {
        self.view.backgroundColor = .gray7
        
        self.setupCustomBackButton()
        
        navigationItem.title = "주소"
        
        activeTextSearch()
        
        editLocationDetailTextView.setTableViewDataSource(self)
        editLocationDetailTextView.setTableViewDelegate(self)
    }
    
    @objc private func segmentedChanged(segment: UISegmentedControl) {
        switch segment.selectedSegmentIndex {
        case 0:
            activeTextSearch()
        case 1:
            activeMapSearch()
        default:
            break
        }
    }
    
    private func activeTextSearch() {
        editLocationDetailTextView.isHidden = false
        editLocationDetailMapView.isHidden = true
    }
    
    private func activeMapSearch() {
        editLocationDetailTextView.isHidden = true
        editLocationDetailMapView.isHidden = false
    }
    
    func dataBindingMap(_ marker: NMFMarker) {
        editLocationDetailMapView.dataBinding(marker)
    }
    
    func afterChangedAddressWhenMapView(_ address: String) {
        editLocationDetailMapView.changedAddress(address)
    }
    
    func textViewTableReload() {
        editLocationDetailTextView.addressTableViewReloadData()
    }
}

extension EditLocationDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.addressModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: EditLocationDetailTextTableViewCell.identifier,
            for: indexPath
        ) as? EditLocationDetailTextTableViewCell
        
        guard presenter.addressModels.count > indexPath.row else {
            return UITableViewCell()
        }
        
        let jusoData = presenter.checkSearchData(indexPath)
        
        guard let roadAddr = jusoData.roadAddr,
              let jibunAddr = jusoData.jibunAddr
        else { return UITableViewCell()}
        
        cell?.dataBinding(
            juso: jusoData,
            attributedRoad: roadAddr.changeColor(changedText: presenter.changedColorText),
            attributedJibun: jibunAddr.changeColor(changedText: presenter.changedColorText)
        )
        
        return cell ?? UITableViewCell()
    }
}

extension EditLocationDetailViewController: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        if offsetY > contentHeight - height {
            presenter.whenScrollingTableView()
        }
    }
}
