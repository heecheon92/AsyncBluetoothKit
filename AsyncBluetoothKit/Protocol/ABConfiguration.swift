//
//  ABConfiguration.swift
//  AsyncBluetoothKit
//
//  Created by Heecheon Park on 7/30/23.
//

import Foundation
import CoreBluetooth

public protocol ABConfiguration {
    var options: [String:Any] { get }
}

public struct ABCentralConfiguration: Sendable, ABConfiguration {
    
    public let restoreIdentifier: String?
    public var showDisableAlert: Bool = false
    public var options: [String : Any] {
        var config: [String:Any] = [:]
        if let restoreIdentifier {
            config.updateValue(restoreIdentifier, forKey: CBCentralManagerOptionRestoreIdentifierKey)
        }
        config.updateValue(showDisableAlert, forKey: CBCentralManagerOptionShowPowerAlertKey)
        return config
    }
    
    public init(restoreIdentifier: String?, showDisableAlert: Bool) {
        self.restoreIdentifier = restoreIdentifier
        self.showDisableAlert = showDisableAlert
    }
}

public struct ABScanConfiguration: Sendable, ABConfiguration {
    public let allowDuplicateKeys: Bool
    
    /// Typically the Bluetooth peripheral advertises services and the central scans for those services. This is the case covered by the first parameter.
    /// In some cases, however, the behaviour is reversed - the central offers the service and the peripheral looks for it. This is called service solicitation.
    /// When you supply an array of service identifiers using CBCentralManagerScanOptionSolicitedServiceUUIDsKey you are providing the list of services that the central will 'advertise' to peripherals.
    /// It is still the responsibility of the central to initiate the connection, so once a peripheral is identified that is soliciting for one of those services,
    /// you will receive a call to the didDiscoverPeripheral method as per usual.
    /// https://stackoverflow.com/questions/31062176/scanforperipheralswithservicesoptions-and-cbcentralmanagerscanoptionsoliciteds
    public var solicitedServiceUUIDsKey: [String]
    
    public var options: [String : Any] {
        var config: [String:Any] = [:]
        config.updateValue(allowDuplicateKeys, forKey: CBCentralManagerScanOptionAllowDuplicatesKey)
        config.updateValue(solicitedServiceUUIDsKey, forKey: CBCentralManagerScanOptionSolicitedServiceUUIDsKey)
        return config
    }
    
    public init(allowDuplicateKeys: Bool = false, solicitedServiceUUIDsKey: [String] = []) {
        self.allowDuplicateKeys = allowDuplicateKeys
        self.solicitedServiceUUIDsKey = solicitedServiceUUIDsKey
    }
}
