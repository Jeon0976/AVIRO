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
    let tutorial = [
        Tutorial(title: "홈 화면 핀\n3가지 타입 구분", subTitle: "보라색\n파란색\n주황색", image: nil),
        Tutorial(title: "궁금한 지역의\n비건 식당 찾기", subTitle: "텍스트\n텍스트\n ", image: nil),
        Tutorial(title: "내가 알고 있는\n비건 식당 등록하기", subTitle: "텍스트\n텍스트\n ", image: nil),
        Tutorial(title: "댓글로\n경험 공유하기", subTitle: "텍스트\n텍스트\n ", image: nil)
    ]
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: view.frame.width, height: view.frame.height * 0.7)
        layout.minimumLineSpacing = 0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(TutorialCell.self, forCellWithReuseIdentifier: TutorialCell.identifier)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        
        return collectionView
    }()
    
    var viewPageControl = UIPageControl()
    var nextButton = UIButton()
    var buttonSafeAear = UIView()
        
    override func viewDidLoad() {
        super.viewDidLoad()
 
        makeLayout()
        makeAttribute()
    }
        
    private func makeLayout() {
        [
            viewPageControl,
            collectionView,
            buttonSafeAear,
            nextButton
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            viewPageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            viewPageControl.bottomAnchor.constraint(equalTo: collectionView.topAnchor, constant: -30),
            
            collectionView.bottomAnchor.constraint(equalTo: nextButton.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: view.frame.height * 0.7),
                        
            buttonSafeAear.heightAnchor.constraint(equalToConstant: 30),
            buttonSafeAear.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            buttonSafeAear.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            buttonSafeAear.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            nextButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func makeAttribute() {
        // navigation setting
        navigationController?.navigationBar.isHidden = true
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        // viewPageControl
        viewPageControl.numberOfPages = tutorial.count
        viewPageControl.currentPage = 0
        viewPageControl.currentPageIndicatorTintColor = .gray
        viewPageControl.pageIndicatorTintColor = .lightGray
        
        // nextButton
        nextButton.setTitle("다음", for: .normal)
        nextButton.setTitleColor(UIColor.mainTitle, for: .normal)
        nextButton.backgroundColor = .lightGray
        nextButton.addTarget(self, action: #selector(tappedButton), for: .touchUpInside)
        
        buttonSafeAear.backgroundColor = .lightGray
    }
    
    @objc func tappedButton() {
        if viewPageControl.currentPage == tutorial.count - 1 {
            showLoginView()
        } else {
            viewPageControl.currentPage += 1
            changeButtonColor()
            let indexPath = IndexPath(item: viewPageControl.currentPage, section: 0)
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
    
    private func changeButtonColor() {
        if viewPageControl.currentPage == tutorial.count - 1 {
            nextButton.backgroundColor = .plusButton
        } else {
            nextButton.backgroundColor = .lightGray
        }
    }
    
    private func showLoginView() {
        UserDefaults.standard.set(true, forKey: "Tutorial")
            
        let loginVC = LoginViewController()
        
        navigationController?.pushViewController(loginVC, animated: false)
    }
}

extension TutorialViewController: UICollectionViewDelegateFlowLayout {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
        viewPageControl.currentPage = page
        changeButtonColor()
    }
}

extension TutorialViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int
    ) -> Int {
        tutorial.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TutorialCell.identifier, for: indexPath) as? TutorialCell
        
        let data = tutorial[indexPath.row]
        
        cell?.setupData(title: data.title, subTitle: data.subTitle, image: data.image)
        
        
        return cell ?? UICollectionViewCell()
    }
    
}
