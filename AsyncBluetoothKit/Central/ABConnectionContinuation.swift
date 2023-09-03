//
//  ABConnectionContinuation.swift
//  AsyncBluetoothKit
//
//  Created by Heecheon Park on 9/3/23.
//

import Foundation
import CoreBluetooth

struct ABConnectionContinuation {
    let id: UUID
    var continuation: CheckedContinuation<CBPeripheral, Error>?
    
    init(id: UUID, _ continuation: CheckedContinuation<CBPeripheral, Error>) {
        self.id = id
        self.continuation = continuation
    }
}

extension ABConnectionContinuation: Hashable, Equatable {
    func hash(into hasher: inout Hasher) {
      id.hash(into: &hasher)
    }
    
    static func == (lhs: ABConnectionContinuation, rhs: ABConnectionContinuation) -> Bool {
        return lhs.id == rhs.id
    }
}
