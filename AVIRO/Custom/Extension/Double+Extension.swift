//
//  Double.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/07/30.
//

import Foundation

extension Double {
    var degreesToRadians: Double { return self * .pi / 180 }
    
    var roundedToFourDecimalPlaces: Double {
         return (self * 10000).rounded() / 10000
    }
}
