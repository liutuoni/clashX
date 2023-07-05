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
        v.translatesAutoresizingMaskIntoConstraints = false
        v.wantsLayer = true
        v.drawsBackground = false
        v.documentView = tableView
        self.addSubview(v)
        v.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        v.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        v.topAnchor.constraint(equalTo: self.topAnchor, constant: 50).isActive = true

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: v.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: v.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: v.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: v.trailingAnchor),
            tableView.heightAnchor.constraint(equalTo: self.heightAnchor)
        ])
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
