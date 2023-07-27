//
//  View+Extensions.swift
//  AsyncBluetoothKit
//
//  Created by Heecheon Park on 7/27/23.
//

import SwiftUI

extension View {
    @ViewBuilder
    public func _task(priority: TaskPriority = .userInitiated,
              action: @escaping @Sendable () async -> Void) -> some View {
        if #available(iOS 15.0, *) {
            task(priority: priority, action)
        } else {
            modifier(TaskModifier(id: 0, priority: priority, action: action))
        }
    }

    @ViewBuilder
    public func _task<T: Equatable>(id: T,
                            priority: TaskPriority = .userInitiated,
                            _ action: @escaping @Sendable () async -> Void) -> some View {
        modifier(
            TaskModifier(
                id: id,
                priority: priority,
                action: action
            )
        )
    }
}

