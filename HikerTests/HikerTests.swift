//
//  HikerTests.swift
//  HikerTests
//
//  Created by Andrew James on 8/2/18.
//  Copyright © 2018 aj. All rights reserved.
//

import XCTest
import MapKit
@testable import Hiker

class HikerTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func test_MKAnnotationExtension() {
        
        let expected = "Lat:  37.34092739\nLong: -122.08983097\n\n\nname: I-280 N\naddress1: I-280 N\naddress2: \ncity: Los Altos\nstate: CA\nzip code: 94024\ncountry: United States\nareasOfInterest: "
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: 37.34092739, longitude: -122.08983097)
        
        let expetation = expectation(description: #function)
        var actual: String?
        
        annotation.detail { text in
            actual = text
            expetation.fulfill()
        }
        
        waitForExpectations(timeout: 3) { error in
            XCTAssertNil(error)
            XCTAssertEqual(expected, actual)
        }
    }
    
}
