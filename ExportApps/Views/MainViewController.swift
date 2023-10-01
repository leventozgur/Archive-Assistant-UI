//
//  ViewController.swift
//  ExportApps
//
//  Created by Levent ÖZGÜR on 17.09.23.
//

import Cocoa

class MainViewController: NSViewController {
    internal let viewModel = MainViewModel(networkRepository: NetworkRepository())
    private var isShowingBranchList: Bool = false
    private var isShowingSchemeList: Bool = false
    private var isShowingVersionsAndArchiveBtn: Bool = false
    private let columnIdentifiers = ["appName", "appScheme", "appBranch", "versionNumber", "buildNumber", "whatsNew", "status", "userEmail", "addQueueTime", "deploymentEndTime"]

    private lazy var ipStackView: NSStackView = {
        let tmp = NSStackView()
        tmp.translatesAutoresizingMaskIntoConstraints = false
        tmp.orientation = .horizontal
        tmp.alignment = .centerY
        tmp.spacing = 10.0

        return tmp
    }()

    private lazy var ipTextField: NSTextField = {
        let tmp = NSTextField()
        tmp.translatesAutoresizingMaskIntoConstraints = false
        tmp.placeholderString = "ip"
        tmp.font = NSFont.systemFont(ofSize: 14)
        tmp.isEditable = true
        tmp.drawsBackground = false

        return tmp
    }()

