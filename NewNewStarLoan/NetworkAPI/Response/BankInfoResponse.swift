import Foundation


struct BankInfoResponse: Codable {
    let hundred: String
    let seats: String
    let middle: BankMiddle
  
  struct BankMiddle: Codable {
      let stopped: [BankType]
    
    struct BankType: Codable {
        let studied: String
        let stopped: [BankItem]
        let mountainside: Int
    }

    struct BankItem: Codable {
        let dozen: Int
        let homayoun: String
        let lines: [BankLine]
        let mentioned: String
        let once: String
        let hundred: String
        let followerske: Int
        let mazreez: String
        let neighbourhood: Int
        let studied: String
        let particular: String
        let mountainside: String
        let actually: Int
    }

    struct BankLine: Codable {
        let bad: String
        let fantastic: String
        let mountainside: AnyCodable
    }
    
    enum AnyCodable: Codable {
        case string(String)
        case int(Int)
        
        init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            if let stringValue = try? container.decode(String.self) {
                self = .string(stringValue)
            } else if let intValue = try? container.decode(Int.self) {
                self = .int(intValue)
            } else {
                throw DecodingError.typeMismatch(
                    AnyCodable.self,
                    DecodingError.Context(
                        codingPath: decoder.codingPath,
                        debugDescription: "Expected String or Int"
                    )
                )
            }
        }
        
        func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            switch self {
            case .string(let value): try container.encode(value)
            case .int(let value): try container.encode(value)
            }
        }
        
        var stringValue: String {
            switch self {
            case .string(let value): return value
            case .int(let value): return String(value)
            }
        }
    }
  }
}


extension BankInfoResponse.BankMiddle.BankLine: BadDisplayable {}
