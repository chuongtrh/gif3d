//
//  File.swift
//  gif3d
//
//  Created by Sam on 7/9/18.
//  Copyright © 2018 chuongtran. All rights reserved.
//

import Foundation

import UIKit

extension UIView {
    
    func createImage() -> UIImage? {
        
        let rect: CGRect = self.frame
        
        UIGraphicsBeginImageContext(rect.size)
        let context: CGContext = UIGraphicsGetCurrentContext()!
        self.layer.render(in: context)
        let img:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return img
        
    }
    
}
