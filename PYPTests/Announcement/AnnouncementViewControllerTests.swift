//
//  AnnouncementViewControllerTests.swift
//  PYPTests
//
//  Created by Dongbing Hou on 2022/11/13.
//

import OHHTTPStubs
import OHHTTPStubsSwift
import XCTest

@testable import PYP

final class AnnouncementViewControllerTests: XCTestCase {

    private var controller: AnnouncementViewController?

    override func setUpWithError() throws {
        try super.setUpWithError()

        controller = .init()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()

        HTTPStubs.removeAllStubs()
    }

    func testSuccessfullyDecodedBidRegister() throws {
        let register = BidRegister(id: "1")
        let wrapper = ModelWrapper(data: register, message: "success", code: 200)

        let expect = expectation(description: "request /bid-rfps for decode")

        stub(condition: isPath("/bid-rfps")) { _ in
            let data = try! JSONEncoder().encode(wrapper)
            return .init(
                data: data,
                statusCode: 200,
                headers: ["Content-Type": "application/json"]
            )
        }

        controller?.service.bidRegister(id: "") { result in

            XCTAssertEqual(try! result.get().id, register.id)

            expect.fulfill()
        }

        waitForExpectations(timeout: 30)
    }
}
