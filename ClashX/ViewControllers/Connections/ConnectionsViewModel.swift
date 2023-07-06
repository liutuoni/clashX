//
//  ConnectionsViewModel.swift
//  ClashX
//
//  Created by yicheng on 2023/7/5.
//  Copyright © 2023 west2online. All rights reserved.
//

import Foundation
import Starscream
import Combine

struct ConnectionApplication {
    let pid: String
    let image:NSImage?
    let name:String?
    let path:String?
}

@available(macOS 10.15, *)
class ConnectionsViewModel {
    @Published var applicationMap = [String: ConnectionApplication]()
    @Published var connections = [String:ClashConnectionSnapShot.Connection]()

    private let req = ConnectionsReq()
    init() {
        req.connect()
        req.onSnapshotUpdate = {
            [weak self] snap in
            self?.update(snapShot: snap)
        }
    }

    func update(snapShot:ClashConnectionSnapShot) {
        let keys = Set(snapShot.connections.map { $0.id })
        for key in connections.keys where !keys.contains(key) {
            connections[key]?.done = true
            connections[key]?.uploadSpeed = 0
            connections[key]?.downloadSpeed = 0
        }

        var processMap:[String:String]?
        for conn in snapShot.connections {
            if let oldConn = connections[conn.id] {
                oldConn.upload = conn.upload
                oldConn.download = conn.download
                oldConn.uploadSpeed = conn.upload - oldConn.upload
                oldConn.downloadSpeed = conn.download - oldConn.download
            } else {
                if processMap == nil {
                    processMap = getProcessList()
                }
                if let pid = processMap![conn.metadata.sourceIP.appending(conn.metadata.sourcePort)],
                   let info = getProgressInfo(pid: pid) {
                    conn.metadata.pid = pid
                    conn.metadata.processPath = info.path ?? ""
                    conn.metadata.processImage = info.image
                } else {
                    print("===> not found for pid", conn.metadata.host)
                }

                connections[conn.id] = conn

            }
        }

    }

    func getProcessList() -> [String:String] {
        let tableString:String = clash_getProggressInfo().toString().trimmingCharacters(in: .whitespacesAndNewlines)
        if tableString.count < 0 { return [:] }
        let processList = tableString.components(separatedBy: "\n")
        var map = [String:String]()
        for process in processList {
            let infos = process.components(separatedBy: " ")
            // fmt.Sprintf("%s %d %d\n", srcIP, srcPort, pid)
            let srcIp = infos[0]
            let srcPort = infos[1]
            let pid = infos[2]
            map[srcIp.appending(srcPort)] = pid
        }
        return map
    }

    func getProgressInfo(pid:String) -> ConnectionApplication? {
        if let info = applicationMap[pid] {
            return info
        }
        guard let pidValue = pid_t(pid) else { return nil }
        guard let application = NSRunningApplication(processIdentifier: pidValue)
        else { return nil }
        let info = ConnectionApplication(pid:pid,
                                         image: application.icon,
                                         name: application.localizedName,
                                         path: application.executableURL?.absoluteString)
        applicationMap[pid] = info
        return info
    }
}

@available(macOS 10.15, *)
class ConnectionsReq:WebSocketDelegate {
    let socket = WebSocket(url: URL(string: ConfigManager.apiUrl.appending("/connections"))!)
    let decoder = JSONDecoder()
    var onSnapshotUpdate:((ClashConnectionSnapShot) -> Void)?
    init() {
        for header in ApiRequest.authHeader() {
            socket.request.setValue(header.value, forHTTPHeaderField: header.name)
        }
        socket.delegate = self
    }

    func connect() {
        socket.connect()
    }

    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        if let data = text.data(using: .utf8) {
            do {
                let info = try decoder.decode(ClashConnectionSnapShot.self, from: data)
                onSnapshotUpdate?(info)
            } catch let err {
                Logger.log("decode fail: \(err)", level: .warning)
            }
        }
    }

    func websocketDidConnect(socket: Starscream.WebSocketClient) {
        Logger.log("websocketDidConnect")
    }

    func websocketDidDisconnect(socket: Starscream.WebSocketClient, error: Error?) {
        Logger.log("websocketDidDisconnect: \(String(describing: error))", level: .warning)

    }

    func websocketDidReceiveData(socket: Starscream.WebSocketClient, data: Data) {}
}
