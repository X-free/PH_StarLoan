//
//  UploadIDResponse.swift
//  StarLoan
//
//  Created by Albert on 2025/4/14.
//
import Foundation

struct UploadIDResponse: Codable {
  
  let seats: String
  let hundred: String
  let middle: MiddleInfo

  struct MiddleInfo: Codable {
    let bad: String
    let away: String
    let says: String
    let worry: String
    let trade: String
    let fireplace: String
    let khala: String
    let sofa: String
    let wedneskpiday: WednesdayInfo
    
    
    struct WednesdayInfo: Codable {
        let cousin: String
        let trade: String
        let mountainside: Int
        let studied: String
    }
  }
    
}

struct UploadFaceRegcognizeResponse: Codable {
  let seats: String
  let hundred: String
  let middle: MiddleInfo
  
  struct MiddleInfo: Codable {
    let sank: Int
  }
}

//Moya_Logger: [2025/4/15, 13:31] Response Body: {
//  "hundred" : "0",
//  "seats" : "success",
//  "middle" : {
//    "rtQmdf" : "CVAnK",
//    "VsrJsMQPC" : "690",
//    "8zVAn" : "2025-04-15 13:31:00",
//    "sank" : 0,
//    "KrGb5" : "true",
//    "7jdXaPjZPnN" : "#6d0db6",
//    "1wErrugFG" : 65778396,
//    "ExRDZL7EZ" : null,
//    "wedneskpiday" : {
//      "cousin" : "personal",
//      "trade" : "",
//      "studied" : "Personal information",
//      "mountainside" : 0
//    }
//  }
//}
