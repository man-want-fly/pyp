//
//  AnnouncementService.swift
//  PYP
//
//  Created by Dongbing Hou on 2022/11/13.
//

import Foundation

struct AnnouncementService {

    enum BidRegisterStatus {
        case success(BidRegister)
        case retry
        case failure(Networking.Error)

        var id: String? {
            if case .success(let item) = self {
                return item.id
            }
            return nil
        }

        var error: Networking.Error? {
            if case .failure(let err) = self {
                return err
            }
            return nil
        }
    }

    func bidRegister(
        id: String,
        completion: @escaping (BidRegisterStatus) -> Void
    ) {
        Networking.shard.request(
            .post,
            url: "https://bff.stg.starbucks.com.cn/bid-rfps",
            parameters: ["announcement_id": id],
            model: BidRegister .self
        ) { result in
            switch result {
            case .success(let item):
                if let item {
                    completion(.success(item))
                } else {
                    completion(.failure(.unknown))
                }
            case .failure(let err):
                if case .timeout = err {
                    fetchBidRegisters(id: id) { status in
                        switch status {
                        case .success(let item):
                            if let id = item.id, !id.isEmpty {
                                completion(.success(item))
                            } else {
                                completion(.retry)
                            }
                        case .failure(let err):
                            completion(.failure(err))
                        }
                    }
                } else {
                    completion(.failure(err))
                }
            }
        }
    }

    func retryBidRegister(
        id: String,
        completion: @escaping (Result<BidRegister, Networking.Error>) -> Void
    ) {
        bidRegister(id: id) { result in
            switch result {
            case .retry: completion(.failure(.retryOut))
            case .failure(let err): completion(.failure(err))
            case .success(let item): completion(.success(item))
            }
        }
    }

    func fetchBidRegisters(
        id: String,
        completion: @escaping (Result<BidRegister, Networking.Error>) -> Void
    ) {
        Networking.shard.request(
            .get,
            url: "https://bff.stg.starbucks.com.cn/bid-rfps/\(id)",
            model: BidRegister .self
        ) { result in
            switch result {
            case .success(let item):
                if let item {
                    completion(.success(item))
                } else {
                    completion(.failure(.unknown))
                }
            case .failure(let err):
                completion(.failure(err))
            }
        }
    }
}
