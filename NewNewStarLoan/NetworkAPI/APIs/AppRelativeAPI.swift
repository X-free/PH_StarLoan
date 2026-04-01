//
//  AppRelativeAPI.swift
//  StarLoan
//
//  Created by Albert on 2025/4/1.
//

import Foundation
import Moya

enum AppRelativeAPI {
    case homePage(trucks: String, multicolored: String)
}

extension AppRelativeAPI: APIService {
    var path: String {
        switch self {
        case .homePage:
            return "/allstar/course"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .homePage:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case let .homePage(trucks, multicolored):
            var params = getCommonParameters()
            params["trucks"] = trucks
            params["multicolored"] = multicolored
            
            return .requestParameters(
                parameters: params,
                encoding: URLEncoding(destination: .queryString)
            )
        }
    }
}

