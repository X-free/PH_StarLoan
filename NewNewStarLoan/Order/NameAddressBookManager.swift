//
//  ContactManager.swift
//  
//
//  Created by Albert on 2025/5/21.
//
import ProgressHUD
import UIKit
import Contacts
import ContactsUI

class NameAddressBookManager: NSObject, CNContactPickerDelegate {
    // MARK: - Singleton
    static let shared = NameAddressBookManager()
    
    // MARK: - Properties
    private let addressBookStore = CNContactStore()
    private var contactSelectedCallback: ((String, String) -> Void)?
    
    // MARK: - Initialization
    private override init() {
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    func requestAddressBookPermission(completion: @escaping (Bool) -> Void) {
        addressBookStore.requestAccess(for: .contacts) { granted, error in
            if let error = error {
                completion(false)
                return
            }
            
            completion(granted)
        }
    }
    
    func loadAddressBookContacts(completion: @escaping ([(name: String, phones: [String])]) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            let addressStore = CNContactStore()
            let requiredKeys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey]
            let fetchRequest = CNContactFetchRequest(keysToFetch: requiredKeys as [CNKeyDescriptor])
            
            do {
                var addressBookEntries: [(name: String, phones: [String])] = []
                
                try addressStore.enumerateContacts(with: fetchRequest) { contact, _ in
                    let fullName = [contact.givenName, contact.familyName].filter { !$0.isEmpty }.joined(separator: " ")
                    let phoneNumbers = contact.phoneNumbers.map { $0.value.stringValue }
                    
                    if !phoneNumbers.isEmpty {
                        addressBookEntries.append((name: fullName, phones: phoneNumbers))
                    }
                }
                
                addressBookEntries.sort { $0.name < $1.name }
                
                DispatchQueue.main.async {
                    completion(addressBookEntries)
                }
            } catch {
                DispatchQueue.main.async {
                    completion([])
                }
            }
        }
    }
    
    func showAddressBookPicker(from viewController: UIViewController, completion: @escaping (String, String) -> Void) {
        self.contactSelectedCallback = completion
        
        let addressPicker = CNContactPickerViewController()
        addressPicker.delegate = self
        viewController.present(addressPicker, animated: true)
    }
    
    // MARK: - CNContactPickerDelegate
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        let fullName = [contact.givenName, contact.familyName].filter { !$0.isEmpty }.joined(separator: " ")
        if fullName.isEmpty {
            ProgressHUD.failed("The phone or name is empty. Please select another.")
            return
        }
        
        if let phoneNumber = contact.phoneNumbers.first?.value.stringValue {
            if phoneNumber.isEmpty {
                ProgressHUD.failed("The phone or name is empty. Please select another.")
                return
            }
            contactSelectedCallback?(fullName, phoneNumber)
        } else {
            ProgressHUD.failed("The phone or name is empty. Please select another.")
        }
        contactSelectedCallback = nil
    }
    
    func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
        contactSelectedCallback = nil
    }
}
