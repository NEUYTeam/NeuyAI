//
//  NSBundle+Version.swift
//  Neuy
//
//  Created by Thomas on 2024-01-02.
//

import Foundation

extension Bundle {

    var releaseVersionNumber: String? {
        return self.infoDictionary?["CFBundleShortVersionString"] as? String
    }

    var buildVersionNumber: String? {
        return self.infoDictionary?["CFBundleVersion"] as? String
    }

}
