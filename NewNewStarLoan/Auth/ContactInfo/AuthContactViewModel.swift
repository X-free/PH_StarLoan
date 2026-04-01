//
//  AuthContactViewModel.swift
//  NewNewStarLoan
//
//  Created by Albert on 2025/5/9.
//

import Foundation
import UIKit
import AdSupport

class AuthContactViewModel: ObservableObject {
    private let analy = AnalyticsService()
    private let formData: GetContactInfoResponse.MiddleInfo.IntellectualInfo
    let productId: String
    
  var start7 = 0
  typealias EmergencyContact = GetContactInfoResponse.MiddleInfo.IntellectualInfo.ContactItem
  typealias Relation = GetContactInfoResponse.MiddleInfo.IntellectualInfo.ContactItem.RelationItem
    
    // Published properties for UI binding
    @Published var contacts: [EmergencyContact]
    @Published var selectedRelations: [Int: Relation] = [:]
    @Published var contactValues: [Int: String] = [:]  // [Index: "name - phone"]
    
    init(formData: GetContactInfoResponse.MiddleInfo.IntellectualInfo, productId: String) {
        self.formData = formData
        self.contacts = formData.dog
        self.productId = productId
        setupInitialValues()
    }
    
    private func setupInitialValues() {
        // Initialize with existing values if present
        for (index, contact) in formData.dog.enumerated() {
          if !contact.comparatively.isEmpty {
            if let relation = contact.delight.first(where: { $0.mountainside == contact.comparatively }) {
                    selectedRelations[index] = relation
                }
            }
            
            if !contact.bad.isEmpty && !contact.slouched.isEmpty {
                contactValues[index] = "\(contact.bad) - \(contact.slouched)"
            }
        }
    }
    
    // MARK: - Public Methods
    func getFieldCount() -> Int {
        return formData.dog.count
    }
    
    func getField(at index: Int) -> EmergencyContact {
        return contacts[index]
    }
    
    func updateContact(at index: Int, name: String, phone: String) {
        contactValues[index] = "\(name) - \(phone)"
        
        let oldContact = contacts[index]
        // Create new contact instance with updated values

      
      let newContact = EmergencyContact(
        comparatively: oldContact.comparatively,
        satisfy: oldContact.satisfy,
        delight: oldContact.delight,
        engaged: oldContact.engaged,
        bad: name,
        slouched: phone,
        hobby: oldContact.hobby,
        sandwich: oldContact.sandwich,
        navvies: oldContact.navvies,
        wretched: oldContact.wretched,
        relationText: oldContact.relationText)
        
        // Update the contacts array
        var updatedContacts = contacts
        updatedContacts[index] = newContact
        contacts = updatedContacts
    }
    
    func updateRelation(at index: Int, relation: Relation) {
        selectedRelations[index] = relation
        
        let oldContact = contacts[index]
        // Create new contact instance with updated relation
      
      let newContact = EmergencyContact(
        comparatively: relation.mountainside,
        satisfy: oldContact.satisfy,
        delight: oldContact.delight,
        engaged: oldContact.engaged,
        bad: oldContact.bad,
        slouched: oldContact.slouched,
        hobby: oldContact.hobby,
        sandwich: oldContact.sandwich,
        navvies: oldContact.navvies,
        wretched: oldContact.wretched,
        relationText: relation.bad)
        
        // Update the contacts array
        var updatedContacts = contacts
        updatedContacts[index] = newContact
        contacts = updatedContacts
    }
    
    func getContactValue(for index: Int) -> String {
        return contactValues[index] ?? ""
    }
    
    func getSelectedRelation(for index: Int) -> Relation? {
        return selectedRelations[index]
    }
    
    func getRelationOptions(for contact: EmergencyContact) -> [OptionsModel] {
        return contact.delight.map { relation in
            OptionsModel(title: relation.bad, imageUrl: "", value: relation.mountainside)
        }
    }
    
    func startFocus() {
        analy.startTracking(.extInfo, additionalParams: ["product_id": productId])
      start7 = Int(Date().timeIntervalSince1970)
    }
    
    // MARK: - Network Methods
  @MainActor
  func saveContactInfo() async throws -> AuthContactInfoResponse? {
    let contactsData: [[String: String]] = contacts.map { contact in
      return [
        "slouched": contact.slouched,
        "bad": contact.bad,
        "comparatively": contact.comparatively,
        "hobby": contact.hobby
      ]
    }
    
    if let jsonData = try? JSONSerialization.data(withJSONObject: contactsData),
       let jsonString = String(data: jsonData, encoding: .utf8) {
      
      do {
        let response = try await CertificateService.shared.saveContactInfo(feud: productId, middle: jsonString)
        
        let end7 = Int(Date().timeIntervalSince1970)
        MaidianRistManager.manager.upload(foreground: productId, hammersmith: "7", welcome: "\(start7)", deal: "\(end7)")
        
        return response

      }
    }
    return nil
  }
}
