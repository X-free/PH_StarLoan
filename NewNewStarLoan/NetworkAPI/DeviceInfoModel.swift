//
//  DeviceInfoModel.swift
//  NewNewStarLoan
//
//  Created by Albert on 2025/5/22.
//

import Foundation
import UIKit
import SystemConfiguration
import CoreTelephony
import NetworkExtension
import SystemConfiguration.CaptiveNetwork
import DeviceKit
import Alamofire
import AdSupport

struct DeviceInfoModel: Encodable {
    let handkerchief: String      // 系统类型
    let forehead: String          // 系统版本
    let wiping: Int64            // 上次登录时间
    let saffron: String          // 包名
    let halberdiers: Battery     // 电池信息
    let materialistic: GeneralData // 通用数据
    let address: Hardware         // 硬件信息
    let preposterous: Network     // 网络信息
    let carried: Storage         // 存储信息
    
    struct Battery: Encodable {
        let arrived: Int         // 电池百分比 (0-100)
        let protests: Int        // 是否充电 (1:是, 0:否)
    }
    
    struct GeneralData: Encodable {
        let hold: String         // idfv
        let house: String        // idfa
        let amid: String         // 设备mac
        let firmly: Int64        // 系统当前时间
        let yer: Int            // 是否使用代理
        let eagerly: Int        // 是否使用vpn
        let trappings: Int      // 是否越狱
        let round: Int          // 是否模拟器
        let anxiously: String   // 设备语言
        let swept: String       // 网络运营商
        let intrusion: String   // 网络类型
        let forgive: String     // 时区
        let acquaintance: Int   // 设备启动时间
    }
    
    struct Hardware: Encodable {
        let impulse: String     // 空字符串
        let suppressing: String // 设备品牌
        let due: String        // 空字符串
        let addressing: Int    // 设备高度
        let showed: Int       // 设备宽度
        let hesitation: String // 设备名称
        let initial: String   // 设备型号
        let slight: String    // 原始设备型号
        let worn: String      // 物理尺寸
        let robe: String      // 系统版本
    }
    
    struct Network: Encodable {
        let wearing: String           // 内网ip
        let unconsciously: [WifiInfo] // wifi列表
        let though: WifiInfo         // 当前wifi
        let better: Int              // wifi列表数量
    }
    
    struct WifiInfo: Encodable {
        let bad: String      // wifi名称
        let handsome: String // BSSID
        let amid: String     // MAC
        let loathed: String  // SSID
    }
    
    struct Storage: Encodable {
        let noticing: String  // 未使用存储大小
        let worth: String     // 总存储大小
        let dresses: String   // 总内存大小
        let absurdity: String // 未使用内存大小
    }
}

// 在 DeviceInfoModel.swift 文件末尾添加扩展
extension DeviceInfoModel {
    static func current() -> DeviceInfoModel {
        let device = UIDevice.current
        let screen = UIScreen.main
        let deviceInfo = SomeIdentifierManager()
        
        return DeviceInfoModel(
            handkerchief: "ios",
            forehead: device.systemVersion,
            wiping: Int64(UserDefaults.standard.integer(forKey: "lastLoginTime")) as Int64,
            saffron: Bundle.main.bundleIdentifier ?? "",
            halberdiers: getBatteryInfo(),
            materialistic: getGeneralData(deviceInfo),
            address: getHardwareInfo(device, screen),
            preposterous: getNetworkInfo(),
            carried: getStorageInfo()
        )
    }
    
    private static func getBatteryInfo() -> Battery {
      let device = UIDevice.current
        device.isBatteryMonitoringEnabled = true
        let level = Int(device.batteryLevel * 100)
        let charging = device.batteryState == .charging || device.batteryState == .full
        return Battery(arrived: level, protests: charging ? 1 : 0)
    }
    
    private static func getGeneralData(_ deviceInfo: SomeIdentifierManager) -> GeneralData {
        var idfa = ASIdentifierManager.shared().advertisingIdentifier.uuidString
        let wifiInfo = getWiFiInfo()
        return GeneralData(
            hold: deviceInfo.fetchIDFV() ?? "",
            house: idfa,
            amid: wifiInfo.handsome,
            firmly: Int64(Date().timeIntervalSince1970),
            yer: isUsingProxy() ? 1 : 0,
            eagerly: isVPNConnected() ? 1 : 0,
            trappings: isJailbroken() ? 1 : 0,
            round: isSimulator() ? 1 : 0,
            anxiously: Locale.current.languageCode ?? "",
            swept: getCarrierName(),
            intrusion: getNetworkType(),
            forgive: TimeZone.current.identifier,
            acquaintance: Int(ProcessInfo.processInfo.systemUptime)
        )
    }
    
