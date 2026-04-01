//
//  APIConfig.swift
//  StarLoan
//
//  Created by Albert on 2025/4/1.
//

import Foundation
import UIKit

enum APIConfig {
    static let host = "https://philippinemachinery.com/starloanapi"
  static let root = "https://philippinemachinery.com"
//    static let version = "/v1"
    static let baseURL = host
  static let privacyURL       = "\(root)/onionOstri"
  static let loanAgreementURL = "\(root)/kiwiOyster"
  static let fraudURL         = "\(root)/sorghumWin"
  static let customerURL      = "\(root)/brothDuckP"
  static let complainURL      = "\(root)/strawberry"
  static let contactUSURL     = "\(root)/samosaGara"
    static let timeoutInterval: TimeInterval = 30
}

extension String {
  static func generateUUID(length: Int = 10) -> String {
    return UUID().uuidString
      .replacingOccurrences(of: "-", with: "")
      .prefix(length)
      .lowercased()
  }
}
