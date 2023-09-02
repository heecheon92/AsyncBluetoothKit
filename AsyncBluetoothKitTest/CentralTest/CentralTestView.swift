//
//  CentralTestView.swift
//  AsyncBluetoothKitTest
//
//  Created by Heecheon Park on 7/27/23.
//

import SwiftUI
import AsyncBluetoothKit

enum CentralTestCategory: CaseIterable, Identifiable {
    var id : UUID { UUID() }
    
    case state
    case scan
}

struct CentralTestView: View {
    
    @StateObject var bleService = CentralService.shared
    
    @State private var selection: CentralTestCategory? = nil
    @State private var isActive: Bool = false
    
    var body: some View {
        List(CentralTestCategory.allCases) { NavigationCategoryLabel($0) }
            .background(
                NavigationLink(isActive: $isActive, destination: {
                    if let selection { NavigationCategoryDestination(selection) }
                }, label: { EmptyView() })
            )
            .onChange(of: selection, perform: { sel in if let _ = sel { isActive = true } })
            .onChange(of: isActive, perform: { if !$0 { selection = nil } })
    }
    
    @ViewBuilder func NavigationCategoryLabel(_ cat: CentralTestCategory) -> some View {
        Button(action: { selection = cat }, label: {
            switch cat {
            case .state:
                Text("BLE Central State Test")
            case .scan:
                Text("BLE Central Scan Test")
            }
        })
    }
    
    @ViewBuilder func NavigationCategoryDestination(_ cat: CentralTestCategory) -> some View {
        switch cat {
        case .state:
            CentralStateTestView()
        case .scan:
            CentralScanTestView()
        }
    }
}

struct CentralTestView_Previews: PreviewProvider {
    static var previews: some View {
        CentralTestView()
    }
}
