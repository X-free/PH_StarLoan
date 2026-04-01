//
//  AuthBankInfoViewController.swift
//  NewNewStarLoan
//
//  Created by Albert on 2025/5/11.
//

import Foundation
import UIKit
import ProgressHUD
import AdSupport

class AuthBankInfoViewController: UIViewController {
  
  private let viewModel: AuthBankInfoViewModel
  private let analy = AnalyticsService()
  private let analy2 = AnalyticsService()

  var start8 = 0
  
  private var selectedIndex: Int {
      get { viewModel.selectedIndex }
      set { viewModel.selectedIndex = newValue }
  }
  
  init(formData: BankInfoResponse.BankMiddle, productId: String) {
      self.viewModel = AuthBankInfoViewModel(formData: formData, productId: productId)
      super.init(nibName: nil, bundle: nil)
      
  }
  
  required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }
  
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
    tableView.register(AuthPersonalInfoCell.self, forCellReuseIdentifier: AuthPersonalInfoCell.identifier)
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
  
  private lazy var buttonStackView: UIStackView = {
      let stackView = UIStackView()
      stackView.axis = .horizontal
      stackView.distribution = .fillEqually
      stackView.spacing = 0
      return stackView
  }()
  
  // MARK: Life cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .white
    setupBelowUI()
    
    self.start8 = Int(Date().timeIntervalSince1970)
    analy.startTracking(.bankInfo, additionalParams: ["product_id": viewModel.productId])
  }
  
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
    navigationBar.setTitle("Bank Card Info")
    
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
        
    
    containerImageView.addSubview(buttonStackView)
    buttonStackView.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(90)
      make.leading.trailing.equalToSuperview()
      make.height.equalTo(36)
    }
    
    // Create and add buttons
    for (index, section) in viewModel.getCurrentSections().enumerated() {
        let button = UIButton(type: .custom)
        button.setTitle(section.studied, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(.init(hex: "4999F7"), for: .selected)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
        button.tag = index
        button.addTarget(self, action: #selector(sectionButtonTapped(_:)), for: .touchUpInside)
        buttonStackView.addArrangedSubview(button)
    }
    // Initial selection state
    updateButtonSelectionStates()
    
    
    containerImageView.addSubview(tableView)
    tableView.snp.makeConstraints { make in
      make.top.equalTo(buttonStackView.snp.bottom).offset(5)
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
        ("pi_unselected", "pi"),
        ("wi_unselected", "wi"),
        ("ci_unselected", "ci"),
        ("bci_selected", "bci")
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
    
    // 添加自动滚动到选中位置的代码
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
        guard let self = self else { return }
        // 计算需要滚动的位置（最后一个图片的位置）
        let contentOffset = CGPoint(x: self.scrollView.contentSize.width - self.scrollView.bounds.width, y: 0)
        self.scrollView.setContentOffset(contentOffset, animated: true)
    }
  }
  
  private func createImageView(imageName: String, id: String) -> UIImageView {
      let imageView = UIImageView(image: UIImage(named: imageName))
      imageView.contentMode = .scaleAspectFit
      imageView.accessibilityIdentifier = id
      return imageView
  }
  
  @objc private func sectionButtonTapped(_ sender: UIButton) {
      // Reset the previous section's data
      viewModel.resetSection(index: selectedIndex)
      
      // Update selected index
      selectedIndex = sender.tag
      updateButtonSelectionStates()
      
      // Clear all visible cell text fields
      for case let cell as AuthPersonalInfoCell in tableView.visibleCells {
          cell.clearSelection()
      }
      
      tableView.reloadData()
      // Scroll to top
      tableView.setContentOffset(.zero, animated: true)
  }
  
  private func updateButtonSelectionStates() {
      for case let button as UIButton in buttonStackView.arrangedSubviews {
          let isSelected = button.tag == selectedIndex
          
          button.isSelected = isSelected
      }
  }
}

extension AuthBankInfoViewController: UITableViewDataSource, UITableViewDelegate {
  func numberOfSections(in tableView: UITableView) -> Int {
      return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return viewModel.getCurrentSectionFields().count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let field = viewModel.getCurrentSectionFields()[indexPath.row]
    
    var style: InfomationInputCellStyle = .input
    if field.mazreez == "nbaallstarl" {
        style = .input
    } else if field.mazreez == "nbaallstarm" {
        style = .citySelect
    } else if field.mazreez == "nbaallstark" {
        style = .select
    }
    
    let keyboardType: KeyboardType = field.followerske == 0 ? .normal : .number
    
    guard let cell = tableView.dequeueReusableCell(withIdentifier: AuthPersonalInfoCell.identifier) as? AuthPersonalInfoCell else {
        return UITableViewCell()
    }
    
    cell.configure(title: field.studied, placeholder: field.mentioned, style: style, keyboardType: keyboardType)
    cell.valueTextField.text = viewModel.getShown(forSection: selectedIndex, key: field.hundred)
    // Add target for text field changes
    cell.valueTextField.removeTarget(nil, action: nil, for: .allEvents) // Remove any existing targets
    cell.valueTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    cell.valueTextField.tag = indexPath.row
    cell.onButtonTapped = { [weak self] in
      self?.handleSelection(for: indexPath)
    }
    return cell
  }
  
  
  @objc private func textFieldDidChange(_ textField: UITextField) {
      let index = textField.tag
      let field = viewModel.getCurrentSectionFields()[index]
      viewModel.updateField(sectionIndex: selectedIndex, key: field.hundred, value: textField.text ?? "")
      viewModel.updateShown(sectionIndex: selectedIndex, key: field.hundred, value: textField.text ?? "")
  }
  
