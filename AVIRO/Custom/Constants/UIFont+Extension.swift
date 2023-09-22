//
//  UIFont+Extension.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/09/16.
//

import UIKit

final class CFont {
    static let font = CFont()
    
    private(set) var regular13: UIFont = .pretendard(size: 13, weight: .regular)
    private(set) var regular14: UIFont = .pretendard(size: 14, weight: .regular)
    private(set) var regular17: UIFont = .pretendard(size: 17, weight: .regular)
        
    private(set) var medium14: UIFont = .pretendard(size: 14, weight: .medium)
    private(set) var medium15: UIFont = .pretendard(size: 15, weight: .medium)
    private(set) var medium16: UIFont = .pretendard(size: 16, weight: .medium)
    private(set) var medium17: UIFont = .pretendard(size: 17, weight: .medium)
    private(set) var medium18: UIFont = .pretendard(size: 18, weight: .medium)
    
    private(set) var semibold15: UIFont = .pretendard(size: 15, weight: .semibold)
    private(set) var semibold16: UIFont = .pretendard(size: 16, weight: .semibold)
    private(set) var semibold17: UIFont = .pretendard(size: 17, weight: .semibold)
    private(set) var semibold18: UIFont = .pretendard(size: 18, weight: .semibold)
    private(set) var semibold20: UIFont = .pretendard(size: 20, weight: .semibold)

    private(set) var bold11: UIFont = .pretendard(size: 11, weight: .bold)
    private(set) var bold15: UIFont = .pretendard(size: 15, weight: .bold)
    private(set) var bold20: UIFont = .pretendard(size: 20, weight: .bold)
    private(set) var bold24: UIFont = .pretendard(size: 24, weight: .bold)
    
    init() {}
}

extension UIFont {
    static func pretendard(size fontSize: CGFloat, weight: UIFont.Weight) -> UIFont {
        let familyName = "Pretendard"
        
        var weightString: String
        switch weight {
        case .black:
            weightString = "Black"
        case .bold:
            weightString = "Blod"
        case .heavy:
            weightString = "ExtraBold"
        case .ultraLight:
            weightString = "ExtraLight"
        case .light:
            weightString = "Light"
        case .medium:
            weightString = "Medium"
        case .regular:
            weightString = "Regular"
        case .semibold:
            weightString = "SemiBold"
        case .thin:
            weightString = "Thin"
        default:
            weightString = "Regular"
        }
        
        return UIFont(name: "\(familyName)-\(weightString)", size: fontSize)
        ?? .systemFont(ofSize: fontSize, weight: weight)
    }
    
}
