//
//  CentralService.swift
//  AsyncBluetoothKitTest
//
//  Created by Heecheon Park on 9/2/23.
//

import Foundation
import SwiftUI
import AsyncBluetoothKit

@MainActor final class CentralService: ObservableObject {
    
    private var centralStateTask: Task<Void, Never>?
    @Published var centralState: ABCentralState = .unknown
    private init() {
        self.subscribeStateStream()
    }
    
    public static let shared = CentralService()
    
    private let manager = ABCentralManager()
    
    private func subscribeStateStream() {
        self.centralStateTask = Task { [unowned self] in
            for await newState in manager.stateStream {
                self.centralState = newState
            }
        }
    }
}
