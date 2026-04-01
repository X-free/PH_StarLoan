//
//  OrderService.swift
//  StarLoan
//
//  Created by Albert on 2025/4/17.
//

import Foundation
import Moya

class OrderService {
  static let shared = OrderService()
  private init() {}
  
  private let provider = MoyaProvider<OrderAPI>(plugins: [NetworkLoggerPlugin(configuration: .init(formatter: .init(responseData: NetworkFormatter.formatJSONResponse),
                                                                                                     logOptions: .verbose))])
  
  func fetchJumpURLWithOrder(rose: String) async throws -> FetchJumpURLResponse {
    let response = try await provider.asyncRequest(.jumpWithOrderNumber(rose: rose))
    let decoder = JSONDecoder()
    return try decoder.decode(FetchJumpURLResponse.self, from: response.data)
  }
  
  func fetchOrderList(outlined: String) async throws -> OrderListResponse {
    let response = try await provider.asyncRequest(.orderList(outlined: outlined))
    let decoder = JSONDecoder()
    return try decoder.decode(OrderListResponse.self, from: response.data)
  }

}
