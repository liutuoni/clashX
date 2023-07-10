//
//  ClashWindowController.swift
//  ClashX
//
//  Created by yicheng on 2023/7/5.
//  Copyright © 2023 west2online. All rights reserved.
//
import AppKit

class ClashWindowController<T: NSViewController>: NSWindowController, NSWindowDelegate {
    var onWindowClose: (() -> Void)?

    static func create() -> NSWindowController {
        let win = NSWindow()
        win.center()
        let wc = ClashWebViewWindowController(window: win)
        wc.contentViewController = T()
        wc.windowFrameAutosaveName = T.className()

        win.titlebarAppearsTransparent = true
        win.backgroundColor = NSColor(red: 239/255.0, green: 239/255.0, blue: 239/255.0, alpha: 1)
        return wc
    }

    override func showWindow(_ sender: Any?) {
        super.showWindow(sender)
        NSApp.activate(ignoringOtherApps: true)
        window?.makeKeyAndOrderFront(self)
        window?.delegate = self
    }

    func windowWillClose(_ notification: Notification) {
        NSApp.setActivationPolicy(.accessory)
        onWindowClose?()
    }
}
