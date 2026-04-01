import Foundation
import Moya

class AuthService: BaseService<AuthAPI> {
    static let shared = AuthService()
    
    private override init(plugins: [PluginType] = []) {
        super.init(plugins: plugins)
    }
    
    func getVerificationCode(sky: String, kites: String) async throws -> BaseResponse {
        return try await request(.getCode(sky: sky, kites: kites))
    }
    
    func login(smiling: String, wheel: String, poked: String, clean: String, swallow: String, mouth: String) async throws -> LoginResponse {
        let result = try await request(.login(smiling: smiling, wheel: wheel, poked: poked, clean: clean, swallow: swallow, mouth: mouth), type: LoginResponse.self)
        
        // 保存 sessionId
        UserDefaults.standard.set(result.middle.hypnotised, forKey: "sessionId")
        UserDefaults.standard.set(smiling, forKey: "phoneNumber")
        UserDefaults.standard.synchronize()
        
        return result
    }
    
    func logout() async throws -> BaseResponse {
        let result = try await request(.logout)
        
        // 清除用户数据
        UserDefaults.standard.removeObject(forKey: "sessionId")
        UserDefaults.standard.removeObject(forKey: "phoneNumber")
        UserDefaults.standard.synchronize()
        
        return result
    }
  
  func cancelAccount() async throws -> BaseResponse {
    let result = try await request(.cancelAccount)
    
    // 清除用户数据
    UserDefaults.standard.removeObject(forKey: "sessionId")
    UserDefaults.standard.removeObject(forKey: "phoneNumber")
    UserDefaults.standard.synchronize()
    
    return result
  }
}

extension AuthService {
  static func isLogin() -> Bool {
    return UserDefaults.standard.string(forKey: "sessionId") != nil 
  }
}
