//
//  ProductResponse.swift
//  StarLoan
//
//  Created by Albert on 2025/4/1.
//

import Foundation

struct ProductResponse: Codable {
    let seats: String
    let hundred: String
    let middle: MiddleInfo
    
    struct MiddleInfo: Codable {
        let trade: String
    }
}


