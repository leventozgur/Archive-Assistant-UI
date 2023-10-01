//
//  WindowController.swift
//  ExportApps
//
//  Created by Levent ÖZGÜR on 18.09.23.
//

import Cocoa

class WindowController: NSWindowController, NSWindowDelegate {
 
    init() {
        
        let window = Window()
 
        super.init(window: window)
        
        window.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
