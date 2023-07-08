//
//  ConnectionTopListView.swift
//  ClashX
//
//  Created by yicheng on 2023/7/5.
//  Copyright © 2023 west2online. All rights reserved.
//

import AppKit

@available(macOS 10.15, *)
class ConnectionTopListView: NSView {
    let viewModel:ConnectionTopListViewModel

    private let tableView: NSTableView = {
        let table = NSTableView()
        table.allowsColumnSelection = false
        return table
    }()

    init(viewModel:ConnectionTopListViewModel) {
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

        for columnType in ConnectionColume.allCases {
            let column = NSTableColumn(identifier: NSUserInterfaceItemIdentifier(rawValue: columnType.rawValue))
            column.title = columnType.columeTitle
            column.minWidth = columnType.minWidth
            column.maxWidth = columnType.maxWidth
            tableView.addTableColumn(column)
        }

        tableView.usesAlternatingRowBackgroundColors = true
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
extension ConnectionTopListView: NSTableViewDelegate {
    func tableViewSelectionDidChange(_ notification: Notification) {
        viewModel.setSelect(row: tableView.selectedRow)
    }

    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 28
    }
}

@available(macOS 10.15, *)
extension ConnectionTopListView: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return viewModel.connections.count
    }

    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard let tableColumn, let type = ConnectionColume(rawValue: tableColumn.identifier.rawValue) else { return nil }
        var view = tableView.makeView(withIdentifier: tableColumn.identifier, owner: self) as? ConnectionCellProtocol
        if view == nil {
            switch type {
            case .process:
                view = ConnectionProxyClientCellView()
            case .statusIcon:
                view = ConnectionStatusIconCellView()
            default:
                view = ConnectionTextCellView()
            }
            view?.identifier = tableColumn.identifier
        }
        let c = viewModel.connections[row]
        view?.setup(with: c, type: type)
        return view
    }
}
