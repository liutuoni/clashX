//
//  ConnectionsLeftPannelView.swift
//  ClashX
//
//  Created by yicheng on 2023/7/5.
//  Copyright © 2023 west2online. All rights reserved.
//

import AppKit

class ConnectionsLeftPannelView: NSView {
    let columnIdentifier = NSUserInterfaceItemIdentifier(rawValue: "column")
    private let tableView: NSTableView = {
        let table = NSTableView()
        table.columnAutoresizingStyle = .uniformColumnAutoresizingStyle
        table.backgroundColor = .clear
        table.allowsColumnSelection = false
        table.usesAutomaticRowHeights = true
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()

    init() {
        super.init(frame: .zero)
        setupSubviews()
        self.wantsLayer = true
        self.layer?.backgroundColor = NSColor.red.cgColor

        tableView.wantsLayer = true
        tableView.layer?.backgroundColor = NSColor.green.cgColor
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupSubviews() {
        let v = NSScrollView()
        addSubview(v)
        v.makeConstraintsToBindToSuperview(NSEdgeInsets(top: 50, left: 0, bottom: 0, right: 0))
        v.contentView.documentView = tableView

        let column = NSTableColumn(identifier: columnIdentifier)
        column.resizingMask = .autoresizingMask
        tableView.addTableColumn(column)
        tableView.intercellSpacing = NSSize(width: tableView.bounds.width, height: 24)
        tableView.headerView = nil
        tableView.delegate = self
        tableView.dataSource = self
        tableView.sizeLastColumnToFit()
        tableView.usesAutomaticRowHeights = true
        tableView.reloadData()

    }
}

extension ConnectionsLeftPannelView: NSTableViewDelegate {

}

extension ConnectionsLeftPannelView: NSTableViewDataSource {

}
