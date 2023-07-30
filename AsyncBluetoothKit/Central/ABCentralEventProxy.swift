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
    public var stateStream: AsyncStream<ABCentralState> {
        var stream = ABCentralStateStream { [weak self] id, terminationReason in
            TestLog("A state stream (\(id) has been terminated. Reason: \(terminationReason.stringDescription)")
            self?.cancellableStreams[id] = nil
        }
        cancellableStreams.updateValue(stream, forKey: stream.id)
        
        // var stream and cancellableStreams[stream.id] are SEPARATE objects.
        // Accessing lazy property of stream.stream does not lazily initialize
        // the lazy property of cancellableStreams[stream.id]!.stream
        return cancellableStreams[stream.id]!.stream
    }
    
    private var cancellableStreams: Dictionary<UUID, ABCentralStateStream> = [:]
    
    init(queue: DispatchQueue? = nil,
         configuration: ABCentralConfiguration = ABCentralConfiguration(restoreIdentifier: nil, showDisableAlert: false)) {
        
        self.manager = CBCentralManager(delegate: nil, queue: queue, options: configuration.options)
        super.init()
        self.manager.delegate = self
    }
}

extension ABCentralEventProxy: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        TestLog("\(central.state.stringDescription)")
        cancellableStreams.keys.forEach {
            if let cont = cancellableStreams[$0]?.continuation { cont.yield(central.state) }
            else {
                TestLog("cont is null")
                TestLog("\(String(describing: cancellableStreams[$0]?.stream))")
            }
        }
    }
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {}
    func centralManager(_ central: CBCentralManager, willRestoreState dict: [String : Any]) {}
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {}
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {}
    func centralManager(_ central: CBCentralManager, didUpdateANCSAuthorizationFor peripheral: CBPeripheral) {}
    func centralManager(_ central: CBCentralManager, connectionEventDidOccur event: CBConnectionEvent, for peripheral: CBPeripheral) {}
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {}
}


