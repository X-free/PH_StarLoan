//
//  AppRelativeService.swift
//  StarLoan
//
//  Created by Albert on 2025/4/1.
//

import Foundation
import Moya
import Combine

class AppRelativeService {
  static let shared = AppRelativeService()
  private let provider = MoyaProvider<AppRelativeAPI>(plugins: [NetworkLoggerPlugin(configuration: .init(formatter: .init(responseData: NetworkFormatter.formatJSONResponse),
                                                                                              logOptions: .verbose))])
  
  private init() {}
  
  func getHomePage(trucks: String, multicolored: String) async throws -> HomePageResponse {
    let response = try await provider.asyncRequest(.homePage(trucks: trucks, multicolored: multicolored))
    let decoder = JSONDecoder()
    return try decoder.decode(HomePageResponse.self, from: response.data)
  }
}

