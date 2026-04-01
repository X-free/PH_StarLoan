//
//  UILabel+Style.swift
//  NewNewStarLoan
//
//  Created by Albert on 2025/5/5.
//

import UIKit

extension UILabel {
    /// 设置标准的 Mine 页面标签样式
    func applyMineStyle() {
        self.font = .systemFont(ofSize: 14, weight: .medium)
        self.textColor = UIColor(hex: "06101C")
    }
}

// 添加 UIColor 十六进制初始化方法
extension UIColor {
    convenience init(hex: String) {
        var hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if hexString.hasPrefix("#") {
            hexString.remove(at: hexString.startIndex)
        }
        
        var rgbValue: UInt64 = 0
        Scanner(string: hexString).scanHexInt64(&rgbValue)
        
        let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgbValue & 0x0000FF) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}
