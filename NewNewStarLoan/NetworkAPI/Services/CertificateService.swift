//
//  CertificateService.swift
//  StarLoan
//
//  Created by Albert on 2025/4/2.
//

import Foundation
import Moya
import Combine
import Alamofire

class CertificateService {
  static let shared = CertificateService()
  
  private let provider = MoyaProvider<CertificateAPI>(plugins: [NetworkLoggerPlugin(configuration: .init(formatter: .init(responseData: NetworkFormatter.formatJSONResponse),
                                                                                              logOptions: .verbose))])
  
  private init() {}
  
  func getUserPublicInfo(feud: String, warm: String) async throws -> CertificateFirstResponse {
    let response = try await provider.asyncRequest(.userPublic(feud: feud, warm: warm))
    let decoder = JSONDecoder()
    
    // 先解码成 BaseResponse
    let baseResponse = try decoder.decode(BaseResponse.self, from: response.data)
    
    // 检查基础响应状态
    guard baseResponse.hundred == "0" else {
        throw NSError(domain: "API", code: -1, userInfo: [NSLocalizedDescriptionKey: baseResponse.seats])
    }
    
    // 重新解码完整响应
    return try decoder.decode(CertificateFirstResponse.self, from: response.data)
  }
  
  func uploadImage(_ request: UploadImageModel) async throws -> Data {
    let response = try await provider.asyncRequest(.uploadImage(request: request))
    let decoder = JSONDecoder()
    
    // 先解码成 BaseResponse
    let baseResponse = try decoder.decode(BaseResponse.self, from: response.data)
    
    // 检查基础响应状态
    guard baseResponse.hundred == "0" else {
        throw NSError(domain: "API", code: -1, userInfo: [NSLocalizedDescriptionKey: baseResponse.seats])
    }
    
    return response.data
  }
  
  func saveUserInfo(dict: [String: String]) async throws -> AuthPersoanlInfoResponse {
    let response = try await provider.asyncRequest(.saveUserInfo(dict: dict))
    let decoder = JSONDecoder()
    // 解码成 BaseResponse
    let baseResponse = try decoder.decode(BaseResponse.self, from: response.data)
    
    // 检查基础响应状态
    guard baseResponse.hundred == "0" else {
        throw NSError(domain: "API", code: -1, userInfo: [NSLocalizedDescriptionKey: baseResponse.seats])
    }
    
    // 重新解码完整响应
    return try decoder.decode(AuthPersoanlInfoResponse.self, from: response.data)
  }
  
  func saveWorkInfo(dict: [String: String]) async throws -> AuthWorkInfoResponse {
    let response = try await provider.asyncRequest(.saveWorkInfo(dict: dict))
    let decoder = JSONDecoder()
    // 解码成 BaseResponse
    let baseResponse = try decoder.decode(BaseResponse.self, from: response.data)
    
    // 检查基础响应状态
    guard baseResponse.hundred == "0" else {
      throw NSError(domain: "API", code: -1, userInfo: [NSLocalizedDescriptionKey: baseResponse.seats])
    }
    return try decoder.decode(AuthWorkInfoResponse.self, from: response.data)
  }

  func getContactInfo(feud: String) async throws -> GetContactInfoResponse {
    let response = try await provider.asyncRequest(.getContactInfo(feud: feud, pleasure: String.generateUUID()))
    let decoder = JSONDecoder()
    let baseResponse = try decoder.decode(BaseResponse.self, from: response.data)
    
    // 检查基础响应状态
    guard baseResponse.hundred == "0" else {
      throw NSError(domain: "API", code: -1, userInfo: [NSLocalizedDescriptionKey: baseResponse.seats])
    }
    return try decoder.decode(GetContactInfoResponse.self, from: response.data)
  }

  
  func saveUserProfileRequest(worry: String, away: String, bad: String, fun: String, strug: String) async throws -> BaseResponse {
    let response = try await provider.asyncRequest(.saveUserProfile(worry: worry, away: away, bad: bad, fun: fun, shrug: strug))
    let decoder = JSONDecoder()
    
    // 解码成 BaseResponse
    let baseResponse = try decoder.decode(BaseResponse.self, from: response.data)
    
    // 检查基础响应状态
    guard baseResponse.hundred == "0" else {
        throw NSError(domain: "API", code: -1, userInfo: [NSLocalizedDescriptionKey: baseResponse.seats])
    }
    
    return baseResponse
  }
  
  func getUserInfo(feud: String) async throws -> GetUserInfoResponse {
    let response = try await provider.asyncRequest(.getUserInfo(feud: feud))
    let decoder = JSONDecoder()
    
    // 先解码成 BaseResponse
    let baseResponse = try decoder.decode(BaseResponse.self, from: response.data)
    
    // 检查基础响应状态
    guard baseResponse.hundred == "0" else {
        throw NSError(domain: "API", code: -1, userInfo: [NSLocalizedDescriptionKey: baseResponse.seats])
    }
    
    // 重新解码完整响应
    return try decoder.decode(GetUserInfoResponse.self, from: response.data)
  }
  
