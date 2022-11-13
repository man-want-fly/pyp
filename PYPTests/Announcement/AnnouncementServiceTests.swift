//
//  AnnouncementServiceTests.swift
//  PYPTests
//
//  Created by Dongbing Hou on 2022/11/13.
//

import OHHTTPStubs
import OHHTTPStubsSwift
import XCTest

@testable import PYP

final class AnnouncementServiceTests: XCTestCase {

    private var service: AnnouncementService?

    override func setUpWithError() throws {
        try super.setUpWithError()

        service = .init()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()

        HTTPStubs.removeAllStubs()
    }

    func testSuccessfullyBidRegister() throws {
        let register = BidRegister(id: "1")
        let wrapper = ModelWrapper(data: register, message: "success", code: 200)

        let expect = expectation(description: "request /bid-rfps")

        stub(condition: isPath("/bid-rfps")) { _ in
            let data = try! JSONEncoder().encode(wrapper)
            return .init(
                data: data,
                statusCode: 200,
                headers: ["Content-Type": "application/json"]
            )
        }

        service?.bidRegister(id: "") { result in

            XCTAssertEqual(try! result.get().id, register.id)

            expect.fulfill()
        }

        waitForExpectations(timeout: 30)
    }

    func testFailedBidRegister() throws {
        let wrapper = ModelWrapper<BidRegister>(data: nil, message: "success", code: 400)

        let expect = expectation(description: "request /bid-rfps succeed with error code")

        stub(condition: isPath("/bid-rfps")) { _ in
            let data = try! JSONEncoder().encode(wrapper)
            return .init(
                data: data,
                statusCode: 200,
                headers: ["Content-Type": "application/json"]
            )
        }

        service?.bidRegister(id: "") { result in

            XCTAssertNotNil(result.error)

            expect.fulfill()
        }

        waitForExpectations(timeout: 30)
    }

    func testFailedPerformBidRegisterRequest() throws {
        let expect = expectation(description: "request /bid-rfps failed with error")

        stub(condition: isPath("/bid-rfps")) { _ in
            return .init(
                data: .init(),
                statusCode: 400,
                headers: ["Content-Type": "application/json"]
            )
        }

        service?.bidRegister(id: "") { result in

            XCTAssertNotNil(result.error)

            expect.fulfill()
        }

        waitForExpectations(timeout: 30)
    }
}
