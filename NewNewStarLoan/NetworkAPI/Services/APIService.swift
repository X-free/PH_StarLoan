//
//  APIService.swift
//  StarLoan
//
//  Created by Albert on 2025/4/1.
//

import Foundation
import Moya
import Combine

protocol APIService: TargetType { }

extension APIService {
    var baseURL: URL {
        return URL(string: APIConfig.baseURL)!
    }
    
    var headers: [String: String]? {
        return [
            "Content-Type": "application/x-www-form-urlencoded",
            "Accept": "application/json"
        ]
    }
        
    func getCommonParameters() -> [String: String] {
        let deviceInfo = DeviceInfo.current
        return [
            "assure": "iOS",
            "solemnly": Bundle.main.version,
            "sense": deviceInfo.model,
            "give": deviceInfo.identifier,
            "uncanny": deviceInfo.systemVersion,
            "curse": "starloanapi",
            "hypnotised": UserDefaults.standard.string(forKey: "sessionId") ?? "",
            "turned": deviceInfo.identifier,
            "boyfine": String.generateUUID()
        ]
    }
}

// 基础请求方法封装
extension MoyaProvider {
    func asyncRequest(_ target: Target) async throws -> Response {
        return try await withCheckedThrowingContinuation { continuation in
            self.request(target) { result in
                switch result {
                case let .success(response):
                    // 解析响应数据
                    do {
                        if let json = try response.mapJSON() as? [String: Any],
                           let hundred = json["hundred"] as? String,
                           hundred == "-2" {
                          UserDefaults.standard.removeObject(forKey: "phoneNumber")
                          UserDefaults.standard.removeObject(forKey: "sessionId")
                            // 处理 hundred = -2 的情况
                          if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                                 let sceneDelegate = windowScene.delegate as? SceneDelegate {
                                  sceneDelegate.showLoginViewController {
                                      // 登录完成后的回调
                                  }
                              }
                            continuation.resume(throwing: NSError(domain: "APIError", code: -2, userInfo: [NSLocalizedDescriptionKey: "Session expired"]))
                            return
                        }
                    } catch {
                        print("Response parsing error: \(error)")
                    }
//                    continuation.resume(returning: response)
                  continuation.resume(throwing: NSError(domain: "APIError", code: -2, userInfo: [NSLocalizedDescriptionKey: "Session expired"]))

                case let .failure(error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    func requestPublisher(_ target: Target) -> AnyPublisher<Response, MoyaError> {
        Future { promise in
            self.request(target) { result in
                switch result {
                case .success(let response):
                    promise(.success(response))
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}

// 设备信息封装
struct DeviceInfo {
    let model: String
    let identifier: String
    let systemVersion: String
    
    static var current: DeviceInfo {
        DeviceInfo(
            model: UIDevice.current.model,
            identifier: SomeIdentifierManager().fetchIDFVFromKeychain() ?? "",
            systemVersion: UIDevice.current.systemVersion
        )
    }
}

// Bundle 扩展
extension Bundle {
    var version: String {
        return infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0"
    }
}
