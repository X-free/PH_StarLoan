//
//  ContactManager.swift
//  
//
//  Created by Albert on 2025/5/21.
//


// TODO: 这个类要混淆一下
import UIKit
import Contacts
import ContactsUI

class ContactManager: NSObject, CNContactPickerDelegate{
    // MARK: - Singleton
    static let shared = ContactManager()
    
    // MARK: - Properties
    private let contactStore = CNContactStore()
    private var onContactSelected: ((String, String) -> Void)?
    
    // MARK: - Initialization
    private override init() {
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //        public enum CNAuthorizationStatus : Int, @unchecked Sendable {
    //
    //            /** The user has not yet made a choice regarding whether the application may access contact data. */
    //            case notDetermined = 0
    //
    //            /** The application is not authorized to access contact data.
    //             *  The user cannot change this application’s status, possibly due to active restrictions such as parental controls being in place. */
    //            case restricted = 1
    //
    //            /** The user explicitly denied access to contact data for the application. */
    //            case denied = 2
    //
    //            /** The application is authorized to access contact data. */
    //            case authorized = 3
    //
    //            /** This application is authorized to access some contact data. */
    //            @available(iOS 18.0, *)
    //            case limited = 4
    //        }
    
    // MARK: - Public Methods
    func requestContactsAccess(completion: @escaping (Bool) -> Void) {
        
        contactStore.requestAccess(for: .contacts) { granted, error in
            if let error = error {
                completion(false)
                return
            }
            
            completion(granted)
        }
    }
    
    func fetchContacts(completion: @escaping ([(name: String, phones: [String])]) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async { // 在后台线程执行联系人读取
            let contactStore = CNContactStore()
            let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey]
            let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
            
            do {
                var contacts: [(name: String, phones: [String])] = []
                
                try contactStore.enumerateContacts(with: request) { contact, _ in
                    // 获取全名
                    let name = [contact.givenName, contact.familyName].filter { !$0.isEmpty }.joined(separator: " ")
                    
                    // 获取所有电话号码
                    let phones = contact.phoneNumbers.map { $0.value.stringValue }
                    
                    if !phones.isEmpty {
                        contacts.append((name: name, phones: phones))
                    }
                }
                
                // 按姓名排序
                contacts.sort { $0.name < $1.name }
                
                // 切换回主线程并返回结果
                DispatchQueue.main.async {
                    completion(contacts)
                }
            } catch {
                // 如果发生错误，返回空数组
                DispatchQueue.main.async {
                    completion([])
                }
            }
        }
    }
    
    // MARK: - Public Methods
    func presentContactPicker(from viewController: UIViewController, completion: @escaping (String, String) -> Void) {
        self.onContactSelected = completion
        
        let contactPicker = CNContactPickerViewController()
        contactPicker.delegate = self
        viewController.present(contactPicker, animated: true)
    }
    
    // MARK: - CNContactPickerDelegate
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        let name = [contact.givenName, contact.familyName].filter { !$0.isEmpty }.joined(separator: " ")
        if name.isEmpty {
            ProgressHUD.failed("The phone or name is empty. Please select another.")
            return
        }
        
        if let phone = contact.phoneNumbers.first?.value.stringValue {
            if phone.isEmpty {
              ProgressHUD.failed("The phone or name is empty. Please select another.")
                return
            }
            onContactSelected?(name, phone)
        } else {
          ProgressHUD.failed("The phone or name is empty. Please select another.")
        }
        onContactSelected = nil
    }
    
    func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
        onContactSelected = nil
    }
}
