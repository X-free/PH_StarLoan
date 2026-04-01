import Foundation

struct AuthFaceRecognizeResponse: Codable {
  let hundred: String
  let seats: String
  let middle: MiddleInfo
  
  struct MiddleInfo: Codable {

    let wedneskpiday: WedneskpidayInfo
    
    struct WedneskpidayInfo: Codable {
      let cousin: String
      let trade: String
      let studied: String
      let mountainside: Int
    }
  }
}
