//
//  ReportReviewPresenter.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/08/22.
//

import UIKit

protocol ReportReviewProtocol: NSObject {
    func makeLayout()
    func makeAttribute()
}

final class ReportReviewPresenter {
    weak var viewController: ReportReviewProtocol?
    private var reviewId: String?
    
    init(viewController: ReportReviewProtocol,
         reviewId: String? = nil
    ) {
        self.viewController = viewController
        self.reviewId = reviewId
    }
    
    func viewDidLoad() {
        viewController?.makeLayout()
        viewController?.makeAttribute()
    }
}
