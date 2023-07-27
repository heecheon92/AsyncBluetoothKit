//
//  CentralStateTestView.swift
//  AsyncBluetoothKitTest
//
//  Created by Heecheon Park on 7/27/23.
//

import SwiftUI
import AsyncBluetoothKit

struct CentralStateTestView: View {
    
    @ObservedObject var ble: ABCentralManager
    @State private var bleState: ABCentralState = .unknown
    
    var body: some View {
        VStack {
            Text("BLE State: \(bleState.stringDescription)")
        }
        .padding()
        .onAppear {
            Task {
                for await new in ble.stateStream {
                    bleState = new
                }
            }
        }
        // Not sure why the "bleState = new" is invalid....
//        ._task {
//            for await new in await ble.stateStream {
//                bleState = new
//            }
//        }
    }
}
