//
//  SwiftMapperTests.swift
//  SwiftMapperTests
//
//  Created by Yevhen Strohanov on 1/4/17.
//  Copyright © 2017 JackTech. All rights reserved.
//

import XCTest
@testable import SwiftMapper

class SwiftMapperTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    // STRING
    func testModelCanInitializeStringProperty() {
        let dictionary: Dictionary<String, Any> = ["firstName": "Alex"]
        let human = Human(fromJson: dictionary)
        
        XCTAssertEqual(human.firstName, "Alex")
    }
    
    func testModelKeepOptionalPropertyUninitialized() {
        let dictionary: Dictionary<String, Any> = ["firstName": "Simon"]
        let human = Human(fromJson: dictionary)
        
        XCTAssertEqual(human.firstName, "Simon")
        XCTAssertNil(human.lastName)
    }
    
    func testModelCanInitializeOptionalStringProperty() {
        let dictionary: Dictionary<String, Any> = ["lastName": "Smith"]
        let human = Human(fromJson: dictionary)
        
        XCTAssertEqual(human.lastName, "Smith")
    }
    
    // COMPLEX OBJECT - DICTIONARY
    func testModelCanInitializeComplexPropertyInFull() {
        let dictionary: Dictionary<String, Any> = ["currentAddress": ["buildingNumber": 5, "street": "Wacker", "city": "Chicago"]]
        let human = Human(fromJson: dictionary)
        
        XCTAssertNotNil(human.currentAddress)
        XCTAssertEqual(human.currentAddress.buildingNumber, 5)
        XCTAssertEqual(human.currentAddress.street, "Wacker")
        XCTAssertEqual(human.currentAddress.city, "Chicago")
    }
    
    func testModelCanInitializeOptionalComplexPropertyInFull() {
        let dictionary: Dictionary<String, Any> = ["previousAddress": ["buildingNumber": 7, "street": "Washington", "city": "New York"]]
        let human = Human(fromJson: dictionary)
        
        XCTAssertNotNil(human.previousAddress)
        XCTAssertEqual(human.previousAddress?.buildingNumber, 7)
        XCTAssertEqual(human.previousAddress?.street, "Washington")
        XCTAssertEqual(human.previousAddress?.city, "New York")
    }
    
    func testModelCanInitializeComplexPropertyPartially() {
        let dictionary: Dictionary<String, Any> = ["currentAddress": ["buildingNumber": 9, "city": "San Francisco"]]
        let human = Human(fromJson: dictionary)
        
        XCTAssertNotNil(human.currentAddress)
        XCTAssertNotNil(human.currentAddress.buildingNumber)
        XCTAssertNotNil(human.currentAddress.city)
        XCTAssertNil(human.currentAddress.street)
    }
    
    func testModelCanInitializeOptionalComplexPropertyPartially() {
        let dictionary: Dictionary<String, Any> = ["previousAddress": ["buildingNumber": 13, "city": "Los Angeles"]]
        let human = Human(fromJson: dictionary)
        
        XCTAssertNil(human.previousAddress!.street)
    }
}
