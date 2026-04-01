//
//  GetUserInfoResponse.swift
//  StarLoan
//
//  Created by Albert on 2025/4/15.
//
import Foundation

struct GetUserInfoResponse: Codable {
  let seats: String
  let hundred: String
  let middle: MiddleInfo
  
  struct MiddleInfo: Codable {
    let stopped: [StoppedItem]
    
    struct StoppedItem: Codable {
      let dozen: Int
      let homayoun: String
      let lines: [LineItem]
      let frequented: Bool
      let mentioned: String
      let once: String
      let whirl: Int
      let hundred: String
      let mazreez: String
      let followerske: Int
      let neighbourhood: Int
      let studied: String
      let mountainside: String
      let actually: Int
      
      struct LineItem: Codable {
        let bad: String
        let mountainside: Int
      }
    }
  }
}
