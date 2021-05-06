//
//  SSLTSLExampleTests.swift
//  SSLTSLExampleTests
//
//  Created by Mateusz Fidos on 05/05/2021.
//

import XCTest
@testable import SSLTSLExample

class SSLTSLExampleTests: XCTestCase {

    private let client = NetworkClient()

    func test_Github() throws {

        let expectation = XCTestExpectation(description: "Github call did succeed!")

        makeGithubCall { (result, error) in
            guard result == true, error == nil else {
                XCTFail(error?.localizedDescription ?? "Github call did fail")
                return
            }

            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }


    func test_StackOverflow() throws {

        let expectation = XCTestExpectation(description: "StackOverflow call did fail!")

        makeStackOverflowCall { (result, error) in
            guard result == true, error == nil else {
                expectation.fulfill()
                return
            }

            XCTFail("StackOverflow call should not succeed")
        }

        wait(for: [expectation], timeout: 1.0)
    }


    private func makeGithubCall(completion: @escaping (Bool, Error?) -> Void) {
        client.makeRequest(URL(string: "https://github.com")!, completion: completion)
    }


    private func makeStackOverflowCall(completion: @escaping (Bool, Error?) -> Void) {
        client.makeRequest(URL(string: "https://stackoverflow.com")!, completion: completion)
    }

}
