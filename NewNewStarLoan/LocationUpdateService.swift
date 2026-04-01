//
//  LocationUpdateService.swift
//  NewNewStarLoan
//
//  Created by Albert on 2025/5/19.
//
import UIKit
import Foundation
import CoreLocation
import AdSupport

// MARK: - 错误类型定义
enum LocationError: Error {
    case unauthorized
    case timeout
    case noSavedLocation
    case unknown(Error)
}

// MARK: - 位置服务类
// 添加 LocationUploadInfo 结构体定义
struct LocationGeo {
    let whiskers: String    // 省
    let moustache: String   // 国家代码
    let fair: String        // 国家
    let pale: String        // 街道
    let state: String       // 纬度
    let marching: String    // 经度
    let overcoat: String    // 市
    let arm: String         // 可选参数
    let putting: String     // 可选参数
}

// MARK: - UserDefaults Keys
enum UserDefaultsKeys {
    static let latitude = "location_latitude"
    static let longitude = "location_longitude"
}

final class LocationUpdateService: NSObject {
    private var permissionCompletion: ((Bool) -> Void)?
    private var isFirstRequest = false
    

    
    // MARK: - 配置
    struct Configuration {
        let timeout: TimeInterval
        let desiredAccuracy: CLLocationAccuracy
        let roundingPrecision: Double
        
        static let `default` = Configuration(
            timeout: 10.0,
            desiredAccuracy: kCLLocationAccuracyBest,
            roundingPrecision: 1_000_000_000_000_000
        )
    }
    
    // MARK: - 属性
    private let locationManager = CLLocationManager()
    private var locationPromise: ((Result<CLLocation, LocationError>) -> Void)?
    private var currentContinuation: CheckedContinuation<CLLocation, Error>?
    private var timeoutWorkItem: DispatchWorkItem?
    private let config: Configuration
    private var isCompleted = false
    
