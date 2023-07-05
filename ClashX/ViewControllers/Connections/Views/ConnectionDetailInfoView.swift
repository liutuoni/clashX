//
//  ConnectionDetailInfoView.swift
//  ClashX
//
//  Created by yicheng on 2023/7/5.
//  Copyright © 2023 west2online. All rights reserved.
//

import AppKit

class ConnectionDetailInfoView: NSView {
    init() {
        super.init(frame: .zero)
        setupSubviews()
        wantsLayer = true
        layer?.backgroundColor = NSColor.purple.cgColor
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupSubviews() {

    }
}
