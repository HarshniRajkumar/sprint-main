//
//  sprint2Tests.swift
//  sprint2Tests
//
//  Created by Capgemini-DA088 on 9/21/22.
//

import XCTest
@testable import sprint2

class Login: XCTestCase {
    var LoginTst: ViewController!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    LoginTst = ViewController()
        LoginTst.loadViewIfNeeded()
    }
    
    func test_emaillet() throws{
        XCTAssertNil(LoginTst.emailTF,"Loginemail is not connected")
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    func test_mobilelet() throws{
        XCTAssertNil(LoginTst.passwordTF,"password is not connected")
    }
    class Signin : XCTestCase {
        override func setUpWithError() throws {
            
        
    var SignTst: SignUpViewController!
    
    SignTst = SignUpViewController()
    SignTst.loadViewIfNeeded()
        
        func test_phonelet() throws {
            XCTAssertNil(SignTst.phoneTF,"Phone not connected!")
        }
        }
    }
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

