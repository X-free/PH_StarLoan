//
//  CertificateAPI.swift
//  StarLoan
//
//  Created by Albert on 2025/4/2.
//

import Foundation
import Moya
import Alamofire

enum CertificateAPI {
  case userPublic(feud: String, warm: String)
  case uploadImage(request: UploadImageModel)  // 修改为接收 UploadImageModel
  case saveUserProfile(worry: String, away: String, bad: String, fun: String, shrug: String)
  case getUserInfo(feud: String)
  case getWorkInfo(feud: String)
  case getContactInfo(feud: String, pleasure: String)
  case getAddress
  case saveUserInfo(dict: [String: String])
  case saveWorkInfo(dict: [String: String])
  case saveContactInfo(feud: String, middle: String)
  case getBankInfo
  case saveBankInfo(dict: [String: String])
}

extension CertificateAPI: APIService {
  var path: String {
    switch self {
    case .userPublic:
      return "/allstar/fight"
    case .uploadImage:
      return "/allstar/firmlet"
    case .saveUserProfile:
      return "/allstar/homayoun"
    case .getUserInfo:
      return "/allstar/managed"
    case .getAddress:
      return "/allstar/right"
    case .saveUserInfo:
      return "/allstar/karima"
    case .saveWorkInfo:
      return "/allstar/couldhappen"
    case .saveContactInfo:
      return "/allstar/should"
    case .getWorkInfo:
      return "/allstar/laughed"
    case .getContactInfo:
      return "/allstar/silencei"
    case .getBankInfo:
      return "/allstar/paint"
    case .saveBankInfo:
      return "/allstar/heaven"
    }
  }
  
  var method: Moya.Method {
    switch self {
    case .userPublic, .getAddress, .getBankInfo:
      return .get
    case .uploadImage, .saveUserProfile, .getUserInfo, .saveUserInfo, .saveWorkInfo, .getWorkInfo, .getContactInfo, .saveContactInfo, .saveBankInfo:
      return .post
    }
  }
  
  var headers: [String: String]? {
    switch self {
    case .uploadImage:
      return ["Content-Type": "multipart/form-data"]
    case .saveUserProfile, .getUserInfo, .saveWorkInfo, .getWorkInfo, .getContactInfo, .saveContactInfo, .saveBankInfo:
      return [
          "Content-Type": "application/x-www-form-urlencoded",
          "Accept": "application/json"
      ]
    default:
      return nil
    }
  }
  
  var task: Moya.Task {
    switch self {
    case let .saveUserInfo(dict):
      let params = getCommonParameters()
      
      return .requestCompositeParameters(
          bodyParameters: dict,
          bodyEncoding: URLEncoding.httpBody,
          urlParameters: params
      )
    case let .saveBankInfo(dict):
      let params = getCommonParameters()
      return .requestCompositeParameters(
          bodyParameters: dict,
          bodyEncoding: URLEncoding.httpBody,
          urlParameters: params
      )
    case let .saveContactInfo(feud, middle):
      let params = getCommonParameters()
      var bodyParams: [String: String] = [:]
      bodyParams["feud"] = feud
      bodyParams["middle"] = middle
      
      return .requestCompositeParameters(
        bodyParameters: bodyParams,
          bodyEncoding: URLEncoding.httpBody,
          urlParameters: params
      )
    case let .saveWorkInfo(dict):
      let params = getCommonParameters()
      
      return .requestCompositeParameters(
          bodyParameters: dict,
          bodyEncoding: URLEncoding.httpBody,
          urlParameters: params
      )
    case let .saveUserProfile(worry, away, bad, fun, shrug):
      let params = getCommonParameters()
      var bodyParams: [String: String] = [:]
      bodyParams["worry"] = worry
      bodyParams["away"] = away
      bodyParams["bad"] = bad
      bodyParams["fun"] = fun
      bodyParams["shrug"] = shrug
      bodyParams["mountainside"] = "11"
      
      return .requestCompositeParameters(
          bodyParameters: bodyParams,
          bodyEncoding: URLEncoding.httpBody,
          urlParameters: params
      )
    case .getAddress:
      let params = getCommonParameters()
      return .requestParameters(
          parameters: params,
          encoding: URLEncoding(destination: .queryString)
      )
      
    case .getBankInfo:
      var params = getCommonParameters()
      params["entrance"] = "0"
      params["godchild"] = String.generateUUID()
      return .requestParameters(
          parameters: params,
          encoding: URLEncoding(destination: .queryString)
      )
    case let .userPublic(feud, warm):
      var params = getCommonParameters()
      params["feud"] = feud
      params["warm"] = warm
      
      return .requestParameters(
          parameters: params,
          encoding: URLEncoding(destination: .queryString)
      )
    case let .getContactInfo(feud, pleasure):
      let params = getCommonParameters()
      var bodyParams: [String: String] = [:]
      bodyParams["feud"] = feud
      bodyParams["pleasure"] = pleasure
      
      return .requestCompositeParameters(
          bodyParameters: bodyParams,
          bodyEncoding: URLEncoding.httpBody,
          urlParameters: params
      )
    case let .getUserInfo(feud):
      let params = getCommonParameters()
      var bodyParams: [String: String] = [:]
      bodyParams["feud"] = feud
      
      return .requestCompositeParameters(
          bodyParameters: bodyParams,
          bodyEncoding: URLEncoding.httpBody,
          urlParameters: params
      )
      
    case let .getWorkInfo(feud):
      let params = getCommonParameters()
      var bodyParams: [String: String] = [:]
      bodyParams["feud"] = feud
      
      return .requestCompositeParameters(
          bodyParameters: bodyParams,
          bodyEncoding: URLEncoding.httpBody,
          urlParameters: params
      )
    case let .uploadImage(request):
      // URL 参数（公共参数）
      let urlParams = getCommonParameters()
      
      // 表单数据参数
      var formDataArray: [Moya.MultipartFormData] = []
      
      // 添加图片数据
      formDataArray.append(Moya.MultipartFormData(provider: .data(request.couldn),
                                                name: "couldn",
                                                fileName: "image.jpg",
                                                mimeType: "image/jpeg"))
      
      // 添加其他业务参数到表单
      if let data = String(request.hating).data(using: .utf8) {
          formDataArray.append(Moya.MultipartFormData(provider: .data(data), name: "hating"))
      }
      if let data = String(request.feud).data(using: .utf8) {
          formDataArray.append(Moya.MultipartFormData(provider: .data(data), name: "feud"))
      }
      if let data = String(request.mountainside).data(using: .utf8) {
          formDataArray.append(Moya.MultipartFormData(provider: .data(data), name: "mountainside"))
      }
      if let data = request.sleeping.data(using: .utf8) {
          formDataArray.append(Moya.MultipartFormData(provider: .data(data), name: "sleeping"))
      }
      if let data = request.fun.data(using: .utf8) {
          formDataArray.append(Moya.MultipartFormData(provider: .data(data), name: "fun"))
      }
      if let data = request.kpidays.data(using: .utf8) {
          formDataArray.append(Moya.MultipartFormData(provider: .data(data), name: "kpidays"))
      }
      if let data = request.kites.data(using: .utf8) {
          formDataArray.append(Moya.MultipartFormData(provider: .data(data), name: "kites"))
      }
      
      return .uploadCompositeMultipart(formDataArray, urlParameters: urlParams)
    }
  }
}
