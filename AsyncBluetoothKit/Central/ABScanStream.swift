//
//  ABScanStream.swift
//  AsyncBluetoothKit
//
//  Created by Heecheon Park on 9/2/23.
//

import Foundation
import CoreBluetooth

struct ABScanStream: Identifiable, ABAsyncStream {

    var id = UUID()
    private(set) lazy var stream: AsyncStream<ABScanResult> = {
        AsyncStream(ABScanResult.self,
                    bufferingPolicy: .bufferingNewest(1)) { (continuation: AsyncStream<ABScanResult>.Continuation) in
            
            TestLog("A scan stream (\(id) has been created.")
            self.continuation = continuation
            self.continuation?.onTermination = { [this = self] termination in
                TestLog("A scan stream (\(this.id) has been terminated. Reason: \(termination.stringDescription)")
                this.onTermination?(this.id, termination)
            }
        }
    }()
    private(set) var continuation: AsyncStream<ABScanResult>.Continuation? = nil
    
    init() {
        self.onTermination = nil
        self.continuation = nil
    }
    
    init(_ onTermination: @escaping (UUID, AsyncStream<ABScanResult>.Continuation.Termination) -> Void) {
        self.onTermination = onTermination
    }
    
    private(set) var onTermination: ((UUID, AsyncStream<ABScanResult>.Continuation.Termination) -> Void)?
    
    func loadProperties() -> ABScanStream {
        var res = self
        _ = res.stream
        return res
    }
}
