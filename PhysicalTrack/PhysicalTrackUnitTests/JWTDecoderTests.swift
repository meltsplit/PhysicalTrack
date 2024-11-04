//
//  PhysicalTrackUnitTests.swift
//  PhysicalTrackUnitTests
//
//  Created by 장석우 on 11/2/24.
//

import XCTest
@testable import PhysicalTrack

final class JWTDecoderTests: XCTestCase {

    override func setUpWithError() throws {

    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_jwt토큰을_성공적으로_디코딩하는가() async{
        let jwtToken = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJkZXZpY2VJZCI6IkUwREE2MzNELTJFMzAtNDI3Ni1CREQ5LTJFRDVFODBCMkRFQyIsInVzZXJJZCI6MiwibmFtZSI6IuyepeyEneyasCIsImlhdCI6MTczMDU1NDE1NiwiZXhwIjoxNzMwODEzMzU2fQ.03yDDkgUHkQdxUM58OhyuInO5mGwoe5T10QlgMke1-4"
        
        guard let decodedToken = try? JWTDecoder.decode(jwtToken) else {
            XCTFail()
            return
        }
        
        print(decodedToken)
        
        
        
    }
}
