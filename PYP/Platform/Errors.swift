//
//  Errors.swift
//  PYP
//
//  Created by Dongbing Hou on 2022/11/14.
//

import Foundation

extension Networking {

    enum Error: Swift.Error {
        case invalidURL
        case decodeFailed
        case network
        case noAvailableData
        case timeout
        case retryOut
        case unknown
        case underlying(message: String?)

        var message: String? {
            switch self {
            case .invalidURL: return "无效的URL"
            case .decodeFailed: return "数据解析失败"
            case .network: return "网络出错了"
            case .noAvailableData: return "无可用数据"
            case .timeout: return "超时"
            case .retryOut: return "重试次数超限"
            case .unknown: return "未知错误"
            case .underlying(let msg):
                if let msg {
                    return "出错了 \n \(msg)"
                } else {
                    return "出错了"
                }
            }
        }
    }
}
