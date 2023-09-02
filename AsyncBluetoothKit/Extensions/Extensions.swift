//
//  Extensions.swift
//  AsyncBluetoothKit
//
//  Created by Heecheon Park on 9/2/23.
//

import Foundation

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
