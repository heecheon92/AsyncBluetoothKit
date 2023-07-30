//
//  ABLazyComponent.swift
//  AsyncBluetoothKit
//
//  Created by Heecheon Park on 7/30/23.
//

import Foundation

// Conform to this protocol if any of the struct or class
// that has at least one mutating lazy property.
protocol ABLazyComponent {
    
    // return an object with all the lazy properties initialized
    func loadProperties() -> Self
}
