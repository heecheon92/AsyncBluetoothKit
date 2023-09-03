//
//  ABScanResult.swift
//  AsyncBluetoothKit
//
//  Created by Heecheon Park on 9/2/23.
//

import Foundation
import CoreBluetooth

public struct ABScanResult: @unchecked Sendable {
    public let peripheral: CBPeripheral
    public let rssi: NSNumber
    public private(set) var advertisementData: [String: Any] = [:]
    
    public var localName: Any?          { advertisementData[CBAdvertisementDataLocalNameKey] }
    public var txPower: Any?            { advertisementData[CBAdvertisementDataTxPowerLevelKey] }
    public var serviceUUIDs: Any?       { advertisementData[CBAdvertisementDataServiceUUIDsKey] }
    public var serviceData: Any?        { advertisementData[CBAdvertisementDataServiceDataKey] }
    public var manufacturerData: Any?   { advertisementData[CBAdvertisementDataManufacturerDataKey] }
    public var timestamp: Any?          { advertisementData["kCBAdvDataTimestamp"] }
    public var rxPrimaryPHY: Any?       { advertisementData["kCBAdvDataRxPrimaryPHY"] }
    public var rxSecondaryPHY: Any?     { advertisementData["kCBAdvDataRxSecondaryPHY"] }
    
    public var overflowServiceUUIDs: Any? {
        if #available(iOS 6.0, *) {
            return advertisementData[CBAdvertisementDataOverflowServiceUUIDsKey]
        }
        return nil
    }
    public var isConnectable: Any? {
        if #available(iOS 7.0, *) {
            return advertisementData[CBAdvertisementDataIsConnectable]
        }
        return nil
    }
    public var solictedServiceUUIDs: Any? {
        if #available(iOS 7.0, *) {
            return advertisementData[CBAdvertisementDataSolicitedServiceUUIDsKey]
        }
        return nil
    }
}
