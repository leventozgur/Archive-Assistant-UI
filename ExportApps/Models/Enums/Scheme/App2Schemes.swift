//
//  App2Schemes.swift
//  ExportApps
//
//  Created by Levent ÖZGÜR on 18.09.23.
//

import Foundation

enum App2Schemes: String, CaseIterable {
    case uat = "Debug"
    case pilot = "Release"
    
    static var getAll: [String] {
        return App2Schemes.allCases.map { $0.rawValue }
    }
}
