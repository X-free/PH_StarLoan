//
//  AuthBankInfoViewModel.swift
//  NewNewStarLoan
//
//  Created by Albert on 2025/5/11.
//

import Foundation

class AuthBankInfoViewModel: ObservableObject {
  private let analy = AnalyticsService()

  private let formData: BankInfoResponse.BankMiddle
  let productId: String
  
  @Published var selectedIndex: Int = 0
  @Published var fieldValues: [Int: [String: String]] = [:] // [SectionIndex: [FieldKey: Value]]
  @Published var shownValues: [Int: [String: String]] = [:]
  
  init(formData: BankInfoResponse.BankMiddle, productId: String) {
      self.formData = formData
      self.productId = productId
      setupInitialFieldValues()
      setupInitialShownValues()
  }
  
  private func setupInitialShownValues() {
      // Initialize empty dictionaries for each section
      for (sectionIndex, section) in formData.stopped.enumerated() {
          shownValues[sectionIndex] = [:]
          
          // 为每个字段设置初始显示值
          for field in section.stopped {
            if !field.once.isEmpty {
                  shownValues[sectionIndex]?[field.hundred] = field.once
              }
          }
      }
  }
  
  private func setupInitialFieldValues() {
      for (sectionIndex, section) in formData.stopped.enumerated() {
          fieldValues[sectionIndex] = [:]
          
          // 为每个字段设置初始显示值
          for field in section.stopped {
              if !field.mountainside.isEmpty {
                  fieldValues[sectionIndex]?[field.hundred] = field.mountainside
              }
          }
      }
  }
  
  func startFocus() {
//      analy.startTracking(.bankInfo, additionalParams: ["product_id": productId])
    
  }
  
  func updateField(sectionIndex: Int, key: String, value: String) {
      fieldValues[sectionIndex]?[key] = value
      
  }
  
  func updateShown(sectionIndex: Int, key: String, value: String) {
      shownValues[sectionIndex]?[key] = value
      
  }

  func getValue(forSection sectionIndex: Int, key: String) -> String {
      return fieldValues[sectionIndex]?[key] ?? ""
  }
  
  func getShown(forSection sectionIndex: Int, key: String) -> String {
      return shownValues[sectionIndex]?[key] ?? ""
  }
  
  func getCurrentSectionFields() -> [BankInfoResponse.BankMiddle.BankItem] {
      return formData.stopped[selectedIndex].stopped
  }
  
  // Add this new method to ViewModel
  func getCurrentSections() -> [BankInfoResponse.BankMiddle.BankType] {
      return formData.stopped
  }
  
  // Add this new method to ViewModel
  func resetSection(index: Int) {
      selectedIndex = index
      
  }
  
  func getSubmitData() -> [String: String] {
      var fieldsData = fieldValues[selectedIndex] ?? [:]
      fieldsData["fun"] = String(selectedIndex + 1)
      return fieldsData
  }
}
