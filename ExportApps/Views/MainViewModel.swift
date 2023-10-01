//
//  MainViewModel.swift
//  ExportApps
//
//  Created by Levent ÖZGÜR on 17.09.23.
//

import Foundation

public protocol MainViewModelProtocol: AnyObject {
    func showError(txt: String?)
    func showApps()
    func showBranch(appName: String)
    func showScheme(appName: String)
    func showVersionsAndArchiveBtn()
    func resetViews(allViews: Bool)
    func reloadTableViews()
    func changedConnectedStatus(isConnected: Bool)
}

final class MainViewModel {

    private let appNameArray = AppNames.getAll
    
    private let app1BranchArray = App1Branchs.getAll
    private let app2BranchArray = App2Branchs.getAll
    
    private let app1SchemeArray = App1Schemes.getAll
    private let app2SchemeArray = App2Schemes.getAll
    
    public weak var delegate: MainViewModelProtocol?
    private var userCredentials: UserCredential?
    private var isConnected: Bool = false {
        didSet {
            delegate?.changedConnectedStatus(isConnected: self.isConnected)
        }
    }
    
    private var archiveAndComplatedQueueData: ResponseData? {
        didSet {
            delegate?.reloadTableViews()
        }
    }
    private var repository: NetworkRepositoryProtocol?
    private var selectedApp: String? {
        didSet {
            guard (selectedApp != nil) else { return }
            delegate?.showBranch(appName: self.selectedApp ?? "")
        }
    }
    private var selectedBranch: String? {
        didSet {
            guard (selectedBranch != nil) else { return }
            delegate?.showScheme(appName: self.selectedApp ?? "")
        }
    }
    private var selectedScheme: String? {
        didSet {
            guard (selectedScheme != nil) else { return }
            delegate?.showVersionsAndArchiveBtn()
        }
    }
    private var selectedVersionNumber: String?
    private var selectedBuildNumber: String?
    private var selectedWhatsNew: String?
    private var selectedRowItemFromActiveTable: Item?
    private var timer: Timer?
    
    init(networkRepository: NetworkRepositoryProtocol) {
        self.repository = networkRepository
        
        switch KeyChainHepler.shared.getUserCredentials() {
        case .success(let credentials):
            let jsonData = Data(credentials.utf8)
            guard let userCredentials = try? JSONDecoder().decode(UserCredential.self, from: jsonData) else { break }
            self.userCredentials = userCredentials
            break
        case .failure(let err):
            delegate?.showError(txt: err.localizedDescription)
            break
        }
    }
}

extension MainViewModel {
    public func getAppNames() -> [String] {
        return self.appNameArray
    }
    
    public func getApp1Branchs() -> [String] {
        return self.app1BranchArray
    }
    
    public func getApp2Branchs() -> [String] {
        return self.app2BranchArray
    }
    
    public func getApp1Schemes() -> [String] {
        return self.app1SchemeArray
    }
    
    public func getApp2Schemes() -> [String] {
        return self.app2SchemeArray
    }
    
    public func getSelectedAppName() -> String? {
        return self.selectedApp
    }
    
    public func getIsConnected() -> Bool {
        return self.isConnected
    }
    
    public func getActiveQueueList() -> [Item] {
        return self.archiveAndComplatedQueueData?.deploymentsQueue ?? []
    }
    
    public func getComplatedQueueList() -> [Item] {
        return self.archiveAndComplatedQueueData?.completedQueue ?? []
    }
    
    public func getUserCredentials() -> UserCredential? {
        return self.userCredentials
    }
}

extension MainViewModel {
    public func setSelectedApp(appName: String) {
        self.selectedApp = appName
    }
    
    public func setSelectedBranch(branch: String) {
        self.selectedBranch = branch
    }
    
    public func setSelectedScheme(scheme: String) {
        self.selectedScheme = scheme
    }
    
    public func setSelectedVersionNumber(versionNumber: String) {
        self.selectedVersionNumber = versionNumber
    }
    
    public func setSelectedBuildNumber(buildNumber: String) {
        self.selectedBuildNumber = buildNumber
    }
    
    public func setSelectedWhatsNew(whatsNew: String) {
        self.selectedWhatsNew = whatsNew
    }
    
    public func setIP(ip: String) {
        Network.shared.setBaseURL(url: ip)
    }
    
    public func setSelectedRowItemFromActiveTable(item: Item) {
        self.selectedRowItemFromActiveTable = item
    }
    
    public func resetData(withSelectedApp: Bool = true) {
        if withSelectedApp {
            self.selectedApp = nil
        }
        self.selectedBranch = nil
        self.selectedScheme = nil
        self.selectedWhatsNew = nil
    }
    
    public func setUserCredentials(data: UserCredential) {
        self.userCredentials = data
    }
}

