//
//  ABCentralStateStream.swift
//  AsyncBluetoothKit
//
//  Created by Heecheon Park on 7/29/23.
//

import Foundation

struct ABCentralStateStream: Identifiable, ABAsyncStream {

    var id = UUID()
    private(set) lazy var stream: AsyncStream<ABCentralState> = {
        AsyncStream(ABCentralState.self,
                    bufferingPolicy: .bufferingNewest(1)) { (continuation: AsyncStream<ABCentralState>.Continuation) in
            
            TestLog("A state stream (\(id) has been created.")
            self.continuation = continuation
            self.continuation?.onTermination = { [this = self] termination in
                // Capture "self" as immutable "this" to bypass the following error.
                // Mutable capture of 'inout' parameter 'state' is not allowed in concurrently-executing code
                TestLog("A state stream (\(this.id) has been terminated. Reason: \(termination.stringDescription)")
                this.onTermination?(this.id, termination)
            }
        }
    }()
    private(set) var continuation: AsyncStream<ABCentralState>.Continuation? = nil
    
    init() {
        self.onTermination = nil
        self.continuation = nil
    }
    
    init(_ onTermination: @escaping (UUID, AsyncStream<ABCentralState>.Continuation.Termination) -> Void) {
        self.onTermination = onTermination
    }
    
    private(set) var onTermination: ((UUID, AsyncStream<ABCentralState>.Continuation.Termination) -> Void)?
    
    func loadProperties() -> ABCentralStateStream {
        var res = self
        _ = res.stream  // load the lazy stream thereby setting the continuation property.
        return res
    }
}
