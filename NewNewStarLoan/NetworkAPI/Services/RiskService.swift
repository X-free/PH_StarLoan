//
//  RiskService.swift
//  NewNewStarLoan
//
//  Created by Albert on 2025/5/22.
//


import Foundation
import Moya

class RiskService {
    static let shared = RiskService()
    private init() {}
    
    private let provider = MoyaProvider<RiskAPI>(plugins: [NetworkLoggerPlugin(configuration: .init(formatter: .init(responseData: NetworkFormatter.formatJSONResponse),
                                                                                                 logOptions: .verbose))])
  

    
    /// 上报位置信息
    func location(
        whiskers: String,
        moustache: String,
        fair: String,
        pale: String,
        state: String,
        marching: String,
        overcoat: String,
        arm: String,
        putting: String
    ) async throws -> BaseResponse {
        let response = try await provider.asyncRequest(.location(
            whiskers: whiskers,
            moustache: moustache,
            fair: fair,
            pale: pale,
            state: state,
            marching: marching,
            overcoat: overcoat,
            arm: arm,
            putting: putting
        ))
        let decoder = JSONDecoder()
        return try decoder.decode(BaseResponse.self, from: response.data)
    }
    
    /// 上报设备基本信息
    func market(
        feudally: String,
        hold: String,
        house: String
    ) async throws -> FaceBookResponse {
        let response = try await provider.asyncRequest(.market(
            feudally: feudally,
            hold: hold,
            house: house
        ))
        let decoder = JSONDecoder()
        return try decoder.decode(FaceBookResponse.self, from: response.data)
    }
    
    /// 上报设备详细信息
    func detail(
        middle: String
    ) async throws -> BaseResponse {
        let response = try await provider.asyncRequest(.detail(middle: middle))
        let decoder = JSONDecoder()
        return try decoder.decode(BaseResponse.self, from: response.data)
    }
    
    /// 上报用户行为
    func behavior(
        foreground: String,
        hammersmith: String,
        herat: String,
        touching: String,
        wished: String,
        marching: Double,
        state: Double,
        welcome: String,
        deal: String,
        placed: String
    ) async throws -> BaseResponse {
        // 检查经纬度是否为0值，如果是则抛出错误
        if abs(marching) < Double.ulpOfOne && abs(state) < Double.ulpOfOne {
            throw NSError(domain: "RiskService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Location coordinates cannot be zero"])
        }
        
        let response = try await provider.asyncRequest(.behavior(
            foreground: foreground,
            hammersmith: hammersmith,
            herat: herat,
            touching: touching,
            wished: wished,
            marching: marching,
            state: state,
            welcome: welcome,
            deal: deal,
            placed: placed
        ))
        let decoder = JSONDecoder()
        return try decoder.decode(BaseResponse.self, from: response.data)
    }
    
    /// 上报通讯录信息
    func contacts(
        mountainside: String,
        despite: String,
        robes: String,
        middle: String
    ) async throws -> BaseResponse {
        let response = try await provider.asyncRequest(.contacts(
            mountainside: mountainside,
            despite: despite,
            robes: robes,
            middle: middle
        ))
        let decoder = JSONDecoder()
        return try decoder.decode(BaseResponse.self, from: response.data)
    }
}
