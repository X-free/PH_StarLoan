//
//  ProductDetailResponse.swift
//  StarLoan
//
//  Created by Albert on 2025/4/2.
//

import Foundation

struct ProductDetailResponse: Codable {
    let hundred: String
    let seats: String
    let middle: ProductDetailMiddleInfo
}

struct ProductDetailMiddleInfo: Codable {
    let kabul: Int
    let tag: TagInfo
    let userInfo: UserInfo
    let engineering: [EngineeringItem]
    let wedneskpiday: WedneskpidayInfo?
}

struct TagInfo: Codable {
    let family: Int
    let shafiqa: String
    let termDesc: String
    let whirl: String
    let cratered: String
    let herat: String
    let visiting: Int
    let columnText: ColumnTextInfo
    let vomiting: String
    let buttonUrl: String
    let shrieking: String
    let disliked: Int
    let wives: String
    let everyone: String
    let afghans: String
    let france: String
    let trade: String
    let hotline: HotlineInfo
    let complaintUrl: String
}

struct ColumnTextInfo: Codable {
    let tag1: TagDetail
    let tag2: TagDetail
}

struct TagDetail: Codable {
    let studied: String
    let satisfy: String
}

struct HotlineInfo: Codable {
    let once: String
}

struct UserInfo: Codable {
    let sky: String
    let idNumber: String?
    let bad: String?
}

struct EngineeringItem: Codable {
    let studied: String
    let mentioned: String
    let mountainside: Int
    let trade: String
    let actually: Int
    let homayoun: String
    let cousin: String
    let called: Int
    let dozen: Int?  // 改为可选类型
    let another: Int
    let invite: String
    let managed: String
}

struct WedneskpidayInfo: Codable {
    let cousin: String
    let trade: String
    let mountainside: Int
    let studied: String
}
