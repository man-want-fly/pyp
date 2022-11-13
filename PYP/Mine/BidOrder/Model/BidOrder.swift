//
//  BidOrder.swift
//  PYP
//
//  Created by Dongbing Hou on 2022/11/13.
//

import Foundation

struct BidOrder: Identifiable, Codable {

    let id: String
    let name: String
    let status: Status

    enum Status: String, Codable {
        case success
        case fail
        case boughtIn = "bought_in"
        case bidding

        var statusText: String {
            switch self {
            case .success: return "竞拍成功"
            case .fail: return "竞拍失败"
            case .boughtIn: return "流拍"
            case .bidding: return "竞拍中"
            }
        }
    }
}
