//
//  BidOrderServiceTests.swift
//  PYPTests
//
//  Created by Dongbing Hou on 2022/11/13.
//

import OHHTTPStubs
import OHHTTPStubsSwift
import XCTest

@testable import PYP

class BidOrderServiceTests: XCTestCase {

    private var cacheKey: String!
    private var suiteName: String!
    private var fakeCache: UserDefaults!
    private var service: BidOrderService?

    override func setUpWithError() throws {
        try super.setUpWithError()

        cacheKey = "test-bid-orders"
        suiteName = UUID().uuidString
        fakeCache = UserDefaults(suiteName: suiteName)
        service = .init(cache: fakeCache, key: cacheKey)
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()

        HTTPStubs.removeAllStubs()
        fakeCache.removeSuite(named: suiteName)
        fakeCache = nil
    }

    func testSuccessfullyFetchBidOrders() throws {
        let orders: [BidOrder] = [
            .init(id: "1", name: "奔马图", status: .success),
            .init(id: "2", name: "蒙娜丽莎", status: .fail),
        ]
        let wrapper = ModelWrapper(data: orders, message: "success", code: 200)

        let expect = expectation(description: "request /bid-orders with 2 items")

        stub(condition: isPath("/bid-orders")) { _ in
            let data = try! JSONEncoder().encode(wrapper)
            return .init(
                data: data,
                statusCode: 200,
                headers: ["Content-Type": "application/json"]
            )
        }

        service?.fetchBidOrders { result in

            XCTAssertEqual(try! result.get()!.count, 2)

            expect.fulfill()
        }

        waitForExpectations(timeout: 30)
    }

    func testSuccessfullyFetchEmptyBidOrders() throws {

        let wrapper = ModelWrapper<[BidOrder]>(data: [], message: "success", code: 200)

        let expect = expectation(description: "request /bid-orders with 0 item")

        stub(condition: isPath("/bid-orders")) { _ in
            let data = try! JSONEncoder().encode(wrapper)
            return .init(
                data: data,
                statusCode: 200,
                headers: ["Content-Type": "application/json"]
            )
        }

        service?.fetchBidOrders { result in

            XCTAssertEqual(try! result.get()!.count, 0)

            expect.fulfill()
        }

        waitForExpectations(timeout: 30)
    }

    func testFailedFetchBidOrders() throws {

        let expect = expectation(description: "request /bid-orders failed")

        stub(condition: isPath("/bid-orders")) { _ in
            return .init(
                data: .init(),
                statusCode: 400,
                headers: ["Content-Type": "application/json"]
            )
        }

        service?.fetchBidOrders { result in

            XCTAssertNotNil(result.error)

            expect.fulfill()
        }

        waitForExpectations(timeout: 30)
    }

    func testCacheShouldBeUpdatedWhenFetchedBidOrdersIsNotEmpty() throws {
        let orders: [BidOrder] = [
            .init(id: "1", name: "奔马图", status: .success),
            .init(id: "2", name: "蒙娜丽莎", status: .fail),
        ]
        let wrapper = ModelWrapper(data: orders, message: "success", code: 200)

        let expect = expectation(description: "request /bid-orders update cache")

        stub(condition: isPath("/bid-orders")) { _ in
            let data = try! JSONEncoder().encode(wrapper)
            return .init(
                data: data,
                statusCode: 200,
                headers: ["Content-Type": "application/json"]
            )
        }

        service?.loadBidOrders { result in

            let data = self.fakeCache.value(forKey: self.cacheKey) as! Data
            let items = try! JSONDecoder().decode([BidOrder].self, from: data)

            XCTAssertEqual(items.count, orders.count)
            XCTAssertEqual(items[0].id, orders[0].id)

            expect.fulfill()
        }

        waitForExpectations(timeout: 30)
    }

    func testSuccessfullyFetchedBidOrdersFromCacheWhenRequestFailed() throws {
        let orders: [BidOrder] = [
            .init(id: "1", name: "奔马图", status: .success),
            .init(id: "2", name: "蒙娜丽莎", status: .fail),
        ]

        service?.updateCached(bidOrders: orders)

        let expect = expectation(description: "request /bid-orders failed then read cache with 2 items")

        stub(condition: isPath("/bid-orders")) { _ in
            return .init(
                data: .init(),
                statusCode: 400,
                headers: ["Content-Type": "application/json"]
            )
        }

        service?.loadBidOrders { result in

            expect.fulfill()
        }

        let items = service!.retrieveBidOrders()!

        XCTAssertEqual(items.count, orders.count)
        XCTAssertEqual(items[0].id, orders[0].id)

        waitForExpectations(timeout: 30)
    }

    func testSuccessfullyFetchedEmptyBidOrdersFromCacheWhenRequestFailed() throws {
        service?.updateCached(bidOrders: [])

        let expect = expectation(description: "request /bid-orders failed then read cache with 0 item")

        stub(condition: isPath("/bid-orders")) { _ in
            return .init(
                data: .init(),
                statusCode: 400,
                headers: ["Content-Type": "application/json"]
            )
        }

        service?.loadBidOrders { result in

            expect.fulfill()
        }

        let items = service!.retrieveBidOrders()!

        XCTAssertEqual(items.count, 0)

        waitForExpectations(timeout: 30)
    }
}
