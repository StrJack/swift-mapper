//
//  Simple.swift
//  SwiftMapper
//
//  Created by Yevhen Strohanov on 1/4/17.
//  Copyright © 2017 JackTech. All rights reserved.
//

import Foundation

protocol Simple {
    static func initWith(_ anyObj: Any) -> Simple?
}

extension String: Simple {
    static func initWith(_ anyObj: Any) -> Simple? {
        return String(describing: anyObj)
    }
}

extension Int: Simple {
    static func initWith(_ anyObj: Any) -> Simple? {
        if anyObj is _NSContiguousString {
            if let doubleVal = Double(anyObj as! String) {
                return Int.initWith(doubleVal)
            }
        } else if anyObj is Int {
            return Int(anyObj as! Int)
        } else if anyObj is Double {
            return Int(anyObj as! Double)
        }
        return nil
    }
}
