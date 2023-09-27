//
//  ReportReviewPresenter.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/08/22.
//

import UIKit

protocol ReportReviewProtocol: NSObject {
    func makeLayout()
    func makeGesture()
    func showTextView(_ show: Bool)
    func isEnabledReportButton(_ enabled: Bool)
    func keyboardWillShow(height: CGFloat)
    func keyboardWillHide()
    func dismissViewController()
    func showErrorAlert(with error: String, title: String?)
}

final class ReportReviewPresenter {
    weak var viewController: ReportReviewProtocol?
    
    private var reportViews = [ReportCellView]()

    private var commentModel: AVIROReportReviewModel!
    private var reportType: String? {
        didSet {
            if reportType != nil {
                if reportType == AVIROReportReviewType.others.rawValue && reportContent == "" {
                    viewController?.isEnabledReportButton(false)
                } else {
                    viewController?.isEnabledReportButton(true)
                }
            } else {
                viewController?.isEnabledReportButton(false)
            }
        }
    }
    
    private var reportContent = "" {
        didSet {
            if reportContent != "" && reportType == AVIROReportReviewType.others.rawValue {
                viewController?.isEnabledReportButton(true)
            } else if reportContent == "" && reportType == AVIROReportReviewType.others.rawValue {
                viewController?.isEnabledReportButton(false)
            }
        }
    }
    
    var afterReportPopView: ((String) -> Void)?

    init(viewController: ReportReviewProtocol,
         reportIdModel: AVIROReportReviewModel? = nil
    ) {
        self.viewController = viewController
        self.commentModel = reportIdModel
        
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
    
    // MARK: Keyboard에 따른 view 높이 변경 Notification
    private func addKeyboardNotification() {
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
    
    private func removeKeyboardNotification() {
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
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
           let keyboardRectangle = keyboardFrame.cgRectValue
            viewController?.keyboardWillShow(height: keyboardRectangle.height)
        }
    }
    
    @objc private func keyboardWillHide() {
        viewController?.keyboardWillHide()
    }
    
    func saveReportCellViews(_ cellView: ReportCellView) {
        self.reportViews.append(cellView)
    }
    
    func selectedReportType(_ type: String, _ text: String) {
        self.reportType = type
        
        if type == AVIROReportReviewType.others.rawValue {
            updateContent(text)
            viewController?.showTextView(true)
        } else {
            updateContent("")
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
    
    func updateContent(_ text: String) {
        self.reportContent = text
    }
    
    func reportReview() {
        guard let typeString = reportType,
              let type =  AVIROReportReviewType(rawValue: typeString)?.code
        else { return }
        
        let reportModel = AVIROReportReviewDTO(
            commentId: commentModel.id,
            title: commentModel.placeTitle,
            createdTime: commentModel.createdTime,
            commentContent: commentModel.content,
            commentNickname: commentModel.nickname,
            userId: MyData.my.id,
            nickname: MyData.my.nickname,
            code: type,
            content: typeString
        )
         
        AVIROAPIManager().reportReview(with: reportModel) { [weak self] result in
            switch result {
            case .success(let success):
                if success.statusCode == 200 {
                    let message = success.message ?? ""
                    self?.afterReportPopView?(message)
                    self?.viewController?.dismissViewController()
                } else {
                    if let message = success.message {
                        self?.viewController?.showErrorAlert(with: message, title: nil)
                    }
                }
            case .failure(let error):
                self?.viewController?.showErrorAlert(with: error.localizedDescription, title: nil)

            }
        }
    }
}