    // MARK: - 初始化方法
    init(configuration: Configuration = .default) {
        self.config = configuration
        super.init()
        setupLocationManager()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 公共方法
    func getCurrentLocation() async throws -> CLLocation {
        return try await withCheckedThrowingContinuation { [weak self] continuation in
            // 使用串行队列确保线程安全
            DispatchQueue.main.async { [weak self] in
                guard let self = self else {
                    continuation.resume(throwing: LocationError.unknown(NSError(domain: "LocationService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Service deallocated"])))
                    return
                }
              
              
              let strongSelf = self

              // 防御：如果上一次未清理，强制抛错清理
              if let previous = strongSelf.currentContinuation {
//                  previous.resume(throwing: LocationError.unknown)
              }

              strongSelf.currentContinuation = continuation
              strongSelf.locationManager.requestLocation()
                
                // 检查权限状态
                let authStatus: CLAuthorizationStatus
                if #available(iOS 14.0, *) {
                    authStatus = self.locationManager.authorizationStatus
                } else {
                    authStatus = CLLocationManager.authorizationStatus()
                }
                
                switch authStatus {
                case .notDetermined:
                    // 权限未确定，直接返回未授权错误
                    continuation.resume(throwing: LocationError.unauthorized)
                    return
                    
                case .denied, .restricted:
                    // 权限被拒绝或受限
                    continuation.resume(throwing: LocationError.unauthorized)
                    return
                    
                case .authorizedWhenInUse, .authorizedAlways:
                    // 已授权，继续请求位置
                    break
                    
                @unknown default:
                    continuation.resume(throwing: LocationError.unauthorized)
                    return
                }
                
                // 权限已授权，请求位置
                self.requestLocation { result in
                    switch result {
                    case .success(let location):
                        continuation.resume(returning: location)
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    }
                }
            }
        }
    }
    
    func checkLocationPermission(from viewController: UIViewController?, completion: @escaping (Bool) -> Void) {
        // 存储回调
        permissionCompletion = completion
        
        let authStatus: CLAuthorizationStatus
        if #available(iOS 14.0, *) {
            authStatus = locationManager.authorizationStatus
        } else {
            authStatus = CLLocationManager.authorizationStatus()
        }
        
        handleAuthorizationStatus(authStatus)
    }
    
    private func handleAuthorizationStatus(_ status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            // 首次请求权限
            isFirstRequest = true
            locationManager.requestWhenInUseAuthorization()
            
        case .authorizedWhenInUse, .authorizedAlways:
            // 已授权
            permissionCompletion?(true)
            permissionCompletion = nil
            
        case .restricted, .denied:
            // 未授权
            permissionCompletion?(false)
            permissionCompletion = nil
            
        @unknown default:
            permissionCompletion?(false)
            permissionCompletion = nil
        }
    }
    
    // MARK: - 私有方法
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = config.desiredAccuracy
      
      // 添加这一行，确保每次只请求一次位置
      locationManager.pausesLocationUpdatesAutomatically = true
    }
    
    private func requestLocation(completion: @escaping (Result<CLLocation, LocationError>) -> Void) {
        // 确保在主线程执行
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {
                completion(.failure(.unknown(NSError(domain: "LocationService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Service deallocated"]))))
                return
            }
            
            // 检查是否已经有请求在进行
            if self.locationPromise != nil {
                completion(.failure(.unknown(NSError(domain: "LocationService", code: -2, userInfo: [NSLocalizedDescriptionKey: "Another location request is in progress"]))))
                return
            }
            
            self.isCompleted = false
            self.locationPromise = completion
            
            // 使用 requestLocation 替代 startUpdatingLocation
            self.locationManager.requestLocation()
            
            self.setupTimeout()
        }
    }
    
    private func setupTimeout() {
        let workItem = DispatchWorkItem { [weak self] in
            self?.handleTimeout()
        }
        timeoutWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + config.timeout, execute: workItem)
    }
    
    private func handleTimeout() {
        guard !isCompleted else { return }
        cleanupResources()
        
        if let savedLocation = getSavedLocation() {
            locationPromise?(.success(savedLocation))
        } else {
            locationPromise?(.failure(.timeout))
        }
    }
    
    private func cleanupResources() {
        isCompleted = true
        locationManager.stopUpdatingLocation()
        timeoutWorkItem?.cancel()
        timeoutWorkItem = nil
        defer { locationPromise = nil }
    }
    
    private func processLocation(_ location: CLLocation) {
        guard !isCompleted else { return }
        
        let roundedLocation = roundLocation(location)
        saveLocation(roundedLocation)
        locationPromise?(.success(roundedLocation))
        cleanupResources()
    }
    
  private func roundLocation(_ location: CLLocation) -> CLLocation { location }
  
    // 添加获取格式化位置信息的方法
    func getLocationGeo() async throws -> LocationGeo {
        // 获取当前位置
        let location = try await getCurrentLocation()
        
        // 创建基本的位置信息（只有经纬度）
        let basicLocationInfo = LocationGeo(
            whiskers: "",
            moustache: "",
            fair: "",
            pale: "",
            state: String(format: "%.15f", location.coordinate.latitude),
            marching: String(format: "%.15f", location.coordinate.longitude),
            overcoat: "",
            arm: String.generateUUID(),
            putting: String.generateUUID()
        )
        
        // 尝试进行逆地理编码
        do {
            let geocoder = CLGeocoder()
          let placemarks = try await geocoder.reverseGeocodeLocation(location, preferredLocale: Locale.current)
            
            guard let placemark = placemarks.first else {
                return basicLocationInfo // 如果没有找到地标，返回基本信息
            }
            
            // 返回完整的位置信息
            return LocationGeo(
                whiskers: placemark.administrativeArea ?? "",
                moustache: placemark.isoCountryCode?.uppercased() ?? "",
                fair: placemark.country ?? "",
                pale: [placemark.thoroughfare, placemark.subThoroughfare]
                    .compactMap { $0 }
                    .joined(separator: " "),
                state: basicLocationInfo.state,
                marching: basicLocationInfo.marching,
                overcoat: placemark.locality ?? "",
                arm: String.generateUUID(),
                putting: String.generateUUID()
            )
        } catch {
            print("反向地理编码失败: \(error.localizedDescription)")
            return basicLocationInfo // 如果逆地理编码失败，返回基本信息
        }
    }
  
  // 新增一个公共方法用于获取位置
  func getLocation() async throws -> CLLocation {
      let location = try await getCurrentLocation()
      return roundLocation(location)
  }
  
  func stargetcoor() {
    self.locationManager.requestLocation()
  }
    
  func saveCoor(_ coor: CLLocationCoordinate2D) {
    UserDefaults.standard.setValue(coor.latitude, forKey: "saveCoorWei")
    UserDefaults.standard.setValue(coor.latitude, forKey: "saveCoorJing")
    UserDefaults.standard.synchronize()
  }
}

