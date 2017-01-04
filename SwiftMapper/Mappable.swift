//
//  Mappable.swift
//  SwiftMapper
//
//  Created by Yevhen Strohanov on 1/4/17.
//  Copyright © 2017 JackTech. All rights reserved.
//

import Foundation

public protocol Mappable {
    init(fromJson json: Dictionary<String, Any>)
}

public extension Mappable where Self: NSObject {
    
    init(fromJson json: Dictionary<String, Any>) {
        self.init()
        
        self.props().forEach { (element) in
            if let jsonDict = json[element.label], jsonDict is Dictionary<String, Any> {
                // DICTIONARY VALUE: means that model's property is complex object that conforms to Mappable protocol
                var newValType: Any.Type = type(of: element.value)// as! TypeWrapper.Type
                if newValType is OptionalProtocol.Type {
                    newValType = (newValType as! OptionalProtocol.Type).wrappedType()
                }
                let obj = (newValType as! Mappable.Type).init(fromJson: (jsonDict as! Dictionary<String, Any>))
                
                self.setValue(obj, forKey: element.label)
            } else if let jsonArray = json[element.label], jsonArray is Array<Any> {
                // ARRAY VALUE: suppose that every element's type of array is the same, in this case first we need to figure out what type of array do we have
                var castType = type(of: element.value) as! TypeWrapper.Type
                if castType is OptionalProtocol.Type { // get wrapped type if model's array was optional
                    castType = castType.wrappedType() as! TypeWrapper.Type
                }
                let elementType = castType as! ArrayProtocol.Type
                
                if elementType.wrappedType() is Mappable.Type {
                    let jsonElements = (jsonArray as! Array<Dictionary<String, Any>>)
                    var objects = [Mappable]()
                    for element: Dictionary<String, Any> in jsonElements {
                        let actualObj = (elementType.wrappedType() as! Mappable.Type).init(fromJson: element)
                        type(of: actualObj)
                        objects.append(actualObj)
                    }
                    self.setValue(objects, forKey: element.label)
                }
            } else if var value = json[element.label], isPrimitive(element) {
                // SIMPLE VALUE: in case of simple value just set model's property with simple value
                var unwrappedType: Any.Type = type(of: element.value)
                if unwrappedType is OptionalProtocol.Type {
                    unwrappedType = (unwrappedType as! OptionalProtocol.Type).wrappedType()
                }
                
                if unwrappedType is Simple.Type, let actualValue = (unwrappedType as! Simple.Type).initWith(value) {
                    value = actualValue
                }
                self.setValue(value, forKey: element.label)
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
            _ = self.propsFor(mirror: superMirror, storeIn: &props)
        }
        let mirrorChildren = mirror.children.map({ (child) -> (label: String, value: Any) in
            (label: child.label!, value: child.value)
        })
        props.append(contentsOf: mirrorChildren)
        
        return props
    }
}
