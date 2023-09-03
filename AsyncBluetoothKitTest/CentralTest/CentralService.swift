//
//  CentralService.swift
//  AsyncBluetoothKitTest
//
//  Created by Heecheon Park on 9/2/23.
//

import Foundation
import SwiftUI
import AsyncBluetoothKit
import CoreBluetooth

@MainActor final class CentralService: ObservableObject {
    
    private var centralStateTask: Task<Void, Never>?
    private var scanTask: Task<Void, Never>? = nil
    @Published var centralState: ABCentralState = .unknown
    @Published var scanResult: [ABScanResult] = []
    private init() {
        self.subscribeStateStream()
    }
    
    public static let shared = CentralService()
    
    private let manager = ABCentralManager()
    
    private func subscribeStateStream() {
        self.centralStateTask = Task { [unowned self] in
            for await newState in manager.stateStream {
                self.centralState = newState
            }
        }
    }
}

extension CentralService {
    func startScan() {
        self.scanTask = Task {
            for await res in manager.scanForPeripherals(services: []) {
                self.scanResult.append(res)
                if let name = res.localName as? String {
                    TestLog("\(name) \(String(describing: res.serviceUUIDs)) \(String(describing: res.serviceData))")
                }
            }
        }
    }
    
    func stopScan() {
        self.manager.stopScan()
        self.scanTask?.cancel()
        self.scanTask = nil
        self.scanResult.removeAll()
    }
    
    func connect(_ r: ABScanResult) async throws -> CBPeripheral {
        return try await self.manager.connect(peripheral: r.peripheral)
    }
}
