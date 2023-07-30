//
//  ABCentralManager.swift
//  AsyncBluetoothKit
//
//  Created by Heecheon Park on 7/27/23.
//

import Foundation
import CoreBluetooth

public typealias ABCentralState = CBManagerState

public final class ABCentralManager: NSObject, @unchecked Sendable {
    
    private let proxy: ABCentralEventProxy
    public private(set) var state: ABCentralState = .unknown
    public var stateStream: AsyncStream<ABCentralState> { proxy.stateStream }
    
    override public convenience init() {
        self.init(queue: nil, configuration: ABCentralConfiguration(restoreIdentifier: nil, showDisableAlert: false))
    }
    
    public init(queue: DispatchQueue? = nil,
         configuration: ABCentralConfiguration = ABCentralConfiguration(restoreIdentifier: nil, showDisableAlert: false)) {
        
        self.proxy = ABCentralEventProxy(queue: queue, configuration: configuration)
        super.init()
        self.monitorCentralState()
    }
    
    private func monitorCentralState() {
        Task {
            for await newState in proxy.stateStream {
                TestLog("\(newState.stringDescription)")
                state = newState
            }
        }
    }
}

public extension ABCentralState {
    var stringDescription: String {
        switch self {
        case .unknown:      return "unknown"
        case .resetting:    return "resetting"
        case .unsupported:  return "unsupported"
        case .unauthorized: return "unauthorized"
        case .poweredOff:   return "poweredOff"
        case .poweredOn:    return "poweredOn"
        @unknown default:   return "@unknown default"
        }
    }
}

public extension AsyncStream.Continuation.Termination {
    var stringDescription: String {
        switch self {
        case .finished:     return "finished"
        case .cancelled:    return "cancelled"
        @unknown default:   return "@unknown default"
        }
    }
}
