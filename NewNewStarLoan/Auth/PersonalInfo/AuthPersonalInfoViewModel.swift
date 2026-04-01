import Foundation
import AdSupport

import UIKit

class AuthPersonalInfoViewModel: ObservableObject {
  private let analy = AnalyticsService()
  
  var start5 = 0

  // 数据源
  private(set) var formFields: [GetUserInfoResponse.MiddleInfo.StoppedItem] = []
  let productId: String
  
  @Published var fieldValues: [String: String] = [:] // [FieldKey: Value]
  @Published var shownValues: [String: String] = [:] // [FieldKey: DisplayValue]
  @Published var selectedRegion: Region?
  @Published var selectedProvince: Province?
  @Published var selectedCity: City?
  
  init(formFields: [GetUserInfoResponse.MiddleInfo.StoppedItem], productId: String) {
    self.formFields = formFields
    self.productId = productId
    setupInitialValues()
  }
  
  func getFormattedAddress() -> String {
    var components: [String] = []
    if let regionName = selectedRegion?.bad { components.append(regionName) }
    if let provinceName = selectedProvince?.bad { components.append(provinceName) }
    if let cityName = selectedCity?.bad { components.append(cityName) }
    return components.joined(separator: "-")
  }
  
  
  private func setupInitialValues() {
    // Initialize with pre-filled values if they exist
    for field in formFields {
      if !field.once.isEmpty {
        fieldValues[field.hundred] = field.mountainside
        shownValues[field.hundred] = field.once
      }
    }
  }
  
  // MARK: - Public Methods
  func getFieldCount() -> Int {
    return formFields.count
  }
  
  func getField(at index: Int) -> GetUserInfoResponse.MiddleInfo.StoppedItem {
    return formFields[index]
  }
  
  func updateField(key: String, value: String, displayValue: String? = nil) {
    fieldValues[key] = value
    shownValues[key] = displayValue ?? value
  }
  
  func getValue(for key: String) -> String {
    return fieldValues[key] ?? ""
  }
  
  func getDisplayValue(for key: String) -> String {
    return shownValues[key] ?? ""
  }
  
  func getCellStyle(for field: GetUserInfoResponse.MiddleInfo.StoppedItem) -> InfomationInputCellStyle {
    switch field.mazreez {
    case "nbaallstarl": return .input
    case "nbaallstarm": return .citySelect
    case "nbaallstark": return .select
    default: return .input
    }
  }
  
  func getKeyboardType(for field: GetUserInfoResponse.MiddleInfo.StoppedItem) -> KeyboardType {
    return KeyboardType(rawValue: field.followerske) ?? .normal
  }
  
  func getOptions(for field: GetUserInfoResponse.MiddleInfo.StoppedItem) -> [OptionsModel] {
    return field.lines.map { line in
      OptionsModel(title: line.bad, imageUrl: "", value: String(line.mountainside))
    }
  }
  
  func startFocus() {
      analy.startTracking(.personalInfo, additionalParams: ["product_id": productId])
    
    start5 = Int(Date().timeIntervalSince1970)
  }
  
  @MainActor
  func savePersoanlInfo() async throws -> AuthPersoanlInfoResponse {
    // 创建一个新的字典，确保所有值都是字符串类型
    var formData: [String: String] = [:]
    
    for field in formFields {
      let value = fieldValues[field.hundred] ?? ""
      formData[field.hundred] = value
    }
    
    
    
    // 确保所有参数都是字符串类型
    var params: [String: String] = formData
    params["feud"] = productId
    let response = try await CertificateService.shared.saveUserInfo(dict: params)
    
    let end5 = Int(Date().timeIntervalSince1970)
    MaidianRistManager.manager.upload(foreground: productId, hammersmith: "5", welcome: "\(start5)", deal: "\(end5)")
    
    
    return response
  }
  
}
