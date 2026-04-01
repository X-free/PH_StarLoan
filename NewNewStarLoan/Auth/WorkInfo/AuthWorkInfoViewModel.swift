//
//  AuthWorkInfoViewModel.swift
//  NewNewStarLoan
//
//  Created by Albert on 2025/5/9.
//

import Foundation
import UIKit
import AdSupport

class AuthWorkInfoViewModel: ObservableObject {
  private let analy = AnalyticsService()

  var start6 = 0
  // 数据源
  private(set) var formFields: [GetWorkInfoResponse.MiddleInfo.StoppedItem] = []
  let productId: String
    
    @Published var fieldValues: [String: String] = [:] // [FieldKey: Value]
    @Published var shownValues: [String: String] = [:] // [FieldKey: DisplayValue]
    @Published var selectedRegion: Region?
    @Published var selectedProvince: Province?
    @Published var selectedCity: City?
    
    init(formFields: [GetWorkInfoResponse.MiddleInfo.StoppedItem], productId: String) {
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
  
  func startFocus() {
      analy.startTracking(.workInfo, additionalParams: ["product_id": productId])
    start6 = Int(Date().timeIntervalSince1970)
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
    
    func getField(at index: Int) -> GetWorkInfoResponse.MiddleInfo.StoppedItem {
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
    
    func getCellStyle(for field: GetWorkInfoResponse.MiddleInfo.StoppedItem) -> InfomationInputCellStyle {
        switch field.mazreez {
        case "nbaallstarl": return .input
        case "nbaallstarm": return .citySelect
        case "nbaallstark": return .select
        default: return .input
        }
    }
    
    func getKeyboardType(for field: GetWorkInfoResponse.MiddleInfo.StoppedItem) -> KeyboardType {
        return KeyboardType(rawValue: field.followerske) ?? .normal
    }
    
    func getOptions(for field: GetWorkInfoResponse.MiddleInfo.StoppedItem) -> [OptionsModel] {
        return field.lines.map { line in
            OptionsModel(title: line.bad, imageUrl: "", value: String(line.mountainside))
        }
    }
    
  @MainActor
  func saveWorkInfo() async throws -> AuthWorkInfoResponse {
    // 创建一个新的字典，确保所有值都是字符串类型
    var formData: [String: String] = [:]
    
    for field in formFields {
        let value = fieldValues[field.hundred] ?? ""
        formData[field.hundred] = value
    }
    
    
    
    do {
        // 确保所有参数都是字符串类型
        var params: [String: String] = formData
        params["feud"] = productId
        let response = try await CertificateService.shared.saveWorkInfo(dict: params)
      if response.hundred == "0" {
        
        let end6 = Int(Date().timeIntervalSince1970)
        MaidianRistManager.manager.upload(foreground: productId, hammersmith: "6", welcome: "\(start6)", deal: "\(end6)")
        
      }
        return response
    }
}

}