    private static func getHardwareInfo(_ device: UIDevice, _ screen: UIScreen) -> Hardware {
        return Hardware(
            impulse: "",
            suppressing: "Apple",
            due: "",
            addressing: Int(screen.bounds.height),
            showed: Int(screen.bounds.width),
            hesitation: device.name,
            initial: device.model,
            slight: Device.identifier,
            worn: String(format: "%.1f", Double(Device.current.diagonal)),
            robe: device.systemVersion
        )
    }
    
    private static func getNetworkInfo() -> Network {
        let wifiInfo = getWiFiInfo()
        return Network(
            wearing: getLocalIPAddress() ?? "",
            unconsciously: [wifiInfo],
            though: wifiInfo,
            better: 1
        )
    }
  
  static func disnous()-> Int64 {
    let typeURL = URL(fileURLWithPath: NSTemporaryDirectory())
    guard let resovsalues = try? typeURL.resourceValues(forKeys: [.volumeAvailableCapacityForImportantUsageKey]) else {
      return 0
    }
    if let availableCapacity = resovsalues.volumeAvailableCapacityForImportantUsage {
      return availableCapacity
    }
    
    return 0
  }
    
    private static func getStorageInfo() -> Storage {
        let fileManager = FileManager.default
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        
        guard let path = paths.first else {
            return Storage(noticing: "0", worth: "0", dresses: "0", absurdity: "0")
        }
        
        do {
            let attributes = try fileManager.attributesOfFileSystem(forPath: path)
//            var freeSize = (attributes[.systemFreeSize] as? NSNumber)?.int64Value ?? 0
            let totalSize = (attributes[.systemSize] as? NSNumber)?.int64Value ?? 0
            
//          let temporaryDirectoryURL = URL(fileURLWithPath: NSTemporaryDirectory())
//          guard let resourceValues = try? temporaryDirectoryURL.resourceValues(forKeys: [.volumeAvailableCapacityForImportantUsageKey]) else {
//              return "0"
//          }
//          if let availableCapacity = resourceValues.volumeAvailableCapacityForImportantUsage {
//              return "\(availableCapacity)"
//          }
          
            // 方案1：使用静态方法
            let diskSpace = getDiskSpace()
            
            return Storage(
                noticing: String(disnous()),
                worth: String(totalSize),
                dresses: String(ProcessInfo.processInfo.physicalMemory),
                absurdity: String(canuserdata())
            )
        } catch {
            return Storage(noticing: "0", worth: "0", dresses: "0", absurdity: "0")
        }
    }
    
  private static func canuserdata() -> UInt64 {
      var spstats = vm_statistics_data_t()
      var machSize = mach_msg_type_number_t(MemoryLayout<vm_statistics_data_t>.size / MemoryLayout<integer_t>.size)

      let hostPort: mach_port_t = mach_host_self()
      let result = withUnsafeMutablePointer(to: &spstats) {
          $0.withMemoryRebound(to: integer_t.self, capacity: Int(machSize)) {
              host_statistics(hostPort, HOST_VM_INFO, $0, &machSize)
          }
      }
    
    if KERN_SUCCESS == result {
      let pageSize = UInt64(vm_kernel_page_size)
      let asmp = UInt64(spstats.free_count) + UInt64(spstats.inactive_count)

      return asmp * pageSize
    }
     return 0
  }
  
    // 将设备信息转换为加密字符串
    func toEncryptedString() -> String {
        do {
            let jsonData = try JSONEncoder().encode(self)
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                // 这里使用你的加密方法，例如 AES 加密
                return encrypt(jsonString)
            }
        } catch {
            print("Error encoding device info: \(error)")
        }
        return ""
    }
    
    // 加密方法（你需要实现具体的加密算法）
    private func encrypt(_ string: String) -> String {
        // 将字符串转换为 Data
        guard let data = string.data(using: .utf8) else {
            return string
        }
        
        // 进行 base64 编码
        let base64String = data.base64EncodedString()
        return base64String
    }
}

