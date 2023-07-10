//
//  ConnectionApplicationClientCellView.swift
//  ClashX
//
//  Created by miniLV on 2023-07-10.
//  Copyright © 2023 west2online. All rights reserved.
//

import AppKit

@available(macOS 10.15, *)
class ConnectionApplicationClientCellView: NSView, ConnectionApplicationCellProtocol {
    let imageView = NSImageView()
    let nameLabel = NSTextField(labelWithString: "")
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    func setupUI() {
        addSubview(nameLabel)
        addSubview(imageView)
        nameLabel.font = NSFont.systemFont(ofSize: 13)
        imageView.makeConstraints {
            [$0.heightAnchor.constraint(equalToConstant: 23),
             $0.widthAnchor.constraint(equalTo: $0.heightAnchor),
             $0.centerYAnchor.constraint(equalTo: centerYAnchor),
             $0.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 6)]
        }
        nameLabel.makeConstraints {
            [
             $0.centerYAnchor.constraint(equalTo: centerYAnchor),
             $0.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 5),
             $0.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor)
            ]
        }
        nameLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        nameLabel.cell?.truncatesLastVisibleLine = true
    }

    func setup(with connection: ConnectionApplication) {
        nameLabel.stringValue = connection.name ?? "Unknown"
        imageView.image = connection.image
    }
}
