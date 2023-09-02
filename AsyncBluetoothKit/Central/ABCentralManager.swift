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
    public var isScanning: Bool { proxy.isScanning }
    public var stateStream: AsyncStream<ABCentralState> { proxy.stateStream }
    public var scanStream: AsyncStream<ABScanResult> { proxy.scanStream }
    
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

extension ABCentralManager {
    public func scanForPeripherals(services: [String],
                                   configuration: ABScanConfiguration = ABScanConfiguration()) -> AsyncStream<ABScanResult> {
        defer {
            self.proxy.scanForPeripherals(services: services,
                                          configuration: configuration)
        }
        return self.scanStream
    }
    public func scanForPeripherals(services: [CBUUID]? = nil,
                                   configuration: ABScanConfiguration = ABScanConfiguration()) -> AsyncStream<ABScanResult> {
        defer {
            self.proxy.scanForPeripherals(services: services,
                                          configuration: configuration)
        }
        return self.scanStream
    }
    public func stopScan() {
        self.proxy.stopScan()
    }
}
