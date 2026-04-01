//
//  AuthPersonalInfoViewController.swift
//  NewNewStarLoan
//
//  Created by Albert on 2025/5/8.
//

import Foundation
import UIKit
import SnapKit
import ProgressHUD

class AuthPersonalInfoViewController: UIViewController {
  private let viewModel: AuthPersonalInfoViewModel
  
  // MARK: - Initialization
  init(viewModel: AuthPersonalInfoViewModel) {
      self.viewModel = viewModel
      super.init(nibName: nil, bundle: nil)
  }
  
  var userInfo: GetUserInfoResponse?
  
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
  
  
  
  required init?(coder: NSCoder) {
    fatalError("require")
  }
  
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
  
  @objc private func nextStepButtonTapped() {
    ProgressHUD.animate("Submiting...")
    Task {
        do {
          let result = try await viewModel.savePersoanlInfo()
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
            if cousin == "work" || cousin == "nbaallstarh" {
                ProgressHUD.animate("Fetching...")
                Task {
                    do {
                        let response = try await CertificateService.shared.getWorkInfo(feud: viewModel.productId)
                        ProgressHUD.dismiss()
                        await MainActor.run {
                            let vc = AuthWorkInfoViewController(viewModel: AuthWorkInfoViewModel(formFields: response.middle.stopped, productId: viewModel.productId))
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                    } catch {
                        ProgressHUD.dismiss()
                        ProgressHUD.error(error.localizedDescription)
                    }
                }
            } else if cousin == "nbaallstari" {
              Task {
                do {
                  let response = try await CertificateService.shared.getContactInfo(feud: viewModel.productId)
                  await MainActor.run {
                    ProgressHUD.dismiss()
                    let vc = AuthContactViewController(viewModel: AuthContactViewModel(formData: response.middle.intellectual, productId: viewModel.productId))
                    self.navigationController?.pushViewController(vc, animated: true)
                  }
                } catch {
                  
                }
              }
            } else if cousin == "nbaallstarj" {
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
        } catch let error as NSError {
//            ProgressHUD.dismiss()
//            if error.domain == "AuthPersonalInfoError" {
                // 显示自定义错误信息
                ProgressHUD.error(error.localizedDescription)
//            } else {
                // 其他错误显示通用错误信息
//                ProgressHUD.error("Submit Failed")
//            }
        }
    }
}
  
  private lazy var backgroundImageView: UIImageView = {
    let imageView = UIImageView(image: UIImage(named: "xzrzfs_bg"))
    imageView.isUserInteractionEnabled = true
    return imageView
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    setupBelowUI()
    viewModel.startFocus()
  }
    
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    fetchUserInfo()
  }
  
  private func fetchUserInfo() {
    
    Task {
      do {
        let response = try await CertificateService.shared.getUserInfo(feud: viewModel.productId)  // 使用 productId
        await MainActor.run {
          userInfo = response
          
          
        }
      } catch {
        
      }
    }
  }
  
  private lazy var tableView: UITableView = {
    let tableView = UITableView(frame: .zero, style: .plain)
    tableView.delegate = self
    tableView.dataSource = self
    tableView.separatorStyle = .none
    tableView.backgroundColor = .clear
    tableView.showsVerticalScrollIndicator = false
    tableView.register(AuthPersonalInfoCell.self, forCellReuseIdentifier: AuthPersonalInfoCell.identifier)
    return tableView
  }()
  
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
    navigationBar.setTitle("Personal Information")
    
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
      make.leading.trailing.equalToSuperview()
      make.bottom.equalToSuperview()
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
        ("pi_selected", "pi"),
        ("wi_unselected", "wi"),
        ("ci_unselected", "ci"),
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
  }
  
  private func createImageView(imageName: String, id: String) -> UIImageView {
      let imageView = UIImageView(image: UIImage(named: imageName))
      imageView.contentMode = .scaleAspectFit
      imageView.accessibilityIdentifier = id
      return imageView
  }
}

// MARK: - UITableViewDelegate & DataSource
extension AuthPersonalInfoViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.getFieldCount()
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: AuthPersonalInfoCell.identifier, for: indexPath) as? AuthPersonalInfoCell else {
      return UITableViewCell()
    }
    
    let field = viewModel.getField(at: indexPath.row)
    let style = viewModel.getCellStyle(for: field)
    let keyboardType = viewModel.getKeyboardType(for: field)
    
    cell.configure(title: field.studied, placeholder: field.mentioned, style: style, keyboardType: keyboardType)
    cell.valueTextField.text = viewModel.getDisplayValue(for: field.hundred)
    cell.valueTextField.removeTarget(nil, action: nil, for: .allEvents) // Remove any existing targets
    cell.valueTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    cell.valueTextField.tag = indexPath.row
    
    
    cell.onButtonTapped = { [weak self] in
        if style == .select {
            self?.handleSelection(for: indexPath)
        } else if style == .citySelect {
          self?.handleCitySelection(for: indexPath)
        }
    }
    return cell
  }
  
  private func handleCitySelection(for indexPath: IndexPath) {
    view.endEditing(true)

    let vc = CitySelectViewController()
    vc.setupInitialSelection(region: viewModel.selectedRegion, province: viewModel.selectedProvince, city: viewModel.selectedCity)
    vc.onConfirm = { [weak self] region, province, city in
        guard let self = self else { return }
        let field = self.viewModel.getField(at: indexPath.row)
        
        // Update ViewModel
        self.viewModel.selectedRegion = region
        self.viewModel.selectedProvince = province
        self.viewModel.selectedCity = city
        
        let formattedAddress = self.viewModel.getFormattedAddress()
        self.viewModel.updateField(
            key: field.hundred,
            value: formattedAddress,
            displayValue: formattedAddress
        )
        
        // Update UI
        if let cell = self.tableView.cellForRow(at: indexPath) as? AuthPersonalInfoCell {
            cell.valueTextField.text = formattedAddress
        }
    }
    vc.modalPresentationStyle = .overFullScreen
    present(vc, animated: true)
  }
  
  @objc private func textFieldDidChange(_ textField: UITextField) {
      let index = textField.tag
      let field = viewModel.getField(at: index)
      viewModel.updateField(key: field.hundred, value: textField.text ?? "")
      
  }
  
  // 显示证件类型选择弹窗
  private func handleSelection(for indexPath: IndexPath) {
    view.endEditing(true)
    let field = viewModel.getField(at: indexPath.row)
    let options = viewModel.getOptions(for: field)
    
  
    let optionVC = OptionSelectViewController()
    optionVC.configure(title: field.mentioned, options: options)
    
    let currentValue = viewModel.getValue(for: field.hundred)
    if !currentValue.isEmpty,
       let matching = field.lines.first(where: { String($0.mountainside) == currentValue }) {
        let initialOption = options.first { $0.title == matching.bad }
        optionVC.setupInitialSelection(option: initialOption)
    }
    
    optionVC.onConfirm = { [weak self] selectedOption in
      guard let self = self,
            let matching = field.lines.first(where: { $0.bad == selectedOption.title }) else { return }
      
      
      // 更新 ViewModel
      self.viewModel.updateField(
          key: field.hundred,
          value: String(matching.mountainside),
          displayValue: matching.bad
      )
      
      // 更新 UI
      if let cell = self.tableView.cellForRow(at: indexPath) as? AuthPersonalInfoCell {
        cell.valueTextField.text = matching.bad
          cell.updateSelectedOption(matching)
      }
      
    }
      optionVC.modalPresentationStyle = .overFullScreen
      present(optionVC, animated: true)
  }
}


