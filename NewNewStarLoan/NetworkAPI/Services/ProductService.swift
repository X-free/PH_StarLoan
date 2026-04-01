//
//  ProductService.swift
//  StarLoan
//
//  Created by Albert on 2025/4/1.
//

import Foundation
import Moya

class ProductService {
  static let shared = ProductService()
  private init() {}
  
  private let provider = MoyaProvider<ProductAPI>(plugins: [NetworkLoggerPlugin(configuration: .init(formatter: .init(responseData: NetworkFormatter.formatJSONResponse),
                                                                                                     logOptions: .verbose))])
  
  func applyProduct(
    feud: String,
    bit: String,
    invited: String
  ) async throws -> ProductResponse {
    
    let response = try await provider.asyncRequest(.apply(feud: feud, bit: bit, invited: invited))
    let decoder = JSONDecoder()
    return try decoder.decode(ProductResponse.self, from: response.data)
  }
  
  func getProductDetail(
    feud: String,
    staying: String,
    since: String
  ) async throws -> ProductDetailResponse {
    let response = try await provider.asyncRequest(.detail(
      feud: feud,
      staying: staying,
      since: since
    ))
    return try JSONDecoder().decode(ProductDetailResponse.self, from: response.data)
  }

}
