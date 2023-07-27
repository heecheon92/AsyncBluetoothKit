//
//  Modifier.swift
//  AsyncBluetoothKit
//
//  Created by Heecheon Park on 7/27/23.
//

import Foundation
import SwiftUI

struct TaskModifier<ID: Equatable>: ViewModifier {
    var id: ID
    var priority: TaskPriority
    var action: () async -> Void

    @State private var task: Task<Void, Never>?
    
    init(id: ID, priority: TaskPriority, action: @escaping @Sendable () async -> Void) {
        self.id = id
        self.priority = priority
        self.action = action
    }

    func body(content: Content) -> some View {
        content
            .onAppear {
                task = Task(priority: priority) {
                    await action()
                }
            }
            .onDisappear {
                task?.cancel()
                task = nil
            }
    }
}
