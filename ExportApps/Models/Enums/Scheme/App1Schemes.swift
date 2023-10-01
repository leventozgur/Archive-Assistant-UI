//
//  App1Schemes.swift
//  ExportApps
//
//  Created by Levent ÖZGÜR on 18.09.23.
//

import Foundation

enum App1Schemes: String, CaseIterable {
    case uat = "Debug"
    case pilot = "Release"
    
    static var getAll: [String] {
        return App1Schemes.allCases.map { $0.rawValue }
    }
}
