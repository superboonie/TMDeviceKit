//
//  DeviceInfoTests.swift
//  DeviceInfoTests
//
//  Created by BOON CHEW on 11/20/15.
//  Copyright © 2015 BOON CHEW. All rights reserved.
//

import XCTest
@testable import TMDeviceKit

class DeviceInfoTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testDeviceIdentifier() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let extraInfo = UIDevice.currentDevice().extraInfo
        XCTAssert(!extraInfo.rawIdentifier.isEmpty, "Raw identifier must not be empty")
        XCTAssert(!extraInfo.identifier.isEmpty, "Identifier must not be empty")
        
        if (extraInfo.rawIdentifier == "x86_64") {
            XCTAssert(extraInfo.identifier == "Simulator", "Identifier must be simulator")
        }
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
    func osVersion() {
        let extraInfo = UIDevice.currentDevice().extraInfo
        XCTAssert(extraInfo.osVersion.major > 0, "Major version must be larger than 0")
        XCTAssert(extraInfo.osVersion.minor > 0, "Minor version must be larger than 0")
        XCTAssert(extraInfo.osVersion.patch >= 0, "Patch version must be larger than or equal to 0")
    }
    
}
