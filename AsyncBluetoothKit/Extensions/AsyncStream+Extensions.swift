//
//  AsyncStream+Extensions.swift
//  AsyncBluetoothKit
//
//  Created by Heecheon Park on 9/2/23.
//

import Foundation

public extension AsyncStream.Continuation.Termination {
    var stringDescription: String {
        switch self {
        case .finished:     return "finished"
        case .cancelled:    return "cancelled"
        @unknown default:   return "@unknown default"
        }
    }
}
