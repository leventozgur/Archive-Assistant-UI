//
//  AppNames.swift
//  ExportApps
//
//  Created by Levent ÖZGÜR on 18.09.23.
//

import Foundation

enum AppNames: String, CaseIterable {
    case app1 = "App 1"
    case app2 = "App 2"
    
    static var getAll: [String] {
        return AppNames.allCases.map { $0.rawValue }
    }
}
