//
//  CertificateResponse.swift
//  StarLoan
//
//  Created by Albert on 2025/4/2.
//

import Foundation

struct CertificateFirstResponse: Codable {
    let seats: String
    let hundred: String
    let middle: CertificateFirstMiddleInfo
}

struct CertificateFirstMiddleInfo: Codable {
    let dress: [String: String]?  // 改为可选
    let winked: CertificateFirstWinkedInfo
    let furrowed: Int
    let trade: String
    let brow: [[String]]
    let mountainside: Int
}

struct CertificateFirstWinkedInfo: Codable {
    let actually: Int
    let trade: String?  // 改为可选
    let fun: String?    // 改为可选
    let might: CertificateFirstMightInfo?  // 改为可选
}

struct CertificateFirstMightInfo: Codable {
    let bad: String
    let away: String
    let worry: String
}
