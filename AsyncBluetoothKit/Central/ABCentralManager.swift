//
//  ABCentralManager.swift
//  AsyncBluetoothKit
//
//  Created by Heecheon Park on 7/27/23.
//

import Foundation
import CoreBluetooth

public typealias ABCentralState = CBManagerState

public final class ABCentralManager: NSObject {
    
    private let proxy: ABCentralEventProxy
    private(set) var state: ABCentralState = .unknown
    public var stateStream: AsyncStream<ABCentralState> { proxy.stateStream }
    
    init(queue: DispatchQueue? = nil,
         configuration: ABCentralConfiguration = ABCentralConfiguration(restoreIdentifier: nil, showDisableAlert: false)) {
        
        self.proxy = ABCentralEventProxy(queue: queue, configuration: configuration)
        super.init()
        self.monitorCentralState()
    }
    
    private func monitorCentralState() {
        Task {
            for await newState in proxy.stateStream {
                state = newState
            }
        }
    }
}

public struct ABCentralConfiguration: @unchecked Sendable {
    let restoreIdentifier: String?
    var showDisableAlert: Bool = false
}
