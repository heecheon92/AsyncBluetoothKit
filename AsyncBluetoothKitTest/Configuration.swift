//
//  Configuration.swift
//  AsyncBluetoothKitTest
//
//  Created by Heecheon Park on 7/27/23.
//

import Foundation
import SwiftUI
import AsyncBluetoothKit

/**
 * ABCentralManager is inheriting ObservableObject only to be wrapped by StateObject property wrapper.
 *  The reason to wrap ABCentralManager is ensure that the object is initialized once even when
 *  a view that refers to the manager objects invalidates and re-renders.
 *
 *  ABCentralManager do not publish any changes in internal properties as none of its properties are
 *  marked with "@Published"
 */

extension ABCentralManager: ObservableObject {}
