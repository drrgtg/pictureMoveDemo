//
//  Double+RoundToDecimal.swift
//  SliderImages
//
//  Created by 刘Sir on 2021/3/10.
//

import Foundation

extension Double {
    func roundToDecimal(_ fractionDigits: Int) -> Double {
        let multiplier = pow(10, Double(fractionDigits))
        return Darwin.round(self * multiplier) / multiplier
    }
}
