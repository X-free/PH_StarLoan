//
//  ProductAPI.swift
//  StarLoan
//
//  Created by Albert on 2025/4/1.
//

import Foundation
import Moya

enum ProductAPI {
    case apply(feud: String, bit: String, invited: String)
    case detail(feud: String, staying: String, since: String)
}

extension ProductAPI: APIService {
    var path: String {
        switch self {
        case .apply:
            return "/allstar/sidethen"
        case .detail:
            return "/allstar/apostle"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .apply, .detail:
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
        case let .apply(feud, bit, invited):
            bodyParams = [
                "feud": feud,
                "bit": bit,
                "invited": invited
            ]
        case let .detail(feud, staying, since):
            bodyParams = [
                "feud": feud,
                "staying": staying,
                "since": since
            ]
        }
        
        return .requestCompositeParameters(
            bodyParameters: bodyParams,
            bodyEncoding: URLEncoding.httpBody,
            urlParameters: params
        )
    }
}


