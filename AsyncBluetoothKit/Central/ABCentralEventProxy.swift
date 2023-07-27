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
    private var _stateStream: ABCentralStateStream
    public var stateStream: AsyncStream<ABCentralState> { _stateStream.stream }
    
    init(queue: DispatchQueue? = nil,
         configuration: ABCentralConfiguration = ABCentralConfiguration(restoreIdentifier: nil, showDisableAlert: false)) {
        
        var _config: [String:Any] = [:]
        if let rstId = configuration.restoreIdentifier {
            _config.updateValue(rstId, forKey: CBCentralManagerOptionRestoreIdentifierKey)
        }
        _config.updateValue(configuration.showDisableAlert, forKey: CBCentralManagerOptionShowPowerAlertKey)
        self._stateStream = ABCentralStateStream()
        self.manager = CBCentralManager(delegate: nil, queue: queue, options: _config)
        super.init()
        self.manager.delegate = self
    }
}

extension ABCentralEventProxy: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        TestLog("\(central.state.stringDescription)")
        _stateStream.continuation?.yield(central.state)
    }
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {}
    func centralManager(_ central: CBCentralManager, willRestoreState dict: [String : Any]) {}
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {}
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {}
    func centralManager(_ central: CBCentralManager, didUpdateANCSAuthorizationFor peripheral: CBPeripheral) {}
    func centralManager(_ central: CBCentralManager, connectionEventDidOccur event: CBConnectionEvent, for peripheral: CBPeripheral) {}
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {}
}

struct ABCentralStateStream {
    private(set) lazy var stream: AsyncStream<ABCentralState> = {
        AsyncStream(ABCentralState.self,
                    bufferingPolicy: .bufferingNewest(1)) { (continuation: AsyncStream<ABCentralState>.Continuation) in
           self.continuation = continuation
       }
    }()
    private(set) var continuation: AsyncStream<ABCentralState>.Continuation?
}
