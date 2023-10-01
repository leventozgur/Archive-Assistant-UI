//
//  Window.swift
//  ExportApps
//
//  Created by Levent ÖZGÜR on 18.09.23.
//

import Cocoa

class Window: NSWindow {

    init() {
        
        let windowHeight = StaticVeriables.windowHeight
        let windowWidth = StaticVeriables.windowWidth
        
        let screen  = NSScreen.main!.frame
        let origin = NSPoint(x:(screen.width/2) - (windowWidth/2), y: (screen.height/2) - (windowHeight/2))
        
        super.init(
            contentRect: NSRect(origin: origin, size: NSSize(width: windowWidth, height: windowHeight)),
            styleMask: [.titled, .closable, .miniaturizable, .resizable],
            backing: .buffered,
            defer: false
        )
        
        self.contentViewController = MainViewController()
    }
}
