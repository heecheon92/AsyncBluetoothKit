//
//  CentralStateTestView.swift
//  AsyncBluetoothKitTest
//
//  Created by Heecheon Park on 7/27/23.
//

import SwiftUI
import AsyncBluetoothKit

struct CentralStateTestView: View {
    
    /*
     Wrapping class object into @ObservedObject implicitly makes the object
     conforms to MainActor, hence, may break fetching data from async stream
     within task modifier.
     */
    let ble: ABCentralManager
    @State private var bleState: ABCentralState = .unknown
    
    var body: some View {
        VStack {
            Text("BLE State: \(bleState.stringDescription)")
        }
        .padding()
        ._task {
            // 왜 poweredOn 에만 iteration이 돌아가는지 파악중....이해가 안되네...
            // ABCentralManager 안에서도 subscribe 하고 로깅중인데
            // ABCentralManager 안에서는 정상동작 함...
            for await new in ble.stateStream {
                TestLog("\(new.stringDescription)")
                bleState = new
            }
        }
    }
}