extension MainViewModel {
    public func checkConnectivity(showViews: Bool = false, clickBtn: Bool = false) {
        repository?.ping(complation: { [weak self] response in
            
            switch response {
            case .success(let tmpData):
                self?.archiveAndComplatedQueueData = tmpData.data
                
                self?.loginWithCredentials { result in
                    guard result else { self?.stopTimer(); self?.isConnected = false; return }
                    if !(self?.isConnected ?? true) {
                        self?.isConnected = true
                    }
                    self?.getQueues()
                    self?.startTimer()
                }
                break
            case .failure(let err):
                if (self?.isConnected ?? false) {
                    self?.isConnected = false
                }
                self?.stopTimer()
                if clickBtn {
                    self?.delegate?.showError(txt: err.localizedDescription)
                }
                break
            }
            
        })
    }
    
    private func loginWithCredentials(complation: @escaping (Bool) -> ()) {
        guard let repository = repository else { complation(false); return }
        repository.login(complation: { [weak self] response in
            switch response {
            case .success(let tmpData):
                guard tmpData.status ?? false else {
                    self?.delegate?.showError(txt: tmpData.data?.message);
                    complation(false);
                    return
                }
                
                complation(true)
                break
            case .failure(let err):
                self?.delegate?.showError(txt: err.localizedDescription)
                complation(false)
                break
            }
        })
    }
    
    public func getQueues() {
        if isConnected {
            repository?.getQueue(complation: { [weak self] response in
                
                switch response {
                case .success(let tmpData):
                    guard let status = tmpData.status, let data = tmpData.data, status else {
                        self?.delegate?.showError(txt: "getQueue beklenmedik bir hata!!")
                        break
                    }
                    self?.archiveAndComplatedQueueData = data
                    break
                case .failure(let err):
                    self?.delegate?.showError(txt: err.localizedDescription)
                    break
                }
            })
        }
    }
    
    public func startArchive() {
        if let selectedApp = selectedApp,
           let selectedBranch = selectedBranch,
           let selectedScheme = selectedScheme,
           let selectedVersionNumber = selectedVersionNumber, selectedVersionNumber != "",
           let selectedBuildNumber = selectedBuildNumber, selectedBuildNumber != "",
           let selectedWhatsNew = selectedWhatsNew, selectedWhatsNew != "", isConnected {
            
            let requestModel = RequestModel(appName: selectedApp,
                                            versionNumber: selectedVersionNumber,
                                            buildNumber: selectedBuildNumber,
                                            appBranch: selectedBranch,
                                            appScheme: selectedScheme,
                                            whatsNew: selectedWhatsNew)
            repository?.startDeployment(body: requestModel, complation: { [weak self] response in

                switch response {
                case .success(let tmpData):
                    guard let status = tmpData.status, let data = tmpData.data, status else {
                        self?.delegate?.showError(txt: "startArchive beklenmedik bir hata!!! => \(String(describing: tmpData.data?.message ?? ""))")
                        break
                    }
                    self?.archiveAndComplatedQueueData = data
                    self?.delegate?.resetViews(allViews: true)
                    break
                case .failure(let err):
                    self?.delegate?.showError(txt: err.localizedDescription)
                    break
                }
            })
            
        }else {
            delegate?.showError(txt: "startArchive alanlar boş olamaz!!!")
        }
        
    }
    
    public func clearQueue() {
        repository?.removeAllQueue(complation: { [weak self] response in
            switch response {
            case .success(let tmpData):
                guard let status = tmpData.status, let data = tmpData.data, status else {
                    self?.delegate?.showError(txt: "clearQueue beklenmedik bir hata!!")
                    break
                }
                self?.archiveAndComplatedQueueData = data
                break
            case .failure(let err):
                self?.delegate?.showError(txt: err.localizedDescription)
                break
            }
        })
    }
    
    public func moveToFirst() {
        guard let id = self.selectedRowItemFromActiveTable?.id else {
            delegate?.showError(txt: "You must select an item from active table!!!")
            return
        }
        repository?.moveToFirst(id: id, complation: { [weak self] response in
            switch response {
            case .success(let tmpData):
                guard let status = tmpData.status, let data = tmpData.data, status else {
                    self?.delegate?.showError(txt: "moveToFirst beklenmedik bir hata!!")
                    break
                }
                self?.archiveAndComplatedQueueData = data
                break
            case .failure(let err):
                self?.delegate?.showError(txt: err.localizedDescription)
                break
            }
        })
    }
    
    public func removeFromQueue() {
        guard let id = self.selectedRowItemFromActiveTable?.id else {
            delegate?.showError(txt: "You must select an item from active table!!!")
            return
        }
        repository?.removeWithId(id: id, complation: { [weak self] response in
            switch response {
            case .success(let tmpData):
                guard let status = tmpData.status, let data = tmpData.data, status else {
                    self?.delegate?.showError(txt: "getQueue beklenmedik bir hata!!")
                    break
                }
                self?.archiveAndComplatedQueueData = data
                break
            case .failure(let err):
                self?.delegate?.showError(txt: err.localizedDescription)
                break
            }
        })
    }
}

extension MainViewModel {
    func startTimer() {
        if timer == nil {
            timer = Timer.scheduledTimer(withTimeInterval: 30.0, repeats: true) { [weak self] _ in
                self?.checkConnectivity()
            }
        }
    }
    
    func stopTimer() {
        guard let timer = timer else { return }
        timer.invalidate()
    }
}
