//
//  ArrayProtocol.swift
//  SwiftMapper
//
//  Created by Yevhen Strohanov on 1/4/17.
//  Copyright © 2017 JackTech. All rights reserved.
//

import Foundation

protocol ArrayProtocol: TypeWrapper {
}

extension Array : ArrayProtocol {
    public static func wrappedType() -> Any.Type {
        return Element.self
    }
}
