//
//  BidOrderService.swift
//  PYP
//
//  Created by Dongbing Hou on 2022/11/13.
//

import Foundation

struct BidOrderService {

    private let cache: UserDefaults

    private let key: String

    init(cache: UserDefaults = .standard, key: String = "bid-orders") {
        self.cache = cache
        self.key = key
    }

    func loadBidOrders(completion: @escaping (Result<[BidOrder], Error>) -> Void) {
        fetchBidOrders { result in
            switch result {
            case .success(let items):
                if let items, !items.isEmpty {
                    updateCached(bidOrders: items)
                    completion(.success(items))
                } else {
                    completion(.success([]))
                }
            case .failure:
                completion(.success(retrieveBidOrders() ?? []))
            }
        }
    }

    func fetchBidOrders(completion: @escaping (Result<[BidOrder]?, Networking.Error>) -> Void) {
        Networking.shard.request(
            url: "https://bff.pyp.com/bid-orders",
            model: [BidOrder].self,
            completion: completion
        )
    }

    func updateCached(bidOrders: [BidOrder]) {
        guard let data = try? JSONEncoder().encode(bidOrders) else { return }
        cache.set(data, forKey: key)
    }

    func retrieveBidOrders() -> [BidOrder]? {
        guard
            let data = cache.value(forKey: key) as? Data,
            let bidOrders = try? JSONDecoder().decode([BidOrder].self, from: data)
        else { return nil }
        return bidOrders
    }
}
