//
//  LoginResponse.swift
//  StarLoan
//
//  Created by Albert on 2025/4/1.
//
import Foundation

struct LoginResponse: Codable {
    let seats: String
    let hundred: String
    let middle: MiddleInfo
    
    struct MiddleInfo: Codable {
        let hypnotised: String
    }
}

struct FaceBookResponse: Codable {
  let seats: String
  let hundred: String
  
  let middle: MiddleInfo
  
  struct MiddleInfo: Codable {
    let curse: String
    let facebook: FBInfo
   
    struct FBInfo: Codable {
      let facebookClientToke: String
      let cFBundleURLScheme: String
      let facebookAppID: String
      let facebookDisplayName: String
    }
  }
}
