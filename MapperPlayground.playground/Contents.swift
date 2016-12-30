//: Playground - noun: a place where people can play

import Foundation
import UIKit

protocol OptionalProtocol {
    static func wrappedType() -> Any.Type
}

extension Optional : OptionalProtocol {
    static func wrappedType() -> Any.Type {
        return Wrapped.self
    }
}

protocol ArrayProtocol {
    static func wrappedType() -> Any.Type
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
                // DICTIONARY VALUE: means that model has
                let newValType = type(of: element.value) as! OptionalProtocol.Type
                let obj = (newValType.wrappedType() as! Mapable.Type).init(fromJson: (jsonDict as! Dictionary<String, Any>))
                
                self.setValue(obj, forKey: element.label)
            } else if let jsonArray = json[element.label], jsonArray is Array<Any> {
                // ARRAY VALUE
                let type = type(of: jsonArray) as! ArrayProtocol.Type
                let arrayElementType = type.wrappedType()
                
                let castType = type(of: element.value) as! OptionalProtocol.Type
                let arrayType = castType.wrappedType() as! ArrayProtocol.Type
                
                if arrayElementType == Dictionary<String, String>.self {
                    print("OLALA")
                }
                let array = jsonArray as! Array<Any>
                
                (jsonArray as! Array<Any>).forEach({ (arrayElement) in
                    print(type(of: arrayElement))
                })
                //                let newValType = type(of: element.value) as! OptionalProtocol.Type
                //                let obj = (newValType.wrappedType() as! Mapable.Type).init(fromJson: (jsonArray as! Array<Any>))
                //
                //                self.setValue(obj, forKey: element.label)
            } else if let val = json[element.label] {
                // SIMPLE VALUE
                self.setValue(val, forKey: element.label)
            }
        }
        
        json.keys.forEach { (key) in
            //            print(key)
        }
    }
    
    func props() -> [(label: String, value: Any)] {
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
    var anotherUser: [ClassB]?
}

class ClassB: NSObject, Mapable {
}

//let jsonDictionary: Dictionary<String, Any> = ["superAwesome": "Me", "superName": "AlsoMe", "name": "TEST_VALUE", "anotherUser": ["superAwesome": "You"]]
let jsonDictionary: Dictionary<String, Any> = ["testKey": "Test value:", "superAwesome": "ME","anotherUser": [["superAwesome": "You"], ["superAwesome": "Him"]]]




let some = MyClass(fromJson: jsonDictionary)
//some.setValue("ME", forKey: "superName")
print(some.superAwesome)
print(some.superName)
print(some.name)
print(some.awesome)
print(some.anotherUser)
//print(some.anotherUser?.superAwesome)
let mirror = Mirror(reflecting: some)
type(of: mirror)


mirror.children.map { type(of: $0.value) }
