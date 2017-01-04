//
//  TypeWrapper.swift
//  SwiftMapper
//
//  Created by Yevhen Strohanov on 1/4/17.
//  Copyright © 2017 JackTech. All rights reserved.
//

import Foundation

protocol TypeWrapper {
    static func wrappedType() -> Any.Type
}
