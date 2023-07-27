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
}

struct CentralTestView: View {
    
    @StateObject var ble = ABCentralManager()
    
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
    }
    
    @ViewBuilder func NavigationCategoryLabel(_ cat: CentralTestCategory) -> some View {
        Button(action: { selection = cat }, label: {
            switch cat {
            case .state:
                Text("BLE Central 상태 테스트")
            }
        })
    }
    
    @ViewBuilder func NavigationCategoryDestination(_ cat: CentralTestCategory) -> some View {
        switch cat {
        case .state:
            CentralStateTestView(ble: ble)
        }
    }
}

struct CentralTestView_Previews: PreviewProvider {
    static var previews: some View {
        CentralTestView()
    }
}
