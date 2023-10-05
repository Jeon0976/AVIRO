//
//  TutorialViewController.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/07/06.
//

import UIKit

// MARK: First Tutorial Struct
private struct Tutorial {
    let title: String
    let subtitle: String
    let subtitle2: String
    let image: UIImage?
}

final class TutorialViewController: UIViewController {
    // MARK: tutorial array
    private let tutorial = [
        Tutorial(
            title: "가게 탐색",
            subtitle: "가게를 메뉴 구성에 따라\n",
            subtitle2: "3가지로 구분했어요",
            image: UIImage.screen1),
        Tutorial(
            title: "가게 등록 가능",
            subtitle: "내가 아는 가게의\n",
            subtitle2: "정보를 등록하고 수정해요",
            image: UIImage.screen2
        ),
        Tutorial(
            title: "비건 메뉴 공유",
            subtitle: "논비건 메뉴도 비건으로\n",
            subtitle2: "주문하는 법을 공유해요",
            image: UIImage.screen3
        ),
        Tutorial(
            title: "후기 기능",
            subtitle: "비건들의 알짜배기 정보로\n",
            subtitle2: "안심하고 방문하세요",
            image: UIImage.screen4
        )
    ]
    
    // MARK: UI Property Definitions
    private lazy var topCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: view.frame.width, height: 135)
        layout.minimumLineSpacing = 0
        
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        
        collectionView.backgroundColor = .tutorialBackgroud
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(
            TopCell.self,
            forCellWithReuseIdentifier: CVIdentifier.tutorialTopCell.rawValue
        )
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.tag = 0
        
        return collectionView
    }()
    
    private lazy var bottomCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        layout.scrollDirection = .horizontal
        let height = self.view.frame.height - 135 - 60 - viewPageControl.frame.height
        layout.itemSize = CGSize(width: view.frame.width, height: height)
        layout.minimumLineSpacing = 0
        
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        
        collectionView.backgroundColor = .tutorialBackgroud
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(
            BottomCell.self,
            forCellWithReuseIdentifier: CVIdentifier.tutorialBottomCell.rawValue
        )
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.tag = 1
        
        return collectionView
    }()
    
    private lazy var viewPageControl: UIPageControl = {
        let pageControl = UIPageControl()
        
        pageControl.numberOfPages = tutorial.count
        pageControl.currentPage = 0
        pageControl.currentPageIndicatorTintColor = .main
        pageControl.pageIndicatorTintColor = .gray5
        
        return pageControl
    }()
    
    private lazy var nextButton: NextPageButton = {
        let button = NextPageButton()
        
        button.setTitle("지금 어비로 시작하기", for: .normal)
        button.addTarget(
            self,
            action: #selector(tappedButton),
            for: .touchUpInside
        )
        button.isHidden = true
        
        return button
    }()
        
    // MARK: Override func
    override func viewDidLoad() {
        super.viewDidLoad()
 
        setupLayout()
        setupAttribute()
    }

    // MARK: Set up func
    private func setupLayout() {
        [
            topCollectionView,
            viewPageControl,
            bottomCollectionView,
            nextButton
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            topCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            topCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topCollectionView.heightAnchor.constraint(equalToConstant: 135),
            
            viewPageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            viewPageControl.topAnchor.constraint(equalTo: topCollectionView.bottomAnchor, constant: 10),
            
            bottomCollectionView.topAnchor.constraint(equalTo: viewPageControl.bottomAnchor, constant: 10),
            bottomCollectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 35),
            bottomCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        
            nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -25),
            nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            nextButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func setupAttribute() {
        navigationItem.backButtonTitle = ""
        navigationController?.navigationBar.isHidden = true
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        view.backgroundColor = .tutorialBackgroud
    }
    
    // MARK: UI Interactions
    private func changeButton() {
        if viewPageControl.currentPage == tutorial.count - 1 {
            nextButton.isHidden = false
        } else {
            nextButton.isHidden = true
        }
    }
    
    @objc func tappedButton() {
        pushLoginView()
    }
    
    private func pushLoginView() {
        UserDefaults.standard.set(true, forKey: UDKey.tutorial.rawValue)
        
        let loginVC = LoginViewController()
        
        self.navigationController?.pushViewController(loginVC, animated: true)
    }
}

// MARK: Collection View Delegate Flow Layout
extension TutorialViewController: UICollectionViewDelegateFlowLayout {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
        viewPageControl.currentPage = page
        changeButton()
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        /// 위, 아래 콜렉션뷰 동기화 작업
        if scrollView.tag == 0 {
            bottomCollectionView.contentOffset = scrollView.contentOffset
        } else {
            topCollectionView.contentOffset = scrollView.contentOffset
        }
    }
    
}

// MARK: Collection View Data Source
extension TutorialViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int
    ) -> Int {
        return tutorial.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let data = tutorial[indexPath.row]

        if collectionView.tag == 0 {
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: CVIdentifier.tutorialTopCell.rawValue,
                for: indexPath
            ) as? TopCell

            if indexPath.row >= 2 {
                /// isTop에 따라 폰트 크기 변겅
                cell?.setupData(
                    title: data.title,
                    subtitle: data.subtitle,
                    subtitle2: data.subtitle2,
                    isTop: true
                )
            } else {
                cell?.setupData(
                    title: data.title,
                    subtitle: data.subtitle,
                    subtitle2: data.subtitle2,
                    isTop: false
                )
            }
            
            return cell ?? UICollectionViewCell()
        } else {
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: CVIdentifier.tutorialBottomCell.rawValue,
                for: indexPath
            ) as? BottomCell

            cell?.setupData(image: data.image)

            return cell ?? UICollectionViewCell()
        }
    }
    
}
