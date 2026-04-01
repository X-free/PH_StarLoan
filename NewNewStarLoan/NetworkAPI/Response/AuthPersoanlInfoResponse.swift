//
//  AuthPersoanlInfoResponse.swift
//  StarLoan
//
//  Created by Albert on 2025/4/20.
//

import Foundation

struct AuthPersoanlInfoResponse: Codable {
  let hundred: String
  let seats: String
  let middle: MiddleInfo?
  
  struct MiddleInfo: Codable {

//    let wedneskpiday: WedneskpidayInfo
    
//    struct WedneskpidayInfo: Codable {
//      let cousin: String
//      let trade: String
//      let studied: String
//      let mountainside: Int
//    }
  }
}
