//
//  AppDelegate.swift
//  ExportApps
//
//  Created by Levent ÖZGÜR on 17.09.23.
//

import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {
    let controller = WindowController()

    func applicationDidFinishLaunching(_ aNotification: Notification) {

        let menu = NSMenu()
        let fileMenuItem = NSMenuItem()
        fileMenuItem.title = "File"
        
        let fileMenu = NSMenu()
        
        let passwordItem = NSMenuItem()
        passwordItem.title = "Change User Credentials"
        passwordItem.action = #selector(showUserCredentialAlert)
        
        
        fileMenu.addItem(passwordItem)
        fileMenuItem.submenu = fileMenu
        menu.addItem(fileMenuItem)
        
        NSApplication.shared.mainMenu = menu
        
        controller.showWindow(self)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }


}

@objc
extension AppDelegate {
    func showUserCredentialAlert() {
        ReadyComponents.shared.showUserCredentialAlert()
    }
}
