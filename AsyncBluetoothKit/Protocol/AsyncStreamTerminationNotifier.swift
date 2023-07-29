//
//  AsyncStreamTerminationNotifier.swift
//  AsyncBluetoothKit
//
//  Created by Heecheon Park on 7/29/23.
//

import Foundation

protocol AsyncStreamTerminationNotifier {
    associatedtype Element
    var onTermination: ((UUID, AsyncStream<Element>.Continuation.Termination) -> Void)? { get }
}
