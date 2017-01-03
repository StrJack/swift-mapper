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
                // DICTIONARY VALUE: means that model's property is complex object that conforms to Mapable protocol
                let newValType = type(of: element.value) as! OptionalProtocol.Type
                let obj = (newValType.wrappedType() as! Mapable.Type).init(fromJson: (jsonDict as! Dictionary<String, Any>))
                
                self.setValue(obj, forKey: element.label)
            } else if let jsonArray = json[element.label], jsonArray is Array<Any> {
                // ARRAY VALUE: suppose that every element's type of array is the same, in this case first we need to figure our what type of array do we have
                let type = type(of: jsonArray) as! ArrayProtocol.Type
                let arrayElementType = type.wrappedType()
                
                let castType = type(of: element.value) as! OptionalProtocol.Type
                let elementType = castType.wrappedType() as! ArrayProtocol.Type
                
                if elementType.wrappedType() is Mapable.Type {
                    print("OLALA")
                    let jsonElements = (jsonArray as! Array<Dictionary<String, Any>>)
                    var objects = [Mapable]()
                    for element: Dictionary<String, Any> in jsonElements {
//                        print("** -> \(element)")
                        let actualObj = (elementType.wrappedType() as! Mapable.Type).init(fromJson: element)
                        objects.append(actualObj)
                        
                        print("** -> \(actualObj)")
                        
                    }
                    self.setValue(objects, forKey: element.label)
//                    let newObj = (elementType.wrappedType() as! Mapable.Type).init(fromJson: ((jsonArray as! Array<Any>).first as! Dictionary<String, Any>)) as! ClassB
//                    newObj.superAwesome
                }
                
                if arrayElementType == Dictionary<String, String>.self {
                    
                }
                let array = jsonArray as! Array<Any>
                
                (jsonArray as! Array<Any>).forEach({ (arrayElement) in
                    print(type(of: arrayElement))
                })
                //                let newValType = type(of: element.value) as! OptionalProtocol.Type
                //                let obj = (newValType.wrappedType() as! Mapable.Type).init(fromJson: (jsonArray as! Array<Any>))
                //
                //                self.setValue(obj, forKey: element.label)
            } else if let val = json[element.label] {//, isPrimitive(element.value as AnyObject) {
                // SIMPLE VALUE: in case of simple value just set model's property with simple value
                let some_type = type(of: (val as AnyObject))
                if isPrimitive(val as AnyObject) {
                    print("Olala1\(val)")
                }
                if some_type is NSNumber.Type {
                    print("Olala2\(val)")
                }
                print("------\(some_type)")
                val
                element.label
                self.setValue(val, forKey: element.label)
            }
        }
        
        json.keys.forEach { (key) in
            //            print(key)
        }
    }
    
    func isPrimitive(_ obj: AnyObject) -> Bool {
        let objType = type(of: obj)
        return (objType is _NSContiguousString.Type) || (objType is NSNumber.Type)
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
    var anotherUser = true //[ClassB]?
}

class ClassB: NSObject, Mapable {
    var superAwesome: String?
}

//let jsonDictionary: Dictionary<String, Any> = ["superAwesome": "Me", "superName": "AlsoMe", "name": "TEST_VALUE", "anotherUser": ["superAwesome": "You"]]
let s: String? = nil
let jsonDictionary: Dictionary<String, Any> = ["testKey": "Test value:", "superAwesome": "ME", "anotherUser": true]//[["superAwesome": "You"], ["superAwesome": "Him"], ["some_key": 123]]]




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
