//
//  UILabel+TestNewApp.swift
//  TestNewsApp
//
//  Created by пользователь on 4/3/21.
//

import UIKit

// MARK: - Initialization of maximal elements properties 
extension UILabel {
    func calculateMaxLines() -> Int {
        let maxSize = CGSize(width: frame.size.width, height: CGFloat(Float.infinity))
        let charSize = font.lineHeight
        let text = (self.text ?? "") as NSString
        let textSize = text.boundingRect(with: maxSize,
                                         options: .usesLineFragmentOrigin,
                                         attributes: [NSAttributedString.Key.font: font as Any],
                                         context: nil)
        let linesRoundedUp = Int(ceil(textSize.height/charSize))
        return linesRoundedUp
    }
}
