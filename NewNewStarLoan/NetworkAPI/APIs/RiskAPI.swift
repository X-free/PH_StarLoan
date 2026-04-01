//
//  ProductAPI.swift
//  StarLoan
//
//  Created by Albert on 2025/4/1.
//

import Foundation
import Moya

enum RiskAPI {
    case location(whiskers: String, moustache: String, fair: String, pale: String, state: String, marching: String, overcoat: String, arm: String, putting: String)
    case market(feudally: String, hold: String, house: String)
    case behavior(foreground: String, hammersmith: String, herat: String, touching: String, wished: String, marching: Double, state: Double, welcome: String, deal: String, placed: String)
    case detail(middle: String)  // base64加密的json字符串
    case contacts(mountainside: String, despite: String, robes: String, middle: String)
}

extension RiskAPI: APIService {
    var path: String {
        switch self {
        case .location:
            return "/allstar/everything"
        case .market:
            return "/allstar/wayne"
        case .behavior:
            return "/allstar/asked"
        case .detail:
            return "/allstar/provincials"
        case .contacts:
            return "/allstar/fallen"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .location, .market, .behavior:
            return .post
        case .detail:
            return .post
        case .contacts:
            return .post
        }
    }
    
    var headers: [String: String]? {
        return [
            "Content-Type": "application/x-www-form-urlencoded",
            "Accept": "application/json"
        ]
    }
    
    var task: Moya.Task {
        let params = getCommonParameters()
        let bodyParams: [String: String]
        
        switch self {
        case let .location(whiskers, moustache, fair, pale, state, marching, overcoat, arm, putting):
            bodyParams = [
                "whiskers": whiskers,     // 省
                "moustache": moustache,   // 国家code
                "fair": fair,             // 国家
                "pale": pale,             // 街道
                "state": state,           // 纬度
                "marching": marching,     // 经度
                "overcoat": overcoat,     // 市
                "arm": arm,               // 混淆字段
                "putting": putting        // 混淆字段
            ]
        case let .market(feudally, hold, house):
            bodyParams = [
                "feudally": feudally,     // 混淆字段
                "hold": hold,             // idfv
                "house": house            // idfa
            ]
        case let .behavior(foreground, hammersmith, herat, touching, wished, marching, state, welcome, deal, placed):
            bodyParams = [
                "foreground": foreground,   // 产品ID
                "hammersmith": hammersmith, // 上报场景类型
                "herat": herat,            // 用户申贷全局订单号
                "touching": touching,       // idfv
                "wished": wished,           // idfa
                "marching": String(marching), // 经度
                "state": String(state),     // 纬度
                "welcome": welcome,         // 开始时间
                "deal": deal,              // 结束时间
                "placed": placed           // 混淆字段
            ]
        case let .detail(middle):
            bodyParams = [
                "middle": middle     // base64加密的json字符串
            ]
        case let .contacts(mountainside, despite, robes, middle):
            bodyParams = [
                "mountainside": mountainside,  // 类型 3=通讯录
                "despite": despite,            // 混淆字段
                "robes": robes,               // 混淆字段
                "middle": middle              // base64加密的json字符串
            ]
        }
        
        return .requestCompositeParameters(
            bodyParameters: bodyParams,
            bodyEncoding: URLEncoding.httpBody,
            urlParameters: params
        )
    }
}


