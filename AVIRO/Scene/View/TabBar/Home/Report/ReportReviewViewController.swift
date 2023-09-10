//
//  ReportReviewViewController.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/08/22.
//

import UIKit

final class ReportReviewViewController: UIViewController {
    lazy var presenter = ReportReviewPresenter(viewController: self)
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        
        button.setImage(UIImage(named: "Back"), for: .normal)
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        
        label.text = "신고하기"
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .gray0
        
        return label
    }()
    
    private lazy var reportButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("완료", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        button.setTitleColor(.gray3, for: .normal)
        button.addTarget(self, action: #selector(reportButtonTapped(_:)), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var separatedLine: UIView = {
        let view = UIView()
        
        view.backgroundColor = .gray5
        
        return view
    }()
    
    private lazy var reportTitleLabel: UILabel = {
        let label = UILabel()
        
        label.text = "신고사유 선택"
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .gray0
        
        return label
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        
        scrollView.isScrollEnabled = true
        
        return scrollView
    }()
    
    private lazy var reportTextView: UITextView = {
        let textView = UITextView()
        
        textView.text = "기타 신고 사유를 입력해주세요.\n(최대 500자)"
        textView.textColor = .gray2
        textView.font = .systemFont(ofSize: 16, weight: .medium)
        textView.textContainerInset = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)
        
        textView.backgroundColor = .gray6
        textView.layer.cornerRadius = 10
        textView.delegate = self
        
        return textView
    }()
    
    private var tapGesture = UITapGestureRecognizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        presenter.viewWillAppear()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        presenter.viewWillDisappear()
    }
    
    @objc private func backButtonTapped() {
        self.dismiss(animated: true)
    }
    
    // TODO: API 생기면 수정
    @objc private func reportButtonTapped(_ sender: UIButton) {
        if sender.titleLabel?.textColor == .main {
            let (id, type) = presenter.reportReview()
            
            print(id)
            print(type)
            
            self.dismiss(animated: true)
        }
    }
}

extension ReportReviewViewController: ReportReviewProtocol {
    func makeLayout() {
        view.backgroundColor = .gray7
        self.view.layer.cornerRadius = 20
        self.view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMinYCorner]
        
        [
            backButton,
            titleLabel,
            reportButton,
            separatedLine,
            reportTitleLabel,
            scrollView
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 18),
            backButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
            backButton.widthAnchor.constraint(equalToConstant: 24),
            backButton.heightAnchor.constraint(equalToConstant: 24),
            
            titleLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            
            reportButton.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            reportButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16),
            
            separatedLine.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 18),
            separatedLine.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1),
            separatedLine.heightAnchor.constraint(equalToConstant: 1),
            
            reportTitleLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
            reportTitleLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16),
            reportTitleLabel.topAnchor.constraint(equalTo: separatedLine.bottomAnchor, constant: 15),
            
            scrollView.topAnchor.constraint(equalTo: reportTitleLabel.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        
        makeReportViewCells()
    }
    
    private func makeReportViewCells() {
        var lastView: UIView?
        
        for report in CommentReportType.allCases {
            let cellView = ReportCellView()
            
            cellView.makeCellView(report.rawValue)
            cellView.translatesAutoresizingMaskIntoConstraints = false
            
            cellView.selectedReportType = { [weak self] type in
                self?.presenter.selectedReportType(type)
            }
            
            cellView.clickedOffSelectedType = { [weak self] type in
                self?.presenter.offSelectedReportType(type)
            }
            
            cellView.isHiddenTextView = { [weak self] isHidden in
                self?.reportTextView.isHidden = isHidden
            }
            
            presenter.saveReportCellViews(cellView)
            scrollView.addSubview(cellView)

            NSLayoutConstraint.activate([
                cellView.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor, constant: 16),
                cellView.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor, constant: -16),
                
                lastView == nil ?
                cellView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 15) :
                    cellView.topAnchor.constraint(equalTo: lastView!.bottomAnchor, constant: 7)
            ])
            
            lastView = cellView
            
        }
                
        scrollView.addSubview(reportTextView)
        reportTextView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            reportTextView.topAnchor.constraint(equalTo: lastView!.bottomAnchor, constant: 15),
            reportTextView.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor, constant: 16),
            reportTextView.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor, constant: -16),
            reportTextView.heightAnchor.constraint(equalToConstant: 150),
            reportTextView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -15)
        ])
        
        reportTextView.isHidden = true
    }
    
    func isEnabledReportButton(_ enabled: Bool) {
        if enabled {
            reportButton.setTitleColor(.main, for: .normal)
        } else {
            reportButton.setTitleColor(.gray3, for: .normal)
        }
    }
    
    func makeGesture() {
        self.view.addGestureRecognizer(tapGesture)
        tapGesture.delegate = self
    }
    
    func showTextView(_ show: Bool) {
        reportTextView.isHidden = !show
    }
    
    func keyboardWillShow(height: CGFloat) {
        UIView.animate(
            withDuration: 0.3,
            animations: { self.view.transform = CGAffineTransform(
                translationX: 0,
                y: -(height))
            }
        )
    }
    
    func keyboardWillHide() {
        self.view.transform = .identity
    }
}

// MARK: TapGestureDelegate
extension ReportReviewViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view is UITextView {
            return false
        }
        
        view.endEditing(true)
        return true
    }
}

// MARK: TextViewDelegate
extension ReportReviewViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if reportTextView.textColor == .gray2 {
            reportTextView.textColor = .gray0
            reportTextView.text = ""
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
          let currentText = textView.text ?? ""
          guard let stringRange = Range(range, in: currentText) else { return false }

          let updatedText = currentText.replacingCharacters(in: stringRange, with: text)
          
          return updatedText.count <= 500
      }
}
