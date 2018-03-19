//
//  LabelInsets.swift
//  PhysioApp
//
//  Created by Terence Chua on 19/03/2018.
//  Copyright © 2018 Philip Teow. All rights reserved.
//

import UIKit

class LabelInsets: UILabel {

    let topInset = CGFloat(20)
    let bottomInset = CGFloat(20)
    let leftInset = CGFloat(20)
    let rightInset = CGFloat(20)
    
    override func drawText(in rect: CGRect) {
        let insets: UIEdgeInsets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: UIEdgeInsetsInsetRect(rect, insets))
    }
    
    override public var intrinsicContentSize: CGSize {
        var intrinsicSuperViewContentSize = super.intrinsicContentSize
        intrinsicSuperViewContentSize.height += topInset + bottomInset
        intrinsicSuperViewContentSize.width += leftInset + rightInset
        return intrinsicSuperViewContentSize
    }

}
