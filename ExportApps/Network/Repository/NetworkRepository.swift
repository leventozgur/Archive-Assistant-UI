//
//  NetworkRepository.swift
//  ExportApps
//
//  Created by Levent ÖZGÜR on 19.09.2023.
//

import Foundation

final class NetworkRepository: NetworkRepositoryProtocol {
    
    func ping(complation: @escaping (Result<ResponseModel, Error>) -> ()) {
        Network.shared.request(type: .get, subURL: NetworkServices.ping.rawValue) { response in
            complation(response)
        }
    }
    
    func login(complation: @escaping (Result<ResponseModel, Error>) -> ()) {
        Network.shared.request(type: .post, subURL: NetworkServices.login.rawValue, body: RequestModel()) { response in
            complation(response)
        }
    }
    
    func startDeployment(body: RequestModel?, complation: @escaping (Result<ResponseModel, Error>) -> ()) {
        Network.shared.request(type: .post, subURL: NetworkServices.startDeployment.rawValue, body: body) { response in
            complation(response)
        }
    }
    
    func getQueue(complation: @escaping (Result<ResponseModel, Error>) -> ()) {
        Network.shared.request(type: .post, subURL: NetworkServices.getQueue.rawValue, body: RequestModel()) { response in
            complation(response)
        }
    }
    
    func removeAllQueue(complation: @escaping (Result<ResponseModel, Error>) -> ()) {
        Network.shared.request(type: .post, subURL: NetworkServices.removeAllQueue.rawValue, body: RequestModel()) { response in
            complation(response)
        }
    }
    
    func removeWithId(id: String, complation: @escaping (Result<ResponseModel, Error>) -> ()) {
        let body = RequestModel(id: id)
        Network.shared.request(type: .post, subURL: NetworkServices.removeWithId.rawValue, body: body) { response in
            complation(response)
        }
    }
    
    func moveToFirst(id: String, complation: @escaping (Result<ResponseModel, Error>) -> ()) {
        let body = RequestModel(id: id)
        Network.shared.request(type: .post, subURL: NetworkServices.moveToFirst.rawValue, body: body) { response in
            complation(response)
        }
    }
}
