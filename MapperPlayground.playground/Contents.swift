//: Playground - noun: a place where people can play

import Foundation
import UIKit
import SwiftMapper


class ClassA: NSObject, Mappable {
    var superAwesome: Int = 0
    var superName: String?
    var lol: Bool = false
    
    //    var testClass: ClassA?
}

class MyClass: ClassA {
    var name = "Sansa Stark"
    var awesome = true
    var userB = ClassB()
}

class ClassB: NSObject, Mappable {
    var superAwesome: String?
    var test: Int = 0
}

let jsonDictionary: Dictionary<String, Any> = ["superAwesome": "11.34"]

let some = MyClass(fromJson: jsonDictionary)
some.superAwesome
some.superName
some.name
some.awesome
some.userB.superAwesome
