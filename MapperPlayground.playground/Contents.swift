//: Playground - noun: a place where people can play

import Foundation
import UIKit

protocol TypeWrapper {
    static func wrappedType() -> Any.Type
}

protocol OptionalProtocol: TypeWrapper {
}

extension Optional : OptionalProtocol {
    static func wrappedType() -> Any.Type {
        return Wrapped.self
    }
}

protocol ArrayProtocol: TypeWrapper {
}

extension Array : ArrayProtocol {
    static func wrappedType() -> Any.Type {
        return Element.self
    }
}

protocol Mapable {
    init(fromJson json: Dictionary<String, Any>)
}

extension Mapable where Self: NSObject {

    init(fromJson json: Dictionary<String, Any>) {
        self.init()
        
        self.props().forEach { (element) in
            if let jsonDict = json[element.label], jsonDict is Dictionary<String, Any> {
                // DICTIONARY VALUE: means that model's property is complex object that conforms to Mapable protocol
                let newValType = type(of: element.value) as! OptionalProtocol.Type
                let obj = (newValType.wrappedType() as! Mapable.Type).init(fromJson: (jsonDict as! Dictionary<String, Any>))
                
                self.setValue(obj, forKey: element.label)
            } else if let jsonArray = json[element.label], jsonArray is Array<Any> {
                // ARRAY VALUE: suppose that every element's type of array is the same, in this case first we need to figure out what type of array do we have
                var castType = type(of: element.value) as! TypeWrapper.Type
                if castType is OptionalProtocol.Type { // get wrapped type if model's array was optional
                    castType = castType.wrappedType() as! TypeWrapper.Type
                }
                let elementType = castType as! ArrayProtocol.Type
                
                if elementType.wrappedType() is Mapable.Type {
                    let jsonElements = (jsonArray as! Array<Dictionary<String, Any>>)
                    var objects = [Mapable]()
                    for element: Dictionary<String, Any> in jsonElements {
                        let actualObj = (elementType.wrappedType() as! Mapable.Type).init(fromJson: element)
                        type(of: actualObj)
                        objects.append(actualObj)
                    }
                    self.setValue(objects, forKey: element.label)
                }
            } else if let val = json[element.label], isPrimitive(element) {
                // SIMPLE VALUE: in case of simple value just set model's property with simple value
                self.setValue(val, forKey: element.label)
            }
        }
    }
    
    private func isPrimitive(_ obj: (label: String, value: Any)) -> Bool {
        let objType = type(of: obj.value)
        
        return (objType is _NSContiguousString.Type) || (objType is NSNumber.Type) || (objType is Optional<String>.Type) || (objType is Int.Type)
    }
    
    private func props() -> [(label: String, value: Any)] {
        var props = [(label: String, value: Any)]()
        return self.propsFor(mirror: Mirror(reflecting: self), storeIn: &props)
    }
    
    private func propsFor(mirror: Mirror, storeIn props: inout [(label: String, value: Any)]) -> [(label: String, value: Any)] {
        
        if let superMirror = mirror.superclassMirror {
            self.propsFor(mirror: superMirror, storeIn: &props)
        }
        let mirrorChildren = mirror.children.map({ (child) -> (label: String, value: Any) in
            (label: child.label!, value: child.value)
        })
        props.append(contentsOf: mirrorChildren)
        
        return props
    }
}


class ClassA: NSObject, Mapable {
    var superAwesome: String?
    var superName: String?
    var lol: Bool = false
    
    //    var testClass: ClassA?
}

class MyClass: ClassA {
    var name = "Sansa Stark"
    var awesome = true
    var userB = [ClassB]()
}

class ClassB: NSObject, Mapable {
    var superAwesome: String?
    var test: Int = 0
}

let jsonDictionary: Dictionary<String, Any> = ["testKey": "Test value:", "superAwesome": "ME", "userB": [["superAwesome": "Richard II", "test": 123], ["superAwesome": "Richard III", "test": 123], ["superAwesome": "Richard IV", "test": 90]]]
Int("101")
let some = MyClass(fromJson: jsonDictionary)
some.superAwesome
some.superName
some.name
some.awesome
some.userB.last?.superAwesome
some.userB.last?.test
