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
    public var showAvailabilityAlert: Bool?
    public var options: [String : Any] {
        var config: [String:Any] = [:]
        if let restoreIdentifier {
            config.updateValue(restoreIdentifier, forKey: CBCentralManagerOptionRestoreIdentifierKey)
        }
        if let showAvailabilityAlert {
            config.updateValue(showAvailabilityAlert, forKey: CBCentralManagerOptionShowPowerAlertKey)
        }
        return config
    }
    
    public init(restoreIdentifier: String?, showAvailabilityAlert: Bool?) {
        self.restoreIdentifier = restoreIdentifier
        self.showAvailabilityAlert = showAvailabilityAlert
    }
}

public struct ABScanConfiguration: Sendable, ABConfiguration {
    public let allowDuplicateDiscoveries: Bool
    
    /// Typically the Bluetooth peripheral advertises services and the central scans for those services. This is the case covered by the first parameter.
    /// In some cases, however, the behaviour is reversed - the central offers the service and the peripheral looks for it. This is called service solicitation.
    /// When you supply an array of service identifiers using CBCentralManagerScanOptionSolicitedServiceUUIDsKey you are providing the list of services that the central will 'advertise' to peripherals.
    /// It is still the responsibility of the central to initiate the connection, so once a peripheral is identified that is soliciting for one of those services,
    /// you will receive a call to the didDiscoverPeripheral method as per usual.
    /// https://stackoverflow.com/questions/31062176/scanforperipheralswithservicesoptions-and-cbcentralmanagerscanoptionsoliciteds
    public var solicitedServiceUUIDs: [String]
    
    public var options: [String: Any] {
        var config: [String: Any] = [:]
        config.updateValue(allowDuplicateDiscoveries, forKey: CBCentralManagerScanOptionAllowDuplicatesKey)
        config.updateValue(solicitedServiceUUIDs, forKey: CBCentralManagerScanOptionSolicitedServiceUUIDsKey)
        return config
    }
    
    public init(allowDuplicateKeys: Bool = false, solicitedServiceUUIDsKey: [String] = []) {
        self.allowDuplicateDiscoveries = allowDuplicateKeys
        self.solicitedServiceUUIDs = solicitedServiceUUIDsKey
    }
}

public struct ABConnectionConfiguration: Sendable, ABConfiguration {
    
    public let notifyOnConnect: Bool?
    public let notifyOnDisconnect: Bool?
    public let notifyOnPeripheralNotification: Bool?
    public let enableTransportBridging: Bool?
    public let requireANCS: Bool?
    public let connectionDelay: NSNumber?
    
    public var options: [String: Any] {
        var config: [String: Any] = [:]
        if let notifyOnConnect {
            config.updateValue(notifyOnConnect ? 1 : 0, forKey: CBConnectPeripheralOptionNotifyOnConnectionKey)
        }
        if let notifyOnDisconnect {
            config.updateValue(notifyOnDisconnect ? 1 : 0, forKey: CBConnectPeripheralOptionNotifyOnDisconnectionKey)
        }
        if let notifyOnPeripheralNotification {
            config.updateValue(notifyOnPeripheralNotification ? 1 : 0, forKey: CBConnectPeripheralOptionNotifyOnNotificationKey)
        }
        if let enableTransportBridging {
            config.updateValue(enableTransportBridging ? 1 : 0, forKey: CBConnectPeripheralOptionEnableTransportBridgingKey)
        }
        if let requireANCS {
            config.updateValue(requireANCS ? 1 : 0, forKey: CBConnectPeripheralOptionRequiresANCS)
        }
        if let connectionDelay {
            config.updateValue(connectionDelay, forKey: CBConnectPeripheralOptionStartDelayKey)
        }
        return config
    }
    
    public init(notifyOnConnect: Bool? = nil,
                notifyOnDisconnect: Bool? = nil,
                notifyOnPeripheralNotification: Bool? = nil,
                enableTransportBridging: Bool? = nil,
                requireANCS: Bool? = nil,
                connectionDelay: NSNumber? = nil) {
        self.notifyOnConnect = notifyOnConnect
        self.notifyOnDisconnect = notifyOnDisconnect
        self.notifyOnPeripheralNotification = notifyOnPeripheralNotification
        self.enableTransportBridging = enableTransportBridging
        self.requireANCS = requireANCS
        self.connectionDelay = connectionDelay
    }
}
