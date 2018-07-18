//
//  CALayer+Shadow.swift
//  YWOMOLLY_dev
//
//  Created by Sam on 5/10/18.
//  Copyright © 2018 94. All rights reserved.
//

import Foundation
import UIKit

extension CALayer {
    
    func makeShadow(color: UIColor,
                    x: CGFloat = 0,
                    y: CGFloat = 0,
                    blur: CGFloat = 0,
                    spread: CGFloat = 0) {
        shadowColor = color.cgColor
        shadowOpacity = 1
        shadowOffset = CGSize(width: x, height: y)
        shadowRadius = blur / 2
        if spread == 0 {
            shadowPath = nil
        }
        else {
            let rect = bounds.insetBy(dx: -spread, dy: -spread)
            shadowPath = UIBezierPath(rect: rect).cgPath
        }
    }
    
    func removeShadow(){
        shadowColor = UIColor.clear.cgColor
        shadowOpacity = 0
        shadowRadius = 0
    }
}
