//
//  PlaceListSearchViewController.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/05/21.
//

import UIKit

final class PlaceListSearchViewController: UIViewController {
    lazy var presenter = PlaceListSearchViewPresenter(viewController: self)
    
    private lazy var listTableView: UITableView = {
        let tableView = UITableView()
        
        tableView.backgroundColor = .gray7
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(
            PlaceListCell.self,
            forCellReuseIdentifier: PlaceListCell.identifier
        )
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = .gray5
        
        return tableView
    }()
    
    private lazy var searchField: SearchField = {
        let field = SearchField()
        
        field.makePlaceHolder("어떤 가게를 찾고 있나요?")
        field.delegate = self
        field.rightView?.isHidden = true
        field.didTappedLeftButton = { [weak self] in
            self?.popViewController()
        }
        
        return field
    }()
        
    private lazy var noResultImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.image = UIImage.noResultCharacter
        imageView.clipsToBounds = false
        imageView.isHidden = true
        
        return imageView
    }()
    
    private lazy var noResultTitle: NoResultLabel = {
        let label = NoResultLabel()
        
        let text = "검색결과가 없습니다\n다른 검색어를 입력해보세요"
        label.setupLabel(text)
        label.isHidden = true
        
        return label
    }()
    
    private lazy var tapGesture = UITapGestureRecognizer()

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
            noResultTitle
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        searchFieldTopConstraint = searchField.topAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15)
        searchFieldTopConstraint?.isActive = true
                
        NSLayoutConstraint.activate([
            // searchField
            searchField.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            searchField.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            // listTableView
            listTableView.topAnchor.constraint(equalTo: searchField.bottomAnchor),
            listTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            listTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            listTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            noResultImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            noResultImageView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            
            noResultTitle.topAnchor.constraint(
                equalTo: noResultImageView.bottomAnchor, constant: 20),
            noResultTitle.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ])
    }
    
    // MARK: Attribute
    func makeAttribute() {
        view.backgroundColor = .gray7
        navigationItem.title = "가게 찾기"
        setupBack()
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
        noResultTitle.isHidden = true
        
        listTableView.reloadData()
    }
    
    func noResultData() {
        listTableView.isHidden = true
        noResultImageView.isHidden = false
        noResultTitle.isHidden = false
        
        listTableView.reloadData()
        searchField.activeHshakeEffect()
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

        cell?.makeCellData(
            cellData,
            attributedTitle: attributedTitle,
            attributedAddress: attributedAddress
        )
        
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
    func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldReceive touch: UITouch
    ) -> Bool {
        if touch.view is SearchField || touch.view is UIButton {
            return false
        }
        
        view.endEditing(true)
        return true
    }
}
