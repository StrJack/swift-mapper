//
//  TestsClasses.swift
//  SwiftMapper
//
//  Created by Yevhen Strohanov on 1/4/17.
//  Copyright © 2017 JackTech. All rights reserved.
//

import Foundation
@testable import SwiftMapper

class Creature: NSObject, Mappable {
    var age: Int = 0
}

class Human: Creature {
    var firstName: String = ""
    var lastName: String?
    var currentAddress = Address()
    var previousAddress: Address?
    var merried: Bool = false
    
    var parents: [Human]?
    var friends: [Human]?
}

class Dog: Creature {
    var nickname: String?
    var species: String?
    
    var master: Human?
}

class Address: NSObject, Mappable {
    var buildingNumber: Int = -1
    var street: String?
    var city: String?
}
