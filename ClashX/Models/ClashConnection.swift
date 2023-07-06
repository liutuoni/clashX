//
//  ClashConnection.swift
//  ClashX
//
//  Created by yicheng on 2019/10/28.
//  Copyright © 2019 west2online. All rights reserved.
//

import Cocoa

struct ClashConnectionBaseSnapShot: Codable {
    let connections: [Connection]
}

extension ClashConnectionBaseSnapShot {
    struct Connection: Codable {
        let id: String
        let chains: [String]
    }
}

@available(macOS 10.15, *)
class ClashConnectionSnapShot: Decodable {
    let connections: [Connection]
    let downloadTotal:Int
    let uploadTotal:Int
}

@available(macOS 10.15, *)
extension ClashConnectionSnapShot {
    class Connection: Decodable {
        let id: String
        let chains: [String]
        let metadata:MetaData
        @Published var upload:Int
        @Published var download:Int
        let start:String
        let rule:String
        let rulePayload:String

        @Published var done = false
        @Published var uploadSpeed = 0
        @Published var downloadSpeed = 0

        enum CodingKeys: CodingKey {
            case id
            case chains
            case metadata
            case upload
            case download
            case start
            case rule
            case rulePayload
        }

        required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            id = try container.decode(String.self, forKey: .id)
            chains = try container.decode([String].self, forKey: .chains)
            metadata = try container.decode(MetaData.self, forKey: .metadata)
            upload = try container.decode(Int.self, forKey: .upload)
            download = try container.decode(Int.self, forKey: .download)
            start = try container.decode(String.self, forKey: .start)
            rule = try container.decode(String.self, forKey: .rule)
            rulePayload = try container.decode(String.self, forKey: .rulePayload)
        }
    }
//    {"network":"tcp","type":"HTTP Connect","sourceIP":"127.0.0.1","destinationIP":"124.72.132.104","sourcePort":"59217","destinationPort":"443","host":"slardar-bd.feishu.cn","dnsMode":"normal","processPath":"","specialProxy":""}
    class MetaData: Codable {
        let network:String
        let type:String
        let sourceIP: String
        let destinationIP:String
        let sourcePort:String
        let destinationPort:String
        let host:String
        let dnsMode:String
        let specialProxy:String?
        var processPath:String

        var pid:String?
        var processImage:NSImage?

        lazy var processName:String = {
            return URL(string: processPath)?.lastPathComponent ?? ""
        }()

        enum CodingKeys: CodingKey {
            case network
            case type
            case sourceIP
            case destinationIP
            case host
            case dnsMode
            case specialProxy
            case processPath
            case sourcePort
            case destinationPort
        }
    }
}
