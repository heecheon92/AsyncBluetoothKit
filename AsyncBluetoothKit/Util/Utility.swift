//
//  Utility.swift
//  AsyncBluetoothKit
//
//  Created by Heecheon Park on 7/27/23.
//

import Foundation

fileprivate let loggerDateFormatter = _DateFormatter(dateFormat: "yyyy-MM-dd HH:mm:ss")

public func TestLog(fileFullPath: String = #file, fc: String = #function, line: Int = #line, _ arg: Any) {
#if DEBUG
    let filename = fileFullPath.components(separatedBy: "/").last ?? "UnknownFile"
    print("[\(filename).\(fc):\(line) \(loggerDateFormatter.getDateString(date: Date()))] \(String(describing: arg))")
#endif
}

struct _DateFormatter {
    
    private let dateFormatter: DateFormatter
    init(dateFormat: String) {
        self.dateFormatter = DateFormatter()
        self.dateFormatter.dateFormat = dateFormat
    }
    
    func getDateString(date: Date, timeZone: TimeZone? = nil) -> String {
        if let timeZone {
            dateFormatter.timeZone = timeZone
        } else {
            dateFormatter.timeZone = .autoupdatingCurrent
        }
        let stringDate = dateFormatter.string(from: date)
        return stringDate
    }
}
