//
//  MemoryInspector.swift
//  AsyncBluetoothKit
//
//  Created by Heecheon Park on 7/29/23.
//

import Foundation

struct MemoryAddress<T>: CustomStringConvertible {

    let intValue: Int
    let hexValue: String

    var description: String {
        let length = 2 + 2 * MemoryLayout<UnsafeRawPointer>.size
        return String(format: "%0\(length)p", intValue)
    }

    // for structures
    init(of structPointer: UnsafePointer<T>) {
        intValue = Int(bitPattern: structPointer)
        let strHexValue = String(format: "%llx", intValue)
        var tmpHexValue = ""
        tmpHexValue = strHexValue
        repeat {
            tmpHexValue = "0\(tmpHexValue)"
        } while (tmpHexValue.count < 16)
        tmpHexValue = "0x\(tmpHexValue)"
        hexValue = tmpHexValue
    }
}

extension MemoryAddress where T: AnyObject {

    // for classes
    init(of classInstance: T) {
        intValue = unsafeBitCast(classInstance, to: Int.self)
        // or      Int(bitPattern: Unmanaged<T>.passUnretained(classInstance).toOpaque())
        let strHexValue = String(format: "%llx", intValue)
        var tmpHexValue = ""
        tmpHexValue = strHexValue
        repeat {
            tmpHexValue = "0\(tmpHexValue)"
        } while (tmpHexValue.count < 16)
        tmpHexValue = "0x\(tmpHexValue)"
        hexValue = tmpHexValue
    }
}
