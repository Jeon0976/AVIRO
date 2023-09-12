//
//  PlaceListSearchViewController.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/05/21.
//

import UIKit

final class PlaceListSearchViewController: UIViewController {
    lazy var presenter = PlaceListSearchViewPresenter(viewController: self)
    
    private lazy var listTableView = UITableView()
    private lazy var searchField = SearchField()
    
    private lazy var tapGesture = UITapGestureRecognizer()
    
    private lazy var noResultImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.backgroundColor = .gray6
        imageView.isHidden = true
        
        return imageView
    }()
    
    private lazy var noResultMainTitle: UILabel = {
        let label = UILabel()
        
        label.text = "아직 등록된 가게가 없어요"
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .center
        label.textColor = .gray0
        label.isHidden = true
        
        return label
    }()
    
    private lazy var noResultSubTitle: UILabel = {
        let label = UILabel()
        
        label.text = "알고 있는 가게에 검색 결과가 없다면\n가게를 직접 등록해보세요."
        label.numberOfLines = 2
        label.textColor = .gray2
        label.font = .systemFont(ofSize: 15, weight: .medium)
        label.textAlignment = .center
        label.isHidden = true
        
        return label
    }()
    
    private var searchTimer: DispatchWorkItem?
    
    /// SearchFieldTopConstraint
    private var searchFieldTopConstraint: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // 자동 입력
        searchField.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.navigationBar.isHidden = false
    }
}

extension PlaceListSearchViewController: PlaceListProtocol {
    // MARK: Layout
    func makeLayout() {
        [
            searchField,
            listTableView,
            noResultImageView,
            noResultMainTitle,
            noResultSubTitle
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        searchFieldTopConstraint = searchField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15)
        searchFieldTopConstraint?.isActive = true
                
        NSLayoutConstraint.activate([
            // searchField
            searchField.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Layout.Inset.leadingTop),
            searchField.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: Layout.Inset.trailingBottom),
            
            // listTableView
            listTableView.topAnchor.constraint(equalTo: searchField.bottomAnchor),
            listTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            listTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            listTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            noResultImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            noResultImageView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            noResultImageView.widthAnchor.constraint(equalToConstant: 120),
            noResultImageView.heightAnchor.constraint(equalToConstant: 120),
            
            noResultMainTitle.topAnchor.constraint(equalTo: noResultImageView.bottomAnchor, constant: 30),
            noResultMainTitle.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            
            noResultSubTitle.topAnchor.constraint(equalTo: noResultMainTitle.bottomAnchor, constant: 15),
            noResultSubTitle.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ])
    }
    
    // MARK: Attribute
    func makeAttribute() {
        view.backgroundColor = .gray7
        navigationItem.title = StringValue.PlaceListView.naviTitle
        setupCustomBackButton()

        // listTableView
        listTableView.backgroundColor = .gray7
        listTableView.dataSource = self
        listTableView.delegate = self
        listTableView.register(PlaceListCell.self, forCellReuseIdentifier: PlaceListCell.identifier)
        listTableView.separatorStyle = .singleLine
        listTableView.separatorColor = .gray5
        
        // search Textfield
        searchField.makePlaceHolder("어떤 가게를 찾고 있나요?")
        searchField.delegate = self
        searchField.rightView?.isHidden = true
        searchField.didTappedLeftButton = { [weak self] in
            self?.popViewController()
        }
    }
    
    // MARK: Gesture
    func makeGesture() {
        view.addGestureRecognizer(tapGesture)
        tapGesture.delegate = self
        tapGesture.cancelsTouchesInView = false
    }
    
    // MARK: reloadData
    func reloadTableView() {
        listTableView.isHidden = false
        noResultImageView.isHidden = true
        noResultMainTitle.isHidden = true
        noResultSubTitle.isHidden = true
        
        listTableView.reloadData()
    }
    
    func noResultData() {
        listTableView.isHidden = true
        noResultImageView.isHidden = false
        noResultMainTitle.isHidden = false
        noResultSubTitle.isHidden = false
        
        listTableView.reloadData()
        searchField.activeShakeAfterNoSearchData()
    }
    
    // MARK: Pop View Controller
    func popViewController() {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: Push Alert Controller
    func pushAlertController() {
        let title = "이미 등록된 가게입니다"
        let message = "다른 유저가 이미 등록한 가게예요.\n홈 화면에서 검색해보세요."
        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        let action = UIAlertAction(title: "확인", style: .default)
        
        alertController.addAction(action)
        
        present(alertController, animated: true)
    }
}

extension PlaceListSearchViewController: UITableViewDelegate {
    // MARK: Scroll 될 때 API 요청을 위한 메서드
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height

        // 더 빠른 API 호출을 위한 상수 300
        if offsetY > contentHeight - height - 300 {
            let query = searchField.text ?? ""
            presenter.loadData(query)
        }
    }
    
    // MARK: Item 클릭 될 때
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath
    ) {
        presenter.didSelectRowAt(indexPath)
    }
}

// MARK: TableView DataSource
extension PlaceListSearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int
    ) -> Int {
        presenter.placeListCount
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: PlaceListCell.identifier,
            for: indexPath
        ) as? PlaceListCell
        
        let placeList = presenter.placeListRow(indexPath.row)
        
        let title = placeList.title
        let address = placeList.address
        let distance = placeList.distance
        
        let cellData = PlaceListCellModel(
            title: title,
            address: address,
            distance: distance
        )
  
        let attributedTitle = title.changeColor(changedText: presenter.inrolledData ?? "")
        let attributedAddress = address.changeColor(changedText: presenter.inrolledData ?? "")

        cell?.makeCellData(cellData, attributedTitle: attributedTitle, attributedAddress: attributedAddress)
        
        cell?.backgroundColor = .white
        cell?.selectionStyle = .none
        
        return cell ?? UITableViewCell()
    }
}

extension PlaceListSearchViewController: UITextFieldDelegate {
    // MARK: 검색 시작할 때
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.navigationController?.navigationBar.isHidden = true

        searchField.changeLeftButton()
         UIView.animate(withDuration: 0.2) {
             self.searchFieldTopConstraint?.constant = 16
             self.view.layoutIfNeeded()
         }
     }
    
    // MARK: 실시간 검색
    func textFieldDidChangeSelection(_ textField: UITextField) {
        searchField.rightButtonHidden = false

        searchTimer?.cancel()
        
        let task = DispatchWorkItem { [weak self] in
            if let text = textField.text {
                self?.presenter.inrolledData = text
                self?.presenter.searchData(text)
            }
        }
    
        searchTimer = task
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35, execute: task)
    }
}

extension PlaceListSearchViewController: UIGestureRecognizerDelegate {
    // MARK: keyboard 관련 gesture 메서드
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view is SearchField || touch.view is UIButton {
            return false
        }
        
        view.endEditing(true)
        return true
    }
}
