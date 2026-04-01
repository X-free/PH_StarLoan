//
//  MaidianRistManager.swift
//  NewNewStarLoan
//
//  Created by apple1 on 2025/7/7.
//

import Foundation
import CoreLocation
import AdSupport
import UIKit

class MaidianRistManager: NSObject {
  static let manager = MaidianRistManager()
  
  private override init() {
    super.init()
    locaManager.delegate = self
  }
  
  let locaManager = CLLocationManager()
  
  /// - Parameters:
  ///   - foreground: 产品ID
  ///   - hammersmith: 上报场景类型
  ///   - welcome: 开始时间
  ///   - deal: 结束时间
  func upload(foreground: String,
              hammersmith: String,
              welcome: String,
              deal: String) {
    locaManager.startUpdatingLocation()
    
    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3)) {
      Task {
        let lat = UserDefaults.standard.value(forKey: "location_latitude") as? Double ?? 0
        let long = UserDefaults.standard.value(forKey: "location_longitude") as? Double ?? 0
        
        let manager = SomeIdentifierManager()
        let idfv = manager.fetchIDFV() ?? ""
        debugPrint("埋点 \(hammersmith) 上报成功")
        
        let backda = try await RiskService.shared.behavior(
            foreground: foreground,  // 产品ID
            hammersmith: hammersmith,
            herat: "",                                           // 空字符串
            touching: idfv,
            wished: ASIdentifierManager.shared().advertisingIdentifier.uuidString,               // idfa
            marching: long,     // 经度
            state: lat,         // 纬度
            welcome: welcome,// 开始时间
            deal: deal,     // 结束时间
            placed: String.generateUUID()
        )
        
        
      }
    }
  }
}

extension MaidianRistManager: CLLocationManagerDelegate {
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    if let lo = locations.first {
      let coo = lo.coordinate
      UserDefaults.standard.setValue(coo.latitude, forKey: "location_latitude")
      UserDefaults.standard.setValue(coo.longitude, forKey: "location_longitude")
    }
    manager.stopUpdatingLocation()
    
    
    let startTime = UserDefaults.standard.integer(forKey: "registerStartTime")
    let endTime = UserDefaults.standard.integer(forKey: "registerEndTime")
    
    if startTime == 0 || endTime == 0 {
      return
    }
    
    self.upload(foreground: "", hammersmith: "1", welcome: "\(startTime)", deal: "\(endTime)")
    
    UserDefaults.standard.removeObject(forKey: "registerStartTime")
    UserDefaults.standard.removeObject(forKey: "registerEndTime")
    UserDefaults.standard.synchronize()
  }
}


class LoactionUpDataManager: NSObject {
  static let manager = LoactionUpDataManager()
  
  private override init() {
    super.init()
    locaManager.delegate = self
  }
  
  let locaManager = CLLocationManager()
      
  func startUpLocation() {
    locaManager.startUpdatingLocation()
  }
  
  /// - Parameters:
  ///   - whiskers: 省
  ///   - moustache: 国家代码
  ///   - fair: 国家
  ///   - pale: 街道
  ///   - state: 维度
  ///   - marching: 经度
  ///   - overcoat: 市
  private func upLocationData(whiskers: String,
                      moustache: String,
                      fair: String,
                      pale: String,
                      state: String,
                      marching: String,
                      overcoat: String) {
    Task {
      try await RiskService.shared.location(
        whiskers: whiskers,     // 省
        moustache: moustache,   // 国家代码
        fair: fair,             // 国家
        pale: pale,             // 街道
        state: state,           // 纬度
        marching: marching,     // 经度
        overcoat: overcoat,     // 市
        arm: "armdata",                             // 可选参数
        putting: "putme"                          // 可选参数
      )
    }
  }
}

extension LoactionUpDataManager: CLLocationManagerDelegate {
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    manager.stopUpdatingLocation()
    if let lo = locations.first {
      let coo = lo.coordinate
      UserDefaults.standard.setValue(coo.latitude, forKey: "location_latitude")
      UserDefaults.standard.setValue(coo.longitude, forKey: "location_longitude")
      
      CLGeocoder().reverseGeocodeLocation(lo) { placess, _ in
        guard let plac = placess?.first else {
          return
        }
        
        self.upLocationData(whiskers: plac.administrativeArea ?? "",
                            moustache: plac.isoCountryCode ?? "",
                            fair: plac.country ?? "",
                            pale: plac.thoroughfare ?? "''",
                            state: "\(coo.latitude)",
                            marching: "\(coo.longitude)",
                            overcoat: plac.locality ?? "")
        
      }
    }
  }
}
