//
//  ConnectionTextCellView.swift
//  ClashX
//
//  Created by yicheng on 2023/7/6.
//  Copyright © 2023 west2online. All rights reserved.
//

import AppKit
import Combine

@available(macOS 10.15, *)
class ConnectionTextCellView: NSView, ConnectionCellProtocol {
    let label = NSTextField(labelWithString: "")
    var cancellable = Set<AnyCancellable>()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    func setupUI() {
        addSubview(label)
        label.font = NSFont.systemFont(ofSize: 12)
        label.makeConstraints {
            [$0.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            $0.centerYAnchor.constraint(equalTo: centerYAnchor)]
        }
    }

    func setup(with connection:  ClashConnectionSnapShot.Connection, type: ConnectionColume) {
        cancellable.removeAll()
        switch type {
        case .upload:
            connection.$upload.map { SpeedUtils.getNetString(for: $0) }.weakAssign(to: \.stringValue, on: label).store(in: &cancellable)
        case .download:
            connection.$download.map { SpeedUtils.getNetString(for: $0) }.weakAssign(to: \.stringValue, on: label).store(in: &cancellable)
        case .currentUpload:
            connection.$uploadSpeed.map { SpeedUtils.getSpeedString(for: $0) }.weakAssign(to: \.stringValue, on: label).store(in: &cancellable)
        case .currentDownload:
            connection.$downloadSpeed.map { SpeedUtils.getSpeedString(for: $0) }.weakAssign(to: \.stringValue, on: label).store(in: &cancellable)
        case .status:
            connection.$done.map { $0 ? NSLocalizedString("In Progress", comment: "") : NSLocalizedString("Done", comment: "") }.weakAssign(to: \.stringValue, on: label).store(in: &cancellable)
        case .statusIcon, .process:
            return
        case .rule:
            label.stringValue = connection.chains.joined(separator: "/")
        case .date:
            label.stringValue = connection.start
        case .url:
            if connection.metadata.host.count > 0 {
                label.stringValue = connection.metadata.host
            } else {
                label.stringValue = connection.metadata.destinationIP
            }
        case .type:
            label.stringValue = connection.metadata.network
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        cancellable.removeAll()
        print("===> prepareForReuse")

    }
}
