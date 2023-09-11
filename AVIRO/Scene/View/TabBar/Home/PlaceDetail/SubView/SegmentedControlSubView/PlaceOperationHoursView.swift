//
//  PlaceOperationHoursView.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/09/11.
//

import UIKit

final class PlaceOperationHoursView: UIView {
    
    private lazy var mainTitle: UILabel = {
        let label = UILabel()
        
        return label
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        
        return button
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
}
