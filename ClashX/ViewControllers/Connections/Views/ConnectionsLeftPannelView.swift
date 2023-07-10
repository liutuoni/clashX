//
//  ConnectionsLeftPannelView.swift
//  ClashX
//
//  Created by yicheng on 2023/7/5.
//  Copyright © 2023 west2online. All rights reserved.
//

import AppKit

fileprivate extension NSUserInterfaceItemIdentifier {
    static let mainColumn = NSUserInterfaceItemIdentifier("mainColumn")
}

@available(macOS 10.15, *)
class ConnectionsLeftPannelView: NSView {
    let viewModel:ConnectionLeftPannelViewModel
    let columnIdentifier = NSUserInterfaceItemIdentifier(rawValue: "column")
    private let tableView: NSTableView = {
        let table = NSTableView()
        table.columnAutoresizingStyle = .uniformColumnAutoresizingStyle
        table.backgroundColor = NSColor(red: 225.0/255.0, green: 224.0/255.0, blue: 225.0/255.0, alpha: 1)
        table.allowsColumnSelection = false
        table.usesAutomaticRowHeights = true
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()

    init(viewModel:ConnectionLeftPannelViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setupSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupSubviews() {
        let v = NSScrollView()
        v.contentView.documentView = tableView
        addSubview(v)
        v.makeConstraintsToBindToSuperview()
        v.hasVerticalScroller = true
        v.hasHorizontalScroller = true

        let column = NSTableColumn(identifier: .mainColumn)
        column.minWidth = 60
        column.maxWidth = .greatestFiniteMagnitude
        tableView.addTableColumn(column)
        tableView.headerView = nil
        tableView.intercellSpacing = .zero

        tableView.usesAlternatingRowBackgroundColors = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.sizeLastColumnToFit()
        tableView.reloadData()

        viewModel.onReloadTable = { [weak self] in
            self?.tableView.reloadData()
        }
    }
}

@available(macOS 10.15, *)
extension ConnectionsLeftPannelView: NSTableViewDelegate {
    func tableViewSelectionDidChange(_ notification: Notification) {
        viewModel.setSelect(row: tableView.selectedRow)
    }

    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 36
    }
}

@available(macOS 10.15, *)
extension ConnectionsLeftPannelView: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return viewModel.connections.count
    }

    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard let tableColumn else {
            return nil
        }
        var view = tableView.makeView(withIdentifier: tableColumn.identifier, owner: self) as? ConnectionApplicationCellProtocol
        if view == nil {
            view = ConnectionApplicationClientCellView()
            view?.identifier = tableColumn.identifier
        }
        let c = viewModel.connections[row]
        view?.setup(with: c)
        return view
    }
}
