//
//  Response.swift
//  ExportApps
//
//  Created by Levent ÖZGÜR on 19.09.2023.
//

import Foundation

struct ResponseModel: Decodable {
    let data:ResponseData?
    let status: Bool?
}

struct ResponseData: Decodable {
    var message: String?
    var deploymentsQueue: [Item]?
    var completedQueue: [Item]?
}

struct Item: Decodable {
    let id: String?
    let appName: String?
    let appScheme: String?
    let appBranch: String?
    let versionNumber: String?
    let buildNumber: String?
    let whatsNew: String?
    let addQueueTime: String?
    let deploymentEndTime: String?
    let userEmail: String?
    let status: String?
    
    func getValueWithIndex(index: Int) -> String {
        switch index {
        case 0:
            return self.appName ?? ""
        case 1:
            return self.appScheme ?? ""
        case 2:
            return self.appBranch ?? ""
        case 3:
            return self.versionNumber ?? ""
        case 4:
            return self.buildNumber ?? ""
        case 5:
            return self.whatsNew ?? ""
        case 6:
            return self.status ?? ""
        case 7:
            return self.userEmail ?? ""
        case 8:
            return self.addQueueTime ?? ""
        case 9:
            return self.deploymentEndTime ?? ""
        default:
            return ""
        }
    }
}
