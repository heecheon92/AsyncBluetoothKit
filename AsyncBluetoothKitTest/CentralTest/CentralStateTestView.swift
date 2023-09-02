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
    @ObservedObject var bleService = CentralService.shared
    
    var body: some View {
        VStack {
            Text("BLE State: \(bleService.centralState.stringDescription)")
        }
        .padding()
    }
}