// MARK: - CLLocationManagerDelegate
extension LocationUpdateService: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self, let location = locations.last else { return }
            self.processLocation(location)
        }
      if let location = locations.last {
        saveLocation(location)
//        saveCoor(location.coordinate)
      }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self, !self.isCompleted else { return }
            self.cleanupResources()
            self.locationPromise?(.failure(.unknown(error)))
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            let authStatus: CLAuthorizationStatus
            if #available(iOS 14.0, *) {
                authStatus = manager.authorizationStatus
            } else {
                authStatus = CLLocationManager.authorizationStatus()
            }
            
            // 只处理权限检查的回调
            if let completion = self.permissionCompletion {
                self.handleAuthorizationStatus(authStatus)
                return
            }
            
            // 如果当前有位置请求在进行中，且权限状态不是已授权，则取消请求
            if self.locationPromise != nil && !self.isCompleted {
                switch authStatus {
                case .denied, .restricted:
                    self.cleanupResources()
                    self.locationPromise?(.failure(.unauthorized))
                default:
                    break
                }
            }
        }
    }
}

// MARK: - UserDefaults Keys
private extension LocationUpdateService {
    
    private func saveLocation(_ location: CLLocation) {
        let defaults = UserDefaults.standard
        defaults.set(location.coordinate.latitude, forKey: UserDefaultsKeys.latitude)
        defaults.set(location.coordinate.longitude, forKey: UserDefaultsKeys.longitude)
        defaults.synchronize()
      
    }
    
    private func getSavedLocation() -> CLLocation? {
        let defaults = UserDefaults.standard
        guard let latitude = defaults.object(forKey: UserDefaultsKeys.latitude) as? Double,
              let longitude = defaults.object(forKey: UserDefaultsKeys.longitude) as? Double else {
            return nil
        }
        
        let coordinate = CLLocationCoordinate2D(
            latitude: latitude,
            longitude: longitude
        )
        
        return CLLocation(
            coordinate: coordinate,
            altitude: 0,
            horizontalAccuracy: -1,
            verticalAccuracy: -1,
            timestamp: Date()
        )
    }
}

extension LocationUpdateService {
    // 获取经纬度并保存到 UserDefaults
    func getLocationAndSave() async throws -> (latitude: Double, longitude: Double) {
        let location = try await getCurrentLocation()
        let roundedLocation = roundLocation(location)
        
        // 保存到 UserDefaults
        saveLocation(roundedLocation)
        
        return (roundedLocation.coordinate.latitude, roundedLocation.coordinate.longitude)
    }
    
    func showPermissionAlert() {
        // 读取值
        let value = UserDefaults.standard.integer(forKey: "needToShowCustomLocationAlert")
        if value == 1 {
            let vc = PermissionPromptAlertViewController()
            vc.modalPresentationStyle = .fullScreen
            vc.configureMessageLabel(with: "Help us verify your identity by turning on location access for Moneycat in your settings.")
            
            // 使用 window 展示弹窗
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = windowScene.windows.first {
                window.rootViewController?.present(vc, animated: true)
            }
        } else {
//          let vc = PermissionPromptAlertViewController()
//          vc.modalPresentationStyle = .fullScreen
//          vc.configureMessageLabel(with: "Help us verify your identity by turning on location access for Star Loan in your settings.")
//          
//          // 使用 window 展示弹窗
//          if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
//             let window = windowScene.windows.first {
//              window.rootViewController?.present(vc, animated: true)
//          }
        }
    }
}
