//
//  RepositoryProtocol.swift
//  ExportApps
//
//  Created by Levent ÖZGÜR on 19.09.2023.
//

import Foundation

protocol NetworkRepositoryProtocol {
    func ping(complation: @escaping (Result<ResponseModel, Error>) -> ())
    func login(complation: @escaping (Result<ResponseModel, Error>) -> ())
    func startDeployment(body: RequestModel?, complation: @escaping (Result<ResponseModel, Error>) -> ())
    func getQueue(complation: @escaping (Result<ResponseModel, Error>) -> ())
    func removeAllQueue(complation: @escaping (Result<ResponseModel, Error>) -> ())
    func removeWithId(id: String, complation: @escaping (Result<ResponseModel, Error>) -> ())
    func moveToFirst(id: String, complation: @escaping (Result<ResponseModel, Error>) -> ())
}