  func getWorkInfo(feud: String) async throws -> GetWorkInfoResponse {
    let response = try await provider.asyncRequest(.getWorkInfo(feud: feud))
    let decoder = JSONDecoder()
    
    // 先解码成 BaseResponse
    let baseResponse = try decoder.decode(BaseResponse.self, from: response.data)
    
    // 检查基础响应状态
    guard baseResponse.hundred == "0" else {
        throw NSError(domain: "API", code: -1, userInfo: [NSLocalizedDescriptionKey: baseResponse.seats])
    }
    
    // 重新解码完整响应
    return try decoder.decode(GetWorkInfoResponse.self, from: response.data)
  }
  
  func getAddress() async throws -> AddressResponse {
    let response = try await provider.asyncRequest(.getAddress)
    let decoder = JSONDecoder()
    
    // 先解码成 BaseResponse
    let baseResponse = try decoder.decode(BaseResponse.self, from: response.data)
    
    // 检查基础响应状态
    guard baseResponse.hundred == "0" else {
        throw NSError(domain: "API", code: -1, userInfo: [NSLocalizedDescriptionKey: baseResponse.seats])
    }
    
    // 重新解码完整响应
    return try decoder.decode(AddressResponse.self, from: response.data)
  }
  
  func saveContactInfo(feud: String, middle: String) async throws -> AuthContactInfoResponse {
    let response = try await provider.asyncRequest(.saveContactInfo(feud: feud, middle: middle))
    let decoder = JSONDecoder()
    
    // 先解码成 BaseResponse
    let baseResponse = try decoder.decode(BaseResponse.self, from: response.data)
    
    // 检查基础响应状态
    guard baseResponse.hundred == "0" else {
        throw NSError(domain: "API", code: -1, userInfo: [NSLocalizedDescriptionKey: baseResponse.seats])
    }
    
    // 重新解码完整响应
    return try decoder.decode(AuthContactInfoResponse.self, from: response.data)
  }
  
  func getBankCardInfo() async throws -> BankInfoResponse {
    let response = try await provider.asyncRequest(.getBankInfo)
    let decoder = JSONDecoder()
    
    // 先解码成 BaseResponse
    let baseResponse = try decoder.decode(BaseResponse.self, from: response.data)
    
    // 检查基础响应状态
    guard baseResponse.hundred == "0" else {
        throw NSError(domain: "API", code: -1, userInfo: [NSLocalizedDescriptionKey: baseResponse.seats])
    }
    
    // 重新解码完整响应
    return try decoder.decode(BankInfoResponse.self, from: response.data)
  }
  
  func saveBankCardInfo(dict: [String: String]) async throws -> AuthBankInfoResponse {
    let response = try await provider.asyncRequest(.saveBankInfo(dict: dict))
    let decoder = JSONDecoder()
    
    // 先解码成 BaseResponse
    let baseResponse = try decoder.decode(BaseResponse.self, from: response.data)
    
    // 检查基础响应状态
    guard baseResponse.hundred == "0" else {
        throw NSError(domain: "API", code: -1, userInfo: [NSLocalizedDescriptionKey: baseResponse.seats])
    }
    
    // 重新解码完整响应
    return try decoder.decode(AuthBankInfoResponse.self, from: response.data)
  }
}


struct UploadImageModel {
    let hating: Int
    let feud: Int
    let mountainside: Int
    let couldn: Data
    let fun: String
    let kpidays: String
    let kites: String
    let sleeping: String
}


class AddressManager {
  static let shared = AddressManager()
  private let userDefaults = UserDefaults.standard
  private let addressKey = "cached_address_data"
  
  private init() {}
  
  func getAddress() async throws -> AddressResponse {
    // 尝试从本地获取缓存的数据
    if let cachedData = userDefaults.data(forKey: addressKey),
       let cachedAddress = try? JSONDecoder().decode(AddressResponse.self, from: cachedData) {
      return cachedAddress
    }
    
    // 如果本地没有数据，从网络获取
    let address = try await CertificateService.shared.getAddress()
    
    // 缓存到本地
    if let encodedData = try? JSONEncoder().encode(address) {
      userDefaults.set(encodedData, forKey: addressKey)
    }
    
    return address
  }
  
  func clearCache() {
    userDefaults.removeObject(forKey: addressKey)
  }
}


import Foundation
import Moya
import Combine

class BaseService<T: TargetType> {
    let provider: MoyaProvider<T>
    
    init(plugins: [PluginType] = []) {
        let defaultPlugins: [PluginType] = [
            NetworkLoggerPlugin(configuration: .init(
                formatter: .init(responseData: NetworkFormatter.formatJSONResponse),
                logOptions: .verbose
            ))
        ]
        
        self.provider = MoyaProvider<T>(plugins: defaultPlugins + plugins)
    }
    
    // 基础请求方法，处理通用的错误和响应解码
    func request<D: Decodable>(_ target: T, type: D.Type) async throws -> D {
        let response = try await provider.asyncRequest(target)
        let decoder = JSONDecoder()
        
        // 先尝试解码基础响应
        let baseResponse = try decoder.decode(BaseResponse.self, from: response.data)
        
        // 检查基础响应状态
        guard baseResponse.hundred == "0" else {
            throw NSError(domain: "API",
                        code: -1,
                        userInfo: [NSLocalizedDescriptionKey: baseResponse.seats])
        }
        
        // 解码完整响应
        return try decoder.decode(type, from: response.data)
    }
    
    // 处理不需要特定返回类型的请求
    func request(_ target: T) async throws -> BaseResponse {
        return try await request(target, type: BaseResponse.self)
    }
}
