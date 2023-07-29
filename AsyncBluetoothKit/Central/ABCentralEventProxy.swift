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
        let stream = ABCentralStateStream { [weak self] id, terminationReason in
            TestLog("A state stream (\(id) has been terminated. Reason: \(terminationReason.stringDescription)")
            self?.cancellableStreams[id] = nil
        }
        cancellableStreams.updateValue(stream, forKey: stream.id)
        return stream.stream
    }
    
    private var cancellableStreams: Dictionary<UUID, ABCentralStateStream> = [:]
    
    init(queue: DispatchQueue? = nil,
         configuration: ABCentralConfiguration = ABCentralConfiguration(restoreIdentifier: nil, showDisableAlert: false)) {
        
        var _config: [String:Any] = [:]
        if let rstId = configuration.restoreIdentifier {
            _config.updateValue(rstId, forKey: CBCentralManagerOptionRestoreIdentifierKey)
        }
        _config.updateValue(configuration.showDisableAlert, forKey: CBCentralManagerOptionShowPowerAlertKey)
        self.manager = CBCentralManager(delegate: nil, queue: queue, options: _config)
        super.init()
        self.manager.delegate = self
    }
}

extension ABCentralEventProxy: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        TestLog("\(central.state.stringDescription)")
        cancellableStreams.keys.forEach {
            cancellableStreams[$0]?.continuation?.yield(central.state)
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


