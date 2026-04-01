//
//  AuthAPI.swift
//  StarLoan
//
//  Created by Albert on 2025/4/1.
//

import Foundation
import Moya

enum AuthAPI {
  case getCode(sky: String, kites: String)
  case login(smiling: String, wheel: String, poked: String, clean: String, swallow: String, mouth: String)
  case logout
  case cancelAccount
}

extension AuthAPI: APIService {
  var path: String {
    switch self {
    case .getCode:
      return "/allstar/anything"
    case .login:
      return "/allstar/could"
    case .logout:
      return "/allstar/dozen"
    case .cancelAccount:
      return "/allstar/shall"
    }
  }
  
  var method: Moya.Method {
    switch self {
    case .getCode, .login:
      return .post
    case .logout, .cancelAccount:
      return .get
    }
  }
  
  var headers: [String: String]? {
    return [
      "Content-Type": "application/x-www-form-urlencoded",
      "Accept": "application/json"
    ]
  }
  
  var task: Moya.Task {
    switch self {
    case .logout:
      var params = getCommonParameters()
      params["lumbering"] = String.generateUUID()
      params["squatting"] = String.generateUUID()
      return .requestParameters(
        parameters: params,
        encoding: URLEncoding(destination: .queryString)
      )
    case .cancelAccount:
      var params = getCommonParameters()
      params["packed"] = String.generateUUID()
      return .requestParameters(
        parameters: params,
        encoding: URLEncoding(destination: .queryString)
      )
    case let .getCode(sky, kites):
      let params = getCommonParameters()
      let bodyParams = [
        "sky": sky,
        "kites": kites
      ]
      return .requestCompositeParameters(
        bodyParameters: bodyParams,
        bodyEncoding: URLEncoding.httpBody,
        urlParameters: params
      )
      
    case let .login(smiling, wheel, poked, clean, swallow, mouth):
      let params = getCommonParameters()
      let bodyParams = [
        "smiling": smiling,
        "wheel": wheel,
        "poked": poked,
        "clean": clean,
        "swallow": swallow,
        "mouth": mouth
      ]
      
      return .requestCompositeParameters(
        bodyParameters: bodyParams,
        bodyEncoding: URLEncoding.httpBody,
        urlParameters: params
      )
    }
  }
}
