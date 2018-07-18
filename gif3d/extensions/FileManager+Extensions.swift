//
//  File.swift
//  gif3d
//
//  Created by Sam on 7/9/18.
//  Copyright © 2018 chuongtran. All rights reserved.
//

import Foundation

extension FileManager {
    func homeDirectory() -> URL {
        return URL(fileURLWithPath: NSHomeDirectory())
    }
    
    func homeDirectoryPath() -> String {
        return NSHomeDirectory()
    }
    
    func tmpDirectory() -> URL {
        return homeDirectory().appendingPathComponent("tmp")
    }
    
}
