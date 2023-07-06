//
//  ColumeType.swift
//  ClashX
//
//  Created by yicheng on 2023/7/6.
//  Copyright © 2023 west2online. All rights reserved.
//

@available(macOS 10.15, *)
enum ConnectionColume:String, CaseIterable {
    case statusIcon
    case process
    case status
    case url
    case rule
    case date
    case upload
    case download
    case currentUpload
    case currentDownload
    case type

    var columeTitle:String {
        switch self {
        case .statusIcon: return ""
        case .process: return NSLocalizedString("Client", comment: "")
        case .status: return NSLocalizedString("Status", comment: "")
        case .rule: return NSLocalizedString("Rule", comment: "")
        case .url: return NSLocalizedString("URL", comment: "")
        case .date: return NSLocalizedString("Date", comment: "")
        case .upload: return NSLocalizedString("Upload", comment: "")
        case .download: return NSLocalizedString("Download", comment: "")
        case .currentUpload: return NSLocalizedString("Upload speed", comment: "")
        case .currentDownload: return NSLocalizedString("Download speed", comment: "")
        case .type: return NSLocalizedString("Type", comment: "")
        }
    }

    var minWidth:CGFloat {
        switch self {
        case .statusIcon: return 16
        case .status: return 30
        default:return 60
        }
    }

    var maxWidth:CGFloat {
        switch self {
        case .statusIcon: return 16
        default:return CGFloat.greatestFiniteMagnitude
        }
    }

}
