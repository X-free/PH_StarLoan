//
//  ContactInfomationTableViewCell.swift
//  NewNewStarLoan
//
//  Created by Albert on 2025/5/11.
//

import UIKit
import SnapKit
import Foundation

class ContactInfomationTableViewCell: UITableViewCell {
  static let cellIdentifier = "ContactInfomationTableViewCell"
  var selectedRelation: GetContactInfoResponse.MiddleInfo.IntellectualInfo.ContactItem.RelationItem?
  var relationButtonClosure: (() -> Void)?
  var phoneButtonClosure: (() -> Void)?
  
  private let phoneButton: UIButton = {
      let button = UIButton(type: .custom)
      button.backgroundColor = .clear
      return button
  }()
  
  
  private let relationButton: UIButton = {
      let button = UIButton(type: .custom)
      button.backgroundColor = .clear
      return button
  }()
  
  private lazy var titleRelationLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 14, weight: .medium)
    label.textColor = UIColor(hex: "4999F7")
    return label
  }()
  
  private lazy var titlePhoneLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 14, weight: .medium)
    label.textColor = UIColor(hex: "4999F7")
    return label
  }()
  
  private var relationTextField: UITextField = {
    let textField = UITextField()
    textField.font = .systemFont(ofSize: 14, weight: .medium)
    textField.textColor = UIColor(hex: "06101C")
    textField.placeholder = "Please Select"

    return textField
  }()
  
  private lazy var relationArrowImageView: UIImageView = {
    let imageView = UIImageView(image: UIImage(named: "right_arrow"))
    imageView.contentMode = .scaleAspectFit
    return imageView
  }()
  
  private lazy var phoneArrowImageView: UIImageView = {
    let imageView = UIImageView(image: UIImage(named: "right_arrow"))
    imageView.contentMode = .scaleAspectFit
    return imageView
  }()
  
  private var phoneTextField: UITextField = {
    let textField = UITextField()
    textField.font = .systemFont(ofSize: 14, weight: .medium)
    textField.textColor = UIColor(hex: "06101C")
    textField.placeholder = "Name - Phone Number"
    return textField
  }()
  
  private let nameLabel: UILabel = {
      let label = UILabel()
      label.font = .systemFont(ofSize: 14, weight: .bold)
      label.textAlignment = .center
      label.text = "Emergency contact 1"
      label.textColor = UIColor(hex: "06101C")
      return label
  }()
  
  private let relationBG: UIImageView = {
    let imageView = UIImageView(image: UIImage(named: "grxx_bg_04"))
    imageView.contentMode = .scaleAspectFill
    imageView.isUserInteractionEnabled = true
    return imageView
 }()
  
  private let contactBG: UIImageView = {
    let imageView = UIImageView(image: UIImage(named: "grxx_bg_04"))
    imageView.contentMode = .scaleAspectFill
    imageView.isUserInteractionEnabled = true
    return imageView
  }()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
      super.init(style: style, reuseIdentifier: reuseIdentifier)
      selectionStyle = .none
      setupUI()
  }
  
  required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }
  
  func setupUI() {
    contentView.addSubview(nameLabel)
    nameLabel.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(15)
      make.leading.equalToSuperview().offset(15)
    }
    
    contentView.addSubview(relationBG)
    contentView.addSubview(contactBG)
    
    relationBG.addSubview(relationTextField)
    relationBG.addSubview(relationArrowImageView)
    
    relationBG.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview().inset(15)
      make.top.equalTo(nameLabel.snp.bottom).offset(20)
    }
    
    relationTextField.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(42)
      make.leading.equalToSuperview().offset(30)
      make.trailing.equalToSuperview().offset(-10)
      make.height.equalTo(48)
    }
    
    relationArrowImageView.snp.makeConstraints { make in
      make.centerY.equalTo(relationTextField)
      make.trailing.equalToSuperview().offset(-30)
      make.width.equalTo(7)
      make.height.equalTo(10)
    }
    

    contactBG.addSubview(phoneTextField)
    contactBG.addSubview(phoneArrowImageView)
    
    contactBG.snp.makeConstraints { make in
      make.leading.trailing.equalTo(relationBG)
      make.top.equalTo(relationBG.snp.bottom).offset(36)
      make.bottom.equalToSuperview().offset(-15)
    }
    
    phoneTextField.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(42)
      make.leading.equalToSuperview().offset(30)
      make.trailing.equalToSuperview().offset(-10)
      make.height.equalTo(48)
    }
    
    phoneArrowImageView.snp.makeConstraints { make in
      make.centerY.equalTo(phoneTextField)
      make.trailing.equalToSuperview().offset(-30)
      make.width.equalTo(7)
      make.height.equalTo(10)
    }
    
    relationBG.addSubview(titleRelationLabel)
    titleRelationLabel.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(12)
      make.leading.equalToSuperview().offset(15)
    }
    
    contactBG.addSubview(titlePhoneLabel)
    titlePhoneLabel.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(12)
      make.leading.equalToSuperview().offset(15)
    }
    
    relationBG.addSubview(relationButton)
    contactBG.addSubview(phoneButton)
    
    relationButton.snp.makeConstraints { make in
        make.edges.equalTo(relationTextField)
    }
    
    phoneButton.snp.makeConstraints { make in
        make.edges.equalTo(phoneTextField)
    }
    
    relationButton.addTarget(self, action: #selector(relationButtonDidTapped), for: .touchUpInside)
    phoneButton.addTarget(self, action: #selector(phoneButtonDidTapped), for: .touchUpInside)
  }
  
  @objc private func relationButtonDidTapped() {
      relationButtonClosure?()
  }

  @objc private func phoneButtonDidTapped() {
      phoneButtonClosure?()
  }
  
  func configure(title: String, relationPlaceholder: String, contactPlaceholder: String) {
      
      nameLabel.text = title
      relationTextField.placeholder = relationPlaceholder
      phoneTextField.placeholder = contactPlaceholder
    
  }
  
  func configureTitle(relation: String, phone: String) {
    titleRelationLabel.text = relation
    titlePhoneLabel.text = phone
  }
  
  func configurePhoneTextField(with namePhone: String) {
    phoneTextField.text = namePhone
  }
  
  func configureRelationTextField(with relation: String) {
    relationTextField.text = relation
  }
}
