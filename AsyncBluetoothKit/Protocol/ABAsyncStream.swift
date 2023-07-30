//
//  AsyncStreamTerminationNotifier.swift
//  AsyncBluetoothKit
//
//  Created by Heecheon Park on 7/29/23.
//

import Foundation

protocol ABAsyncStream: ABLazyComponent {
    associatedtype Element
    typealias Stream = AsyncStream<Element>
    var onTermination: ((UUID, Stream.Continuation.Termination) -> Void)? { get }
    var stream: Stream { mutating get }
    var continuation: Stream.Continuation? { get }
}
