//
//  Bun.swift
//  YWOMOLLY_dev
//
//  Created by Sam on 5/30/18.
//  Copyright © 2018 94. All rights reserved.
//

import Foundation


extension Bundle {
    var releaseVersionNumber: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
    var buildVersionNumber: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }
}
