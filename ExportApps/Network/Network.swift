//
//  Network.swift
//  ExportApps
//
//  Created by Levent ÖZGÜR on 19.09.2023.
//

import Foundation
import Alamofire

final class Network {
    public static var shared = Network()
    private var IP = ""
    
    public func setBaseURL(url: String) {
        if !url.contains("http://") && !url.contains("https://") {
            self.IP = "http://" + url
        }else {
            self.IP = url
        }
    }
    
    public func request(type: HTTPMethod, subURL: String, body: RequestModel? = nil, complation: @escaping(Result<ResponseModel, Error>) -> ()) {
        let url = IP + subURL
        let request = AF.request(url, method: type, parameters: body)
        request.responseDecodable(of: ResponseModel.self) { response in
            
            switch response.result {
            case .success(let result):
                guard let data = response.value else { return }
                print(data)
                complation(.success(data))
                break
            case .failure(let err):
                print(err)
                complation(.failure(err))
                break
            }
        }
    }
}