    private lazy var ipPingBtn: NSButton = {
        let tmp = NSButton(title: "Check IP", target: self, action: #selector(checkIP(_:)))
        tmp.translatesAutoresizingMaskIntoConstraints = false

        return tmp
    }()

    private lazy var connectedLbl: NSTextField = {
        let tmp = NSTextField()
        tmp.translatesAutoresizingMaskIntoConstraints = false
        tmp.stringValue = "Not Connected"
        tmp.textColor = .systemRed
        tmp.font = NSFont.boldSystemFont(ofSize: 14)
        tmp.isEditable = false
        tmp.isBezeled = false
        tmp.drawsBackground = false

        return tmp
    }()

    private lazy var divider: NSView = {
        let tmp = NSView()
        tmp.translatesAutoresizingMaskIntoConstraints = false
        tmp.wantsLayer = true
        tmp.layer?.backgroundColor = NSColor.systemGray.cgColor

        return tmp
    }()

    private lazy var horizontalDivider: NSView = {
        let tmp = NSView()
        tmp.translatesAutoresizingMaskIntoConstraints = false
        tmp.wantsLayer = true
        tmp.layer?.backgroundColor = NSColor.systemGray.cgColor

        return tmp
    }()

    private lazy var columnStackView: NSStackView = {
        let tmp = NSStackView()
        tmp.translatesAutoresizingMaskIntoConstraints = false
        tmp.orientation = .horizontal
        tmp.alignment = .centerY

        return tmp
    }()

    private lazy var tableStackView: NSStackView = {
        let tmp = NSStackView()
        tmp.translatesAutoresizingMaskIntoConstraints = false
        tmp.orientation = .vertical
        tmp.alignment = .left

        return tmp
    }()

    private lazy var mainStackView: NSStackView = {
        let tmp = NSStackView()
        tmp.translatesAutoresizingMaskIntoConstraints = false
        tmp.orientation = .vertical
        tmp.alignment = .left

        return tmp
    }()

    private lazy var buttonGroupStackView: NSStackView = {
        let tmp = NSStackView()
        tmp.translatesAutoresizingMaskIntoConstraints = false
        tmp.orientation = .horizontal
        tmp.alignment = .centerY

        return tmp
    }()

    private lazy var startArchiveBtn: NSButton = {
        let tmp = NSButton(title: "Start Archive", target: self, action: #selector(startArchive(_:)))
        tmp.translatesAutoresizingMaskIntoConstraints = false

        return tmp
    }()

    private lazy var resetBtn: NSButton = {
        let tmp = NSButton(title: "Reset", target: self, action: #selector(reset(_:)))
        tmp.translatesAutoresizingMaskIntoConstraints = false

        return tmp
    }()

    internal lazy var activeTableView: NSTableView = {
        let tmp = NSTableView()
        tmp.translatesAutoresizingMaskIntoConstraints = false

        return tmp
    }()

    internal lazy var complatedTableView: NSTableView = {
        let tmp = NSTableView()
        tmp.translatesAutoresizingMaskIntoConstraints = false

        return tmp
    }()
    
    private lazy var activeScrollView: NSScrollView = {
        let tmp = NSScrollView()
        tmp.translatesAutoresizingMaskIntoConstraints = false
        tmp.documentView = activeTableView
        tmp.hasVerticalScroller = true
        tmp.hasHorizontalScroller = true
        tmp.autohidesScrollers = true

        return tmp
    }()
    
    private lazy var complatedScrollView: NSScrollView = {
        let tmp = NSScrollView()
        tmp.translatesAutoresizingMaskIntoConstraints = false
        tmp.documentView = complatedTableView
        tmp.hasVerticalScroller = true
        tmp.hasHorizontalScroller = true
        tmp.autohidesScrollers = true

        return tmp
    }()
    
    private lazy var tableButtonsStackView: NSStackView = {
        let tmp = NSStackView()
        tmp.translatesAutoresizingMaskIntoConstraints = false
        tmp.orientation = .horizontal
        tmp.alignment = .centerY
        tmp.spacing = 10.0

        return tmp
    }()
    
    private lazy var clearQueueBtn: NSButton = {
        let tmp = NSButton(title: "Clear Active Queue", target: self, action: #selector(clearQueue(_:)))
        tmp.translatesAutoresizingMaskIntoConstraints = false

        return tmp
    }()
    
    private lazy var moveToFirstBtn: NSButton = {
        let tmp = NSButton(title: "Move To First", target: self, action: #selector(moveToFirst(_:)))
        tmp.translatesAutoresizingMaskIntoConstraints = false

        return tmp
    }()
    
    private lazy var removeFromQueueBtn: NSButton = {
        let tmp = NSButton(title: "Remove From Queue", target: self, action: #selector(removeFromQueue(_:)))
        tmp.translatesAutoresizingMaskIntoConstraints = false

        return tmp
    }()

    //MARK: - Default functions
    override func loadView() {
        view = NSView(frame: NSRect(origin: .zero, size: NSSize(width: StaticVeriables.windowWidth, height: StaticVeriables.windowHeight)))
    }

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidAppear() {
        super.viewDidAppear()
        self.view.window?.title = StaticVeriables.windowTitle
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.viewModel.delegate = self
        self.setupUI()
    }

    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
}

extension MainViewController {
    private func setupUI() {
        self.view.addSubview(columnStackView)
        columnStackView.addArrangedSubview(mainStackView)
        columnStackView.addArrangedSubview(horizontalDivider)
        columnStackView.addArrangedSubview(tableStackView)

        ReadyComponents.shared.createTitle(title: "Active Table", addToStackView: tableStackView)
        tableStackView.addArrangedSubview(activeScrollView)
        ReadyComponents.shared.createTitle(title: "Complated Table", addToStackView: tableStackView)
        tableStackView.addArrangedSubview(complatedScrollView)
        
        tableStackView.addArrangedSubview(tableButtonsStackView)
        tableButtonsStackView.addArrangedSubview(clearQueueBtn)
        tableButtonsStackView.addArrangedSubview(removeFromQueueBtn)
        tableButtonsStackView.addArrangedSubview(moveToFirstBtn)

        activeTableView.delegate = self
        activeTableView.dataSource = self
        complatedTableView.delegate = self
        complatedTableView.dataSource = self
        
        createTableColumns(tableview: activeTableView)
        createTableColumns(tableview: complatedTableView)

        NSLayoutConstraint.activate([
            columnStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16.0),
            columnStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16.0),
            columnStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 16.0),
            columnStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16.0),

            horizontalDivider.widthAnchor.constraint(equalToConstant: 1),
            horizontalDivider.heightAnchor.constraint(equalTo: view.heightAnchor, constant: -25.0),
            mainStackView.heightAnchor.constraint(equalTo: view.heightAnchor),
            mainStackView.widthAnchor.constraint(equalToConstant: (StaticVeriables.windowWidth / 6) * 2),

            tableStackView.heightAnchor.constraint(equalTo: view.heightAnchor),
            tableStackView.leadingAnchor.constraint(equalTo: mainStackView.trailingAnchor, constant: 20.0),
            tableStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16.0),

            activeScrollView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5, constant: -70),
            complatedScrollView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5, constant: -70),
        ])

