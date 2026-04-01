//
//  OrderAPI.swift
//  StarLoan
//
//  Created by Albert on 2025/4/17.
//

import Foundation
import Moya

enum OrderAPI {
  case jumpWithOrderNumber(rose: String)
  case orderList(outlined: String)
}

extension OrderAPI: APIService {
  var path: String {
    switch self {
    case .jumpWithOrderNumber:
      return "/allstar/chair"
    case .orderList:
      return "/allstar/later"
    }
  }
  
  var method: Moya.Method {
    switch self {
    case .jumpWithOrderNumber, .orderList:
      return .post
    }
  }
  
  var headers: [String : String]? {
    return [
        "Content-Type": "application/x-www-form-urlencoded",
        "Accept": "application/json"
    ]
  }
  
  var task: Moya.Task {
    let params = getCommonParameters()
    let bodyParams: [String: String]
    
    switch self {
    case let .jumpWithOrderNumber(rose):
      bodyParams = [
        "rose": rose,
        "woodland": String.generateUUID(),
        "brightened": String.generateUUID(),
        "crests": String.generateUUID(),
        "draperies": String.generateUUID()
      ]
    case .orderList(outlined: let outlined):
      bodyParams = ["outlined": outlined]
    }
    
    return .requestCompositeParameters(
        bodyParameters: bodyParams,
        bodyEncoding: URLEncoding.httpBody,
        urlParameters: params
    )
  }
}