  private func handleSelection(for indexPath: IndexPath) {
    view.endEditing(true)
    let field = viewModel.getCurrentSectionFields()[indexPath.row]
    
    let options = field.lines.map { line in
      OptionsModel(title: line.bad, imageUrl: line.fantastic, value: line.mountainside.stringValue)
    }
    
    let optionVC = OptionSelectViewController()
    optionVC.configure(title: field.mentioned, options: options)
    
    let currentValue = viewModel.getValue(forSection: selectedIndex, key: field.hundred)
    if !currentValue.isEmpty,
       let matching = field.lines.first(where: { $0.mountainside.stringValue == currentValue }) {
        let initialOption = options.first { $0.title == matching.bad }
        optionVC.setupInitialSelection(option: initialOption)
    }
    
    optionVC.onConfirm = { [weak self] selectedOption in
      guard let self = self else { return }

      if let matching = field.lines.first(where: { $0.bad == selectedOption.title }) {
          // Update ViewModel
          self.viewModel.updateField(sectionIndex: self.selectedIndex,
                                   key: field.hundred,
                                   value: matching.mountainside.stringValue)
          self.viewModel.updateShown(sectionIndex: self.selectedIndex, key: field.hundred, value: matching.bad)
          
          // Update UI
          if let cell = self.tableView.cellForRow(at: indexPath) as? AuthPersonalInfoCell {
              cell.valueTextField.text = matching.bad
              cell.updateSelectedOption(matching)
          }
      }
      
    }
    
    optionVC.modalPresentationStyle = .overFullScreen
    present(optionVC, animated: true)
  }
  
  
  
  @objc func nextStepButtonTapped() {
    var fieldsData = viewModel.getSubmitData()
    fieldsData["loud"] = String.generateUUID()
    fieldsData["feud"] = viewModel.productId
    
    Task {
      do {
        let saveResponse = try await CertificateService.shared.saveBankCardInfo(dict: fieldsData)
        if saveResponse.hundred == "0" {
          
          let end = Int(Date().timeIntervalSince1970)
          MaidianRistManager.manager.upload(foreground: self.viewModel.productId, hammersmith: "8", welcome: "\(self.start8)", deal: "\(end)")
          
          
          ProgressHUD.animate("Waiting...")
//          try await Task.sleep(nanoseconds: 1 * 1_000_000_000)
          
          let result = try await ProductService.shared.getProductDetail(
            feud: viewModel.productId,
            staying: String.generateUUID(),
            since: String.generateUUID()
          )
          
          ProgressHUD.dismiss()
          if result.middle.wedneskpiday == nil {
            navigationController?.popToRootViewController(animated: true)
            
            /*
            ProgressHUD.dismiss()
            let orderNumber = result.middle.tag.herat
            let end9 = Int(Date().timeIntervalSince1970)
            MaidianRistManager.manager.upload(foreground: self.viewModel.productId, hammersmith: "9", welcome: "\(end9)", deal: "\(end9)")
            let response = try await OrderService.shared.fetchJumpURLWithOrder(rose: orderNumber)

            await MainActor.run {
              print("获取跳转链接成功：\(response.middle.trade)")
              
              var urlString = response.middle.trade
              let deviceInfo = DeviceInfo.current
              let commonParams = [
                "assure": "iOS",
                "solemnly": Bundle.main.version,
                "sense": deviceInfo.model,
                "give": deviceInfo.identifier,
                "uncanny": deviceInfo.systemVersion,
                "curse": "starloanapi",
                "hypnotised": UserDefaults.standard.string(forKey: "sessionId") ?? "",
                "turned": deviceInfo.identifier,
                "boyfine": String.generateUUID()
              ]
              
              // 构建查询字符串
              let queryItems = commonParams.map { key, value in
                "\(key)=\(value)"
              }.joined(separator: "&")
              
              // 添加参数到URL
              if urlString.contains("?") {
                urlString += "&\(queryItems)"
              } else {
                urlString += "?\(queryItems)"
              }
              
              print("处理后的URL：", urlString)
              
              // 显示 WebView - 只使用一种导航方式
              // 修改 WebView 跳转逻辑
              let webViewController = MyWebViewController(urlString: urlString)
              let navigationController = UINavigationController(rootViewController: webViewController)
              // 先关闭当前的 AuthBankInfoViewController
              self.dismiss(animated: true) { [weak self] in
                  // 在关闭完成后，从 window 的根视图控制器来展示新的导航控制器
                  if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                     let window = windowScene.windows.first {
                      navigationController.modalPresentationStyle = .fullScreen
                      window.rootViewController?.present(navigationController, animated: true)
                  }
              }
            }
            */
          }
          
          
        } else {
          await MainActor.run {
            ProgressHUD.failed(saveResponse.seats)
          }
        }
      } catch {
        ProgressHUD.error(error.localizedDescription)
      }
      
    }
  }
}

extension UINavigationController {
    func resetToRootAndPush(_ viewController: UIViewController) {
        // 先获取根视图控制器
        guard let rootVC = viewControllers.first else { return }
        
        // 回到根视图控制器
        self.popToRootViewController(animated: false)
//      self.dismiss(animated: true)
        
        // 使用根视图控制器来 present 新的导航控制器
        DispatchQueue.main.async {
            let navController = UINavigationController(rootViewController: viewController)
            navController.modalPresentationStyle = .fullScreen
            rootVC.present(navController, animated: true)
        }
    }
}
