//
//  ConnectionsViewController.swift
//  ClashX
//
//  Created by yicheng on 2023/7/5.
//  Copyright © 2023 west2online. All rights reserved.
//

import AppKit
import Combine

@available(macOS 10.15, *)
class ConnectionsViewController: NSViewController {
    let viewModel = ConnectionsViewModel()
    let leftTableView = ConnectionsLeftPannelView()
    let topView = ConnectionTopListView()
    let detailView = ConnectionDetailInfoView()

    var disposeBag = Set<AnyCancellable>()

    var leftWidthConstraint: NSLayoutConstraint?
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    override func viewWillAppear() {
        super.viewWillAppear()
        view.window?.toolbar = NSToolbar()
        view.window?.styleMask.insert(.closable)
        view.window?.styleMask.insert(.resizable)
        view.window?.styleMask.insert(.miniaturizable)
        if #available(macOS 11.0, *) {
            view.window?.toolbarStyle = .unifiedCompact
        } else {
            view.window?.toolbar?.sizeMode = .small
        }
    }

    override func loadView() {
        view = ConnectionsViewControllerBaseView(frame: NSRect(origin: .zero, size: CGSize(width: 900, height: 600)))
    }

    func setup() {
        title = NSLocalizedString("连接", comment: "")
        view.addSubview(leftTableView)
        view.makeConstraints {
            [$0.widthAnchor.constraint(greaterThanOrEqualToConstant: 900),
             $0.heightAnchor.constraint(greaterThanOrEqualToConstant: 600)]
        }

        leftWidthConstraint = leftTableView.widthAnchor.constraint(equalToConstant: 200)
        leftTableView.makeConstraints {
            [$0.leftAnchor.constraint(equalTo: view.leftAnchor),
             $0.topAnchor.constraint(equalTo: view.topAnchor),
             $0.bottomAnchor.constraint(equalTo: view.bottomAnchor),
             leftWidthConstraint!]
        }

        (view as! ConnectionsViewControllerBaseView).leftWidthConstraint = leftWidthConstraint

        view.addSubview(topView)
        topView.makeConstraints {
            [$0.leftAnchor.constraint(equalTo: leftTableView.rightAnchor),
             $0.topAnchor.constraint(equalTo: view.topAnchor),
             $0.rightAnchor.constraint(equalTo: view.rightAnchor)]
        }

        view.addSubview(detailView)
        detailView.makeConstraints {
            [$0.leftAnchor.constraint(equalTo: leftTableView.rightAnchor),
             $0.heightAnchor.constraint(equalToConstant: 200),
             $0.bottomAnchor.constraint(equalTo: view.bottomAnchor),
             $0.rightAnchor.constraint(equalTo: view.rightAnchor),
             $0.topAnchor.constraint(equalTo: topView.bottomAnchor)]
        }

        viewModel.$applicationMap.sink { app in
            print("===>", app.keys.count)
        }.store(in: &disposeBag)

        viewModel.$connections.sink { [weak self] conn  in
            guard let self else {return}
            self.topView.connections = Array(conn.values)
        }.store(in: &disposeBag)
    }
}

class ConnectionsViewControllerBaseView: NSView {
    var leftWidthConstraint:NSLayoutConstraint?
    enum DragType {
        case none
        case leftPannel
    }

    var dragType = DragType.none
    let dragSize:CGFloat = 5.0

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func hitTest(_ point: NSPoint) -> NSView? {
        if dragType == .none {
            return super.hitTest(point)
        }
        return self
    }
    override func updateTrackingAreas() {
        super.updateTrackingAreas()
        trackingAreas.forEach({ removeTrackingArea($0) })
        addTrackingArea(NSTrackingArea(rect: bounds,
                                       options: [.mouseMoved,
                                                 .mouseEnteredAndExited,
                                                 .activeAlways],
                                       owner: self))
    }

    override func mouseExited(with event: NSEvent) {
        NSCursor.arrow.set()
    }

    override func mouseDown(with event: NSEvent) {
        update(with: event)
    }

    override func mouseUp(with event: NSEvent) {
        dragType = .none
    }

    override func mouseMoved(with event: NSEvent) {
        update(with: event)
    }

    override func mouseDragged(with event: NSEvent) {
        switch dragType {
        case .none:
            break
        case .leftPannel:
            let deltaX = event.deltaX
            let target = (leftWidthConstraint?.constant ?? 0) + deltaX
            leftWidthConstraint?.constant = min(max(target, 200), 400)
        }
    }

    func update(with event: NSEvent) {
        let locationInView = convert(event.locationInWindow, from: nil)
        let currentLeftSize = leftWidthConstraint?.constant ?? 0
        if locationInView.x > currentLeftSize - dragSize && locationInView.x < currentLeftSize + dragSize {
            dragType = .leftPannel
            NSCursor.resizeLeftRight.set()
            return
        }
        dragType = .none
        NSCursor.arrow.set()
    }

}
