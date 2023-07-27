//
//  ContentView.swift
//  AsyncBluetoothKitTest
//
//  Created by Heecheon Park on 7/27/23.
//

import SwiftUI
import AsyncBluetoothKit

struct ContentView: View {
    
    var body: some View {
        NavigationView {
            CentralTestView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
