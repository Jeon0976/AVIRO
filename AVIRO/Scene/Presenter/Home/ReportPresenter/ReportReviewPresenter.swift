//
//  ReportReviewPresenter.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/08/22.
//

import UIKit

enum CommentReportType: String, CaseIterable {
    case profanity = "욕설/비방/차별/혐오 후기예요."
    case advertisement = "홍보/영리목적 후기예요."
    case illegalInfo = "불법 정보 후기예요."
    case obscene = "음란/청소년 유해 후기예요."
    case personalInfo = "개인 정보 노출/유포/거래를 한 후기예요."
    case spam = "도배/스팸 후기예요."
    case others = "기타"
}

protocol ReportReviewProtocol: NSObject {
    func makeLayout()
    func makeGesture()
    func showTextView(_ show: Bool)
    func isEnabledReportButton(_ enabled: Bool)
    func keyboardWillShow(height: CGFloat)
    func keyboardWillHide()
}

final class ReportReviewPresenter {
    weak var viewController: ReportReviewProtocol?
    
    private var reviewId: String?
    
    private var reportViews = [ReportCellView]()
    
    private var reportType: String? {
        didSet {
            if reportType != nil {
                viewController?.isEnabledReportButton(true)
            } else {
                viewController?.isEnabledReportButton(false)
            }
        }
    }

    init(viewController: ReportReviewProtocol,
         reviewId: String? = nil
    ) {
        self.viewController = viewController
        self.reviewId = reviewId
    }
    
    func viewDidLoad() {
        viewController?.makeLayout()
        viewController?.makeGesture()
    }
    
    func viewWillAppear() {
        addKeyboardNotification()
    }
    
    func viewWillDisappear() {
        removeKeyboardNotification()
    }
    
    func saveReportCellViews(_ cellView: ReportCellView) {
        self.reportViews.append(cellView)
    }
    
    func selectedReportType(_ type: String) {
        self.reportType = type
        
        if type == CommentReportType.others.rawValue {
            viewController?.showTextView(true)
        } else {
            viewController?.showTextView(false)
        }
        
        reportViews.forEach { cellView in
            if cellView.checkCell() != type {
                cellView.initLabelView()
            }
        }
    }
    
    func offSelectedReportType(_ type: String) {
        if self.reportType == type {
            self.reportType = nil
        }
    }
    
    // MARK: Keyboard에 따른 view 높이 변경 Notification
    func addKeyboardNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    func removeKeyboardNotification() {
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
           let keyboardRectangle = keyboardFrame.cgRectValue
            viewController?.keyboardWillShow(height: keyboardRectangle.height)
        }
    }
    
    @objc func keyboardWillHide() {
        viewController?.keyboardWillHide()
    }
    
    func reportReview() -> (String, String) {
        guard let id = reviewId,
              let type = reportType
        else { return ("", "") }
        
        return (id, type)
    }
}
