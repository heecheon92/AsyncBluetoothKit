//
//  CentralScanTestView.swift
//  AsyncBluetoothKitTest
//
//  Created by Heecheon Park on 9/2/23.
//

import SwiftUI
import AsyncBluetoothKit

struct CentralScanTestView: View {
    
    @ObservedObject var bleService = CentralService.shared
    
    var body: some View {
        List(Array(zip(bleService.scanResult.indices, bleService.scanResult)), id: \.0) { idx, result in
            Text("\(generateDescription(result))")
        }
        .navigationTitle("Scan Test")
        .ignoresSafeArea()
        .padding()
        .onAppear {
            bleService.startScan()
        }
        .onDisappear {
            bleService.stopScan()
        }
    }
    
    func generateDescription(_ scanRes: ABScanResult) -> String {
        return "\(String(describing: scanRes.localName as? String ?? "Anonymous")) \(scanRes.rssi) \(String(describing: scanRes.serviceUUIDs))"
    }
}
