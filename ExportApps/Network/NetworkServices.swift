//
//  Services.swift
//  ExportApps
//
//  Created by Levent ÖZGÜR on 18.09.2023.
//

import Foundation

enum NetworkServices: String {
    case ping = "/ping"
    case login = "/login"
    case startDeployment = "/startDeployment"
    case removeAllQueue = "/removeAllQueue"
    case removeWithId = "/removeWithId"
    case moveToFirst = "/moveToFirst"
    case getQueue = "/getQueue"
}
