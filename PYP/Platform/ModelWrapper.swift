//
//  ModelWrapper.swift
//  PYP
//
//  Created by Dongbing Hou on 2022/11/14.
//

import Foundation

struct ModelWrapper<T: Codable>: Codable {
    let data: T?
    let message: String?
    let code: Int
}

extension Result {

    var error: Error? {
        if case .failure(let failure) = self {
            return failure
        }
        return nil
    }
}
