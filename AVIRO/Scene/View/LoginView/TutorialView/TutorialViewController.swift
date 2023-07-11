//
//  TutorialViewController.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/07/06.
//

import UIKit

// MARK: First Tutorial Struct
struct Tutorial {
    let title: String
    let subTitle: String
    let image: UIImage?
}

final class TutorialViewController: UIViewController {
    // MARK: tutorial array
    let tutorial = [
        Tutorial(title: "홈 화면 핀\n3가지 타입 구분", subTitle: "비건 식당의 종류에 따라\n3가지 타입의 색상으로 구분됩니다", image: nil),
        Tutorial(title: "궁금한 지역의\n비건 식당 찾기", subTitle: "비건 식당이라면 어디든", image: nil),
        Tutorial(title: "내가 알고 있는\n비건 식당 등록하기", subTitle: "비건 식당이라면 어디든", image: nil),
        Tutorial(title: "나의 경험\n댓글로 공유하기", subTitle: "비건들의 집단지성이 모여\n더욱 안심할 수 있는 댓글 기능", image: nil)
    ]
    
    lazy var topCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: view.frame.width, height: view.frame.height * 0.3)
        layout.minimumLineSpacing = 0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(TopCell.self, forCellWithReuseIdentifier: TopCell.identifier)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.tag = 0
        
        return collectionView
    }()
    
    lazy var bottomCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: view.frame.width, height: view.frame.height * 0.5)
        layout.minimumLineSpacing = 0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(BottomCell.self, forCellWithReuseIdentifier: BottomCell.identifier)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.tag = 1
        
        return collectionView
    }()
    
    var viewPageControl = UIPageControl()
    
    var nextButton = TutorRegisButton()
        
    override func viewDidLoad() {
        super.viewDidLoad()
 
        makeLayout()
        makeAttribute()
    }

    // MARK: Layout
    private func makeLayout() {
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
            topCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            topCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topCollectionView.heightAnchor.constraint(equalToConstant: view.frame.height * 0.3),
            topCollectionView.bottomAnchor.constraint(equalTo: viewPageControl.topAnchor),
            
            viewPageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            viewPageControl.bottomAnchor.constraint(equalTo: bottomCollectionView.topAnchor, constant: -30),
            
            bottomCollectionView.bottomAnchor.constraint(equalTo: nextButton.topAnchor),
            bottomCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomCollectionView.heightAnchor.constraint(equalToConstant: view.frame.height * 0.5),
            
            nextButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40),
            nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            nextButton.heightAnchor.constraint(equalToConstant: Layout.Button.height)
        ])
    }
    
    // MARK: Attribute
    private func makeAttribute() {
        // navigation setting
        navigationItem.backButtonTitle = ""
        navigationController?.navigationBar.isHidden = true
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        view.backgroundColor = .white
        
        // viewPageControl
        viewPageControl.numberOfPages = tutorial.count
        viewPageControl.currentPage = 0
        viewPageControl.currentPageIndicatorTintColor = .allVegan
        viewPageControl.pageIndicatorTintColor = .separateLine
        
        // nextButton
        nextButton.setTitle("다음으로", for: .normal)
        nextButton.addTarget(self, action: #selector(tappedButton), for: .touchUpInside)
    
    }
    
    // MARK: Button Tapped
    @objc func tappedButton() {
        if viewPageControl.currentPage == tutorial.count - 1 {
            pushLoginView()
        } else {
            viewPageControl.currentPage += 1
            
            changeButton()
            
            let indexPath = IndexPath(item: viewPageControl.currentPage, section: 0)
        
            topCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
    
    // MARK: Button 변경 Method
    private func changeButton() {
        if viewPageControl.currentPage == tutorial.count - 1 {
            nextButton.setTitle("어비로 바로 시작하기", for: .normal)
            nextButton.setGradient()
        } else {
            nextButton.setTitle("다음으로", for: .normal)
            nextButton.removeGradient()
        }
    }
    
    // MARK: Login View
    private func pushLoginView() {
        //        UserDefaults.standard.set(true, forKey: "Tutorial")
        let loginVC = LoginViewController()
        
        self.navigationController?.pushViewController(loginVC, animated: true)
    }
}

extension TutorialViewController: UICollectionViewDelegateFlowLayout {
    // MARK: 스크롤이 끝날때 발동 Method
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
        viewPageControl.currentPage = page
        changeButton()
    }

    // MARK: 스크롤 하고있을 때 발동 Method
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
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
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TopCell.identifier,
                                                          for: indexPath
            ) as? TopCell

            cell?.setupData(title: data.title, subTitle: data.subTitle)

            return cell ?? UICollectionViewCell()
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BottomCell.identifier,
                                                          for: indexPath
            ) as? BottomCell

            cell?.setupData(image: data.image)

            return cell ?? UICollectionViewCell()
        }
    }
    
}