        self.startViews()
    }
}

@objc
extension MainViewController {
    func radioButtonSelected(sender: NSButton) {
        if sender.state == .on {
            let selectedTitle = sender.title

            if !AppNames.allCases.filter({ $0.rawValue == selectedTitle }).isEmpty {
                if self.isShowingBranchList {
                    self.resetViews(allViews: false)
                }
                self.viewModel.setSelectedApp(appName: selectedTitle)
            } else if !App1Branchs.allCases.filter({ $0.rawValue == selectedTitle }).isEmpty ||
                !App2Branchs.allCases.filter({ $0.rawValue == selectedTitle }).isEmpty {
                self.viewModel.setSelectedBranch(branch: selectedTitle)
            } else if !App1Schemes.allCases.filter({ $0.rawValue == selectedTitle }).isEmpty ||
                !App2Schemes.allCases.filter({ $0.rawValue == selectedTitle }).isEmpty {
                self.viewModel.setSelectedScheme(scheme: selectedTitle)
            }

        }
    }

    func checkIP(_ sender: NSButton) {
        guard let _ = viewModel.getUserCredentials() else {
            ReadyComponents.shared.showUserCredentialAlert()
            return
        }
        
        guard let ip = (self.ipStackView.subviews.first?.subviews.last as? NSTextField)?.stringValue, ip != "" else {
            self.showError(txt: "URL alano boş olamaz!!!")
            return
        }
        self.viewModel.setIP(ip: ip)
        self.viewModel.checkConnectivity(showViews: true, clickBtn: true)
    }

    func reset(_ sender: NSButton) {
        self.resetViews(allViews: true)
    }

    func startArchive(_ sender: NSButton) {
        guard let versionNumber = (mainStackView.subviews[8].subviews.last as? NSTextField)?.stringValue,
            let buildNumber = (mainStackView.subviews[9].subviews.last as? NSTextField)?.stringValue,
            let whatsnew = (mainStackView.subviews[10].subviews.last as? NSTextField)?.stringValue else { return }

        self.viewModel.setSelectedVersionNumber(versionNumber: versionNumber)
        self.viewModel.setSelectedBuildNumber(buildNumber: buildNumber)
        self.viewModel.setSelectedWhatsNew(whatsNew: whatsnew)

        self.viewModel.startArchive()
    }
    
    func clearQueue(_ sender: NSButton) {
        self.viewModel.clearQueue()
    }
    
    func moveToFirst(_ sender: NSButton) {
        self.viewModel.moveToFirst()
    }
    
    func removeFromQueue(_ sender: NSButton) {
        self.viewModel.removeFromQueue()
    }
}


//MARK: -Create Radio Buton
extension MainViewController {
    private func createRadioGroup(title: String, list: [String]) {
        let tmpTitle = NSTextField()
        tmpTitle.translatesAutoresizingMaskIntoConstraints = false
        tmpTitle.stringValue = title
        tmpTitle.font = NSFont.boldSystemFont(ofSize: 14)
        tmpTitle.isEditable = false
        tmpTitle.isBezeled = false
        tmpTitle.drawsBackground = false
        self.mainStackView.addArrangedSubview(tmpTitle)

        let tmpStackview = NSStackView()
        tmpStackview.translatesAutoresizingMaskIntoConstraints = false
        tmpStackview.orientation = .horizontal
        tmpStackview.alignment = .centerY
        tmpStackview.spacing = 10.0
        self.mainStackView.addArrangedSubview(tmpStackview)

        list.forEach({ tmpStackview.addArrangedSubview(createRadioButton(title: $0)) })
    }

