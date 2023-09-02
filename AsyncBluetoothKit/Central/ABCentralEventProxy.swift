//
//  ABCentralEventProxy.swift
//  AsyncBluetoothKit
//
//  Created by Heecheon Park on 7/27/23.
//

import Foundation
import CoreBluetooth

final class ABCentralEventProxy: NSObject, @unchecked Sendable {
    
    private let manager: CBCentralManager
    var isScanning: Bool { self.manager.isScanning }
    var stateStream: ABCentralStateStream.Stream {
        var stream = ABCentralStateStream { [weak self] id, _ in self?.stateStreams[id] = nil }.loadProperties()
        stateStreams.updateValue(stream, forKey: stream.id)
        return stream.stream
    }
    var scanStream: ABScanStream.Stream {
        var stream = ABScanStream { [weak self] id, _ in self?.scanStreams[id] = nil }.loadProperties()
        scanStreams.updateValue(stream, forKey: stream.id)
        return stream.stream
    }
    
    private var stateStreams: Dictionary<UUID, ABCentralStateStream> = [:]
    private var scanStreams: Dictionary<UUID, ABScanStream> = [:]
    
    init(queue: DispatchQueue? = nil,
         configuration: ABCentralConfiguration = ABCentralConfiguration(restoreIdentifier: nil, showDisableAlert: false)) {
        
        self.manager = CBCentralManager(delegate: nil, queue: queue, options: configuration.options)
        super.init()
        self.manager.delegate = self
    }
}

extension ABCentralEventProxy {
    func scanForPeripherals(services: [String] = [], configuration: ABScanConfiguration = ABScanConfiguration()) {
        self.manager.scanForPeripherals(withServices: services.isEmpty ? nil : services.compactMap({ CBUUID(string: $0) }),
                                        options: configuration.options)
    }
    func scanForPeripherals(services: [CBUUID]? = nil, configuration: ABScanConfiguration = ABScanConfiguration()) {
        self.manager.scanForPeripherals(withServices: services,
                                        options: configuration.options)
    }
    func stopScan() {
        self.manager.stopScan()
    }
}

extension ABCentralEventProxy: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        TestLog("\(central.state.stringDescription)")
        stateStreams.keys.forEach {
            if let cont = stateStreams[$0]?.continuation { cont.yield(central.state) }
            else {
                TestLog("cont is null: \(String(describing: stateStreams[$0]?.stream))")
            }
        }
    }
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {}
    func centralManager(_ central: CBCentralManager, willRestoreState dict: [String : Any]) {}
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {}
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {}
    func centralManager(_ central: CBCentralManager, didUpdateANCSAuthorizationFor peripheral: CBPeripheral) {}
    func centralManager(_ central: CBCentralManager, connectionEventDidOccur event: CBConnectionEvent, for peripheral: CBPeripheral) {}
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        scanStreams.keys.forEach {
            if let cont = scanStreams[$0]?.continuation { cont.yield(ABScanResult(peripheral: peripheral,
                                                                                  rssi: RSSI,
                                                                                  advertisementData: advertisementData)) }
            else {
                TestLog("cont is null: \(String(describing: scanStreams[$0]?.stream))")
            }
        }
    }
}
