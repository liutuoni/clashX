//
//  ConnectionLeftPannelViewModel.swift
//  ClashX
//
//  Created by miniLV on 2023-07-10.
//  Copyright © 2023 west2online. All rights reserved.
//

import Combine

@available(macOS 10.15, *)
class ConnectionLeftPannelViewModel {
    private(set) var connections = [ConnectionApplication]()
    var onReloadTable:(() -> Void)?
    var onSelectedConnection:((ConnectionApplication) -> Void)?

    func accept(connections new: [ConnectionApplication]) {
        connections = new
        onReloadTable?()
    }

    func setSelect(row: Int) {
        let selectedConn = connections[row]
        onSelectedConnection?(selectedConn)
    }

}
