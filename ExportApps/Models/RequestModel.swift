//
//  Request.swift
//  ExportApps
//
//  Created by Levent ÖZGÜR on 19.09.2023.
//

import Foundation

struct RequestModel: Encodable {
    var id: String? = nil
    var appName: String? = nil
    var versionNumber: String? = nil
    var buildNumber: String? = nil
    var appBranch: String? = nil
    var appScheme: String? = nil
    var whatsNew: String? = nil
    var email: String?
    var password: String? = nil

    init() {
        switch KeyChainHepler.shared.getUserCredentials() {
        case .success(let credentials):
            let jsonData = Data(credentials.utf8)
            guard let userCredentials = try? JSONDecoder().decode(UserCredential.self, from: jsonData) else { break }
            self.email = userCredentials.email
            self.password = userCredentials.password
            break
        case .failure(let err):
            ReadyComponents.shared.showAlert(title: err.localizedDescription)
            break
        }
    }
    
    init(id: String?) {
        self.id = id
        
        switch KeyChainHepler.shared.getUserCredentials() {
        case .success(let credentials):
            let jsonData = Data(credentials.utf8)
            guard let userCredentials = try? JSONDecoder().decode(UserCredential.self, from: jsonData) else { break }
            self.email = userCredentials.email
            break
        case .failure(let err):
            ReadyComponents.shared.showAlert(title: err.localizedDescription)
            break
        }
    }
    
    init(appName: String?, versionNumber: String?, buildNumber: String?, appBranch: String?, appScheme: String?, whatsNew: String?){
        self.appName = appName?.replacingOccurrences(of: " ", with: "")
        self.versionNumber = versionNumber
        self.buildNumber = buildNumber
        self.appBranch = appBranch
        self.appScheme = appScheme
        self.whatsNew = whatsNew
        
        switch KeyChainHepler.shared.getUserCredentials() {
        case .success(let credentials):
            let jsonData = Data(credentials.utf8)
            guard let userCredentials = try? JSONDecoder().decode(UserCredential.self, from: jsonData) else { break }
            self.email = userCredentials.email
            break
        case .failure(let err):
            ReadyComponents.shared.showAlert(title: err.localizedDescription)
            break
        }
    }
}


