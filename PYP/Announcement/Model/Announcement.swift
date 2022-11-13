//
//  Announcement.swift
//  PYP
//
//  Created by Dongbing Hou on 2022/11/12.
//

import Foundation

struct Announcement: Identifiable, Codable {

    let id: String
    let name: String
    let imageName: String
    let lotId: String
}

struct BidRegister: Identifiable, Codable {
    let id: String
}
