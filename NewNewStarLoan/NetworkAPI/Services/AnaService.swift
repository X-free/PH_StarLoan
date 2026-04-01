//
//  AnaService.swift
//  NewNewStarLoan
//
//  Created by Albert on 2025/5/22.
//

import Foundation
import CoreLocation

// MARK: - Analytics Event Type
enum AnaServiceEvent: Int, CaseIterable {
    case registerLogin = 1
    case chooseId
    case chooseIdFront
    case chooseIdRecognize
    case personalInfo
    case workInfo
    case extInfo
    case bankInfo
    case jumpOrder
    case confirmLoan
}

// MARK: - Analytics Event
struct AnaEvent {
    let type: AnaServiceEvent
    let startTime: Int
  var endTime: Int? = 0
    var additionalParams: [String: Any]
    var location: CLLocation?
    
    init(type: AnaServiceEvent, additionalParams: [String: Any] = [:]) {
        self.type = type
        self.startTime = Int(Date().timeIntervalSince1970)
        self.additionalParams = additionalParams
    }
  
  mutating func recordEndTime() {
    self.endTime = Int(Date().timeIntervalSince1970)
  }
}

class AnalyticsService {
    private lazy var locationService = LocationUpdateService()
    var currentEvent: AnaEvent?
    
    // 开始追踪特定类型的事件
    func startTracking(_ type: AnaServiceEvent, additionalParams: [String: Any] = [:]) {
        currentEvent = AnaEvent(type: type, additionalParams: additionalParams)
        
    }
  
  func endTracking() {
    currentEvent?.recordEndTime()
  }
    
    func prepareEventData() async throws -> [String: Any] {
        guard var event = currentEvent else {
            throw NSError(domain: "AnalyticsService", code: -1, userInfo: [NSLocalizedDescriptionKey: "没有正在追踪的事件"])
        }
        
        // 先记录结束时间
//        let endTime = Int(Date().timeIntervalSince1970) - 3
        
//        // 获取位置信
//        let location = try await locationService.getCurrentLocation()
//        event.location = location
        
        // 构建埋点数据，使用之前记录的结束时间
        var analyticsData: [String: Any] = [
            "event_type": String(describing: event.type),
            "start_time": event.startTime,
            "end_time": event.endTime ?? 0  // 使用预先记录的结束时间
        ]
        
        if let location = event.location {
            analyticsData["latitude"] = location.coordinate.latitude
            analyticsData["longitude"] = location.coordinate.longitude
        }
      
      let defaults = UserDefaults.standard
      analyticsData["latitude"] = defaults.double(forKey: UserDefaultsKeys.latitude)
      analyticsData["longitude"] = defaults.double(forKey: UserDefaultsKeys.longitude)
        
        for (key, value) in event.additionalParams {
            analyticsData[key] = value
        }
        
        
        currentEvent = nil
        
        return analyticsData
    }
}

extension AnalyticsService {
    func prepareEventData(type: AnaServiceEvent,
                          startTime: Int,
                          endTime: Int,
                          additionalParams: [String: Any] = [:]) async throws -> [String: Any] {
        // 获取位置信息
//      let locationService = LocationUpdateService()
//        let location = try await locationService.getLocation()
                
        // 构建必需的核心参数
        var analyticsData: [String: Any] = [
            "event_type": String(describing: type),
            "start_time": startTime,
            "end_time": endTime
        ]
        
        // 添加位置信息
      let defaults = UserDefaults.standard
      analyticsData["latitude"] = defaults.double(forKey: UserDefaultsKeys.latitude)
      analyticsData["longitude"] = defaults.double(forKey: UserDefaultsKeys.longitude)
        // 把额外参数添加到核心参数后面
        for (key, value) in additionalParams {
            analyticsData[key] = value
        }
        analyticsData["product_id"] = "2"
        return analyticsData
    }
  
  
}
