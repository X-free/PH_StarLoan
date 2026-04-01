//
//  Untitled.swift
//  StarLoan
//
//  Created by Albert on 2025/4/17.
//
import Foundation

struct FetchJumpURLResponse: Codable {
  
  let seats: String
  let hundred: String
  let middle: MiddleInfo
  
  struct MiddleInfo: Codable {
      let trade: String
  }
  
}
