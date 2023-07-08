//
//  ConnectionTopListViewModel.swift
//  ClashX
//
//  Created by yicheng on 2023/7/8.
//  Copyright © 2023 west2online. All rights reserved.
//

import Combine

@available(macOS 10.15, *)
class ConnectionTopListViewModel {
    private(set) var connections = [ClashConnectionSnapShot.Connection]()
    var onReloadTable:(() -> Void)?
    var onSelectedConnection:((ClashConnectionSnapShot.Connection) -> Void)?

    func accept(connections new: [ClashConnectionSnapShot.Connection]) {
        connections = new
        onReloadTable?()
    }

    func setSelect(row: Int) {
        let selectedConn = connections[row]
        onSelectedConnection?(selectedConn)
    }

}
