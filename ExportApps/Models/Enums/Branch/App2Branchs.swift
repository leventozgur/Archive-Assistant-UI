//
//  App2Branchs.swift
//  ExportApps
//
//  Created by Levent ÖZGÜR on 18.09.23.
//

import Foundation

enum App2Branchs: String, CaseIterable {
    case uat = "development"
    case dev = "master"
    
    static var getAll: [String] {
        return App2Branchs.allCases.map { $0.rawValue }
    }
}
