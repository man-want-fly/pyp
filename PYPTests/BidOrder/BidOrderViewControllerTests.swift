//
//  BidOrderViewControllerTests.swift
//  PYPTests
//
//  Created by Dongbing Hou on 2022/11/13.
//

import OHHTTPStubs
import OHHTTPStubsSwift
import XCTest

@testable import PYP

class BidOrderViewControllerTests: XCTestCase {

    private var cacheKey: String!
    private var suiteName: String!
    private var fakeCache: UserDefaults!
    private var service: BidOrderService?
    private var controller: BidOrderViewController?

    override func setUpWithError() throws {
        try super.setUpWithError()

        cacheKey = "test-bid-orders"
        suiteName = UUID().uuidString
        fakeCache = UserDefaults(suiteName: suiteName)
        service = .init(cache: fakeCache, key: cacheKey)
        controller = .init(service: service!)
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()

        HTTPStubs.removeAllStubs()
        fakeCache.removeSuite(named: suiteName)
        fakeCache = nil
    }

    func testSuccessfullyDecodedBidOrder() throws {

        let order = BidOrder(id: "1", name: "奔马图", status: .success)
        let wrapper = ModelWrapper(data: [order], message: "success", code: 200)

        let expect = expectation(description: "request /bid-orders for decode")

        stub(condition: isPath("/bid-orders")) { _ in
            let data = try! JSONEncoder().encode(wrapper)
            return .init(
                data: data,
                statusCode: 200,
                headers: ["Content-Type": "application/json"]
            )
        }


        controller?.service.loadBidOrders { result in

            let firstOrder = try! result.get()[0]

            XCTAssertEqual(firstOrder.id, order.id)
            XCTAssertEqual(firstOrder.name, order.name)

            expect.fulfill()
        }


        waitForExpectations(timeout: 30)
    }
}
