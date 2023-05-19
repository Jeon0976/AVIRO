//
//  Config.swift
//  VeganRestaurant
//
//  Created by 전성훈 on 2023/05/19.
//

import UIKit

final class Config {
    static let shared = Config()
    
    let buttonImageConfig = UIImage.SymbolConfiguration(pointSize: 38, weight: .medium)
    
    private init() {  }
}