    private func createRadioButton(title: String) -> NSButton {
        let radioButton = NSButton(radioButtonWithTitle: title, target: self, action: #selector(radioButtonSelected(sender:)))
        radioButton.translatesAutoresizingMaskIntoConstraints = false
        radioButton.setButtonType(.radio)
        radioButton.state = .off
        return radioButton
    }
}

extension MainViewController {
    func startViews() {
        self.mainStackView.addArrangedSubview(connectedLbl)
        self.mainStackView.addArrangedSubview(divider)
        if !viewModel.getIsConnected() {
            self.mainStackView.addArrangedSubview(ipStackView)
            ReadyComponents.shared.createTextField(title: "IP Address      : ", placeHolder: "127.0.0.1:3000", addToStackView: ipStackView)
            self.ipStackView.addArrangedSubview(ipPingBtn)
            self.ipStackView.isHidden = false
        }
        
        NSLayoutConstraint.activate([
            ipPingBtn.heightAnchor.constraint(equalToConstant: 25),
            divider.heightAnchor.constraint(equalToConstant: 1)
        ])

        if self.viewModel.getIsConnected() {
            self.showApps()
        }
    }
    
    private func createTableColumns(tableview: NSTableView) {
        for (index, identifier) in columnIdentifiers.enumerated() {
            let column = NSTableColumn(identifier: NSUserInterfaceItemIdentifier(identifier))
            column.headerCell.stringValue = columnIdentifiers[index]
            tableview.addTableColumn(column)
        }
    }

}

extension MainViewController: MainViewModelProtocol {
    func changedConnectedStatus(isConnected: Bool) {
        self.connectedLbl.stringValue = isConnected ? "Connected with '\(String(describing: viewModel.getUserCredentials()?.email ?? ""))'" : "Not Connected"
        self.connectedLbl.textColor = isConnected ? .systemGreen : .systemRed
        self.resetViews(allViews: true)
    }

    func reloadTableViews() {
        activeTableView.reloadData()
        complatedTableView.reloadData()
    }

    func resetViews(allViews: Bool) {
        isShowingBranchList = false
        isShowingSchemeList = false
        isShowingVersionsAndArchiveBtn = false
        self.viewModel.resetData(withSelectedApp: allViews)
        
        if !allViews && self.mainStackView.subviews.count > 3 {
            for _ in 4 ..< self.mainStackView.subviews.count {
                self.mainStackView.subviews[4].removeFromSuperview()
            }
        } else {
            self.mainStackView.subviews.removeAll()
            self.ipStackView.subviews.removeAll()
            self.startViews()
        }
    }

    func showError(txt: String?) {
        ReadyComponents.shared.showAlert(title: txt ?? "")
    }

    func showApps() {
        self.ipStackView.isHidden = true
        self.createRadioGroup(title: "Select App", list: self.viewModel.getAppNames())
    }

    func showBranch(appName: String) {
        guard !isShowingBranchList else { return }
        self.isShowingBranchList = true

        switch(appName) {
        case AppNames.app1.rawValue:
            self.createRadioGroup(title: "Select Branch", list: self.viewModel.getApp1Branchs())
            break
        case AppNames.app2.rawValue:
            self.createRadioGroup(title: "Select Branch", list: self.viewModel.getApp2Branchs())
            break
        default:
            break
        }
    }

    func showScheme(appName: String) {
        guard !isShowingSchemeList else { return }
        self.isShowingSchemeList = true

        switch(appName) {
        case AppNames.app1.rawValue:
            self.createRadioGroup(title: "Select Scheme", list: self.viewModel.getApp1Schemes())
            break
        case AppNames.app2.rawValue:
            self.createRadioGroup(title: "Select Scheme", list: self.viewModel.getApp2Schemes())
            break
        default:
            break
        }
    }

    func showVersionsAndArchiveBtn() {
        guard !isShowingVersionsAndArchiveBtn else { return }
        self.isShowingVersionsAndArchiveBtn = true

        ReadyComponents.shared.createTextField(title: "Version Number  :", placeHolder: "1.4.3", addToStackView: mainStackView)
        ReadyComponents.shared.createTextField(title: "Build Number       :", placeHolder: "10", addToStackView: mainStackView)
        ReadyComponents.shared.createTextField(title: "Whats New            :", placeHolder: "Cart Bug Fix", addToStackView: mainStackView)

        self.mainStackView.addArrangedSubview(buttonGroupStackView)
        self.buttonGroupStackView.addArrangedSubview(resetBtn)
        self.buttonGroupStackView.addArrangedSubview(startArchiveBtn)
    }
}

