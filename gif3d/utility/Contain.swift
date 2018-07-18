//
//  Contain.swift
//  gif3d
//
//  Created by Sam on 7/13/18.
//  Copyright © 2018 chuongtran. All rights reserved.
//

import Foundation
import UIKit

let APP_NAME:String = "gif3d"

let SCREEN_WIDTH : CGFloat = UIScreen.main.bounds.size.width
let SCREEN_HEIGHT : CGFloat = UIScreen.main.bounds.size.height

//MARK: - Font

func font_regular(size:CGFloat)->UIFont{
    return UIFont(name: "Helvetica", size: size)!
}
func font_medium(size:CGFloat)->UIFont{
    return UIFont(name: "Helvetica-Medium", size: size)!
}
func font_light(size:CGFloat)->UIFont{
    return UIFont(name: "Helvetica-Light", size: size)!
}
func font_semibold(size:CGFloat)->UIFont{
    return UIFont(name: "Helvetica-Semibold", size: size)!
}

func font_bold(size:CGFloat)->UIFont{
    return UIFont(name: "Helvetica-Bold", size: size)!
}
