//
//  Editors.swift
//  gif3d
//
//  Created by Sam on 7/11/18.
//  Copyright © 2018 chuongtran. All rights reserved.
//

import Foundation
import UIKit

struct Path {
    let fromPoint: CGPoint
    let toPoint: CGPoint
}

struct Tool {
    var path:Path
    var radius:CGFloat
}

class Editor {
    var image:UIImage?
    var tools:[Tool]?
    
    init() {
        
    }
    
    init(image:UIImage, tools:[Tool] = []) {
        self.image = image
        self.tools = tools
    }
    
    func isEdited() -> Bool {
        return (self.tools?.count)! > 0
    }
}