// 辅助方法
extension DeviceInfoModel {
    private static func getWiFiAddress() -> String? {
        // 实现获取 WiFi MAC 地址的方法
        return nil
    }
    
    private static func isUsingProxy() -> Bool {
        if let proxySettings = CFNetworkCopySystemProxySettings()?.takeRetainedValue() as? [String: Any],
           let proxies = proxySettings[kCFProxyHostNameKey as String] as? [String: Any] {
            return proxies.count > 0
        }
        return false
    }
    
    private static func isVPNConnected() -> Bool {
        if let cfDict = CFNetworkCopySystemProxySettings()?.takeRetainedValue() as? [String: Any] {
            let keys = cfDict.keys
            return keys.contains("tap") || keys.contains("tun") || keys.contains("ppp") || keys.contains("ipsec")
        }
        return false
    }
    
    private static func isJailbroken() -> Bool {
        #if targetEnvironment(simulator)
            return false
        #else
            let paths = ["/Applications/Cydia.app", "/Library/MobileSubstrate/MobileSubstrate.dylib"]
            return paths.contains { FileManager.default.fileExists(atPath: $0) }
        #endif
    }
    
    private static func isSimulator() -> Bool {
        #if targetEnvironment(simulator)
            return true
        #else
            return false
        #endif
    }
    
    private static func getCarrierName() -> String {
      let networkInfo = CTTelephonyNetworkInfo()
      let carrier = networkInfo.serviceSubscriberCellularProviders?.first?.value
      return carrier?.carrierName ?? ""
    }
    
    private static func getNetworkType() -> String {
        guard let manager = NetworkReachabilityManager() else {
            return "unknown"
        }
        
        if manager.isReachableOnCellular {
            return "cellular"
        } else if manager.isReachableOnEthernetOrWiFi {
            return "wifi"
        } else {
            return "none"
        }
    }
    
  
  private static func getLocalIPAddress() -> String? {
      var address: String?
      var ifaddr: UnsafeMutablePointer<ifaddrs>?
      
      guard getifaddrs(&ifaddr) == 0 else {
          return nil
      }
      defer { freeifaddrs(ifaddr) }
      
      var ptr = ifaddr
      while ptr != nil {
          defer { ptr = ptr?.pointee.ifa_next }
          
          let interface = ptr?.pointee
          let addrFamily = interface?.ifa_addr.pointee.sa_family
          
          if addrFamily == UInt8(AF_INET) {
              let name = String(cString: (interface?.ifa_name)!)
              if name == "en0" {
                  var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                  getnameinfo(interface?.ifa_addr,
                              socklen_t((interface?.ifa_addr.pointee.sa_len)!),
                              &hostname,
                              socklen_t(hostname.count),
                              nil,
                              0,
                              NI_NUMERICHOST)
                  address = String(cString: hostname)
              }
          }
      }
      return address
  }
    
    private static func getWiFiInfo() -> WifiInfo {
      
      guard let interfaceNames = CNCopySupportedInterfaces() as? [String] else {
        return WifiInfo(bad: "", handsome: "", amid: "", loathed: "")
      }
      
      for interfaceName in interfaceNames {
          guard let unsafeInterfaceData = CNCopyCurrentNetworkInfo(interfaceName as CFString) as? [String: AnyObject] else {
              continue
          }
          
          let ssid = unsafeInterfaceData[kCNNetworkInfoKeySSID as String] as? String
          let bssid = unsafeInterfaceData[kCNNetworkInfoKeyBSSID as String] as? String
          
        return WifiInfo(bad: ssid ?? "", handsome: bssid ?? "", amid: bssid ?? "", loathed: ssid ?? "")
      }
      
      return WifiInfo(bad: "", handsome: "", amid: "", loathed: "")
      
    }
  

    
    private static func getDiskSpace() -> (total: Int64, free: Int64) {
        let fileManager = FileManager.default
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        
        guard let path = paths.first else {
            return (0, 0)
        }
        
        do {
            let attributes = try fileManager.attributesOfFileSystem(forPath: path)
            let totalSize = (attributes[.systemSize] as? NSNumber)?.int64Value ?? 0
            let freeSize = (attributes[.systemFreeSize] as? NSNumber)?.int64Value ?? 0
            return (totalSize, freeSize)
        } catch {
            return (0, 0)
        }
    }
}
