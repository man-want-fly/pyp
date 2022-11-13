//
//  AnnouncementService.swift
//  PYP
//
//  Created by Dongbing Hou on 2022/11/13.
//

import Foundation

struct AnnouncementService {

    func bidRegister(
        id: String,
        completion: @escaping (Result<BidRegister, Networking.Error>) -> Void
    ) {
        Networking.shard.request(
            .post,
            url: "https://bff.pyp.com/bid-rfps",
            parameters: ["announcement_id": id],
            model: BidRegister .self
        ) { result in
            switch result {
                case .success(let item):
                if let item {
                    completion(.success(item))
                } else {
                    completion(.failure(Networking.Error.unknown))
                }
                case .failure(let err):
                completion(.failure(err))
            }
        }
    }
}
