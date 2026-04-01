//
//  MineViewController.swift
//  NewNewStarLoan
//
//  Created by Albert on 2025/5/5.
//
import ProgressHUD
import Foundation
import UIKit
import SnapKit

extension String {
    /// 将 10 位手机号转换为 `91****5678` 格式
    func masked() -> String? {
        // 检查字符串是否为 10 位数字
        guard self.isNumeric else {
            return nil
        }
        
        // 使用字符串替换实现格式化
        let start = self.prefix(2)   // 前两位
        let end = self.suffix(4)    // 后四位
        return "\(start)****\(end)"
    }
  
  var isNumeric: Bool {
      let scanner = Scanner(string: self)
      scanner.locale = NSLocale.current
      #if os(Linux) || targetEnvironment(macCatalyst)
      return scanner.scanDecimal() != nil && scanner.isAtEnd
      #else
      return scanner.scanDecimal(nil) && scanner.isAtEnd
      #endif
  }
}

class MineViewController: UIViewController {
  
  private lazy var topImageView: UIImageView = {
    let imageView = UIImageView(image: UIImage(named: "mine_top_container"))
    imageView.contentMode = .scaleAspectFill
    imageView.isUserInteractionEnabled = true
    
    return imageView
  }()
  
  private lazy var containerView: UIView = {
    let view = UIView()
    view.backgroundColor = .white
    view.isUserInteractionEnabled = true
    
    // 添加圆角
    view.layer.cornerRadius = 20
    view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner] // 只设置顶部左右圆角
    return view
  }()
  
  private lazy var tipsImageView: UIImageView = {
    let imageView = UIImageView(image: UIImage(named: "mine_tips"))
    imageView.contentMode = .scaleToFill
    imageView.isUserInteractionEnabled = true
    return imageView
  }()
  
  private lazy var stackView: UIStackView = {
    let stack = UIStackView()
    stack.axis = .vertical
    stack.spacing = 20
    stack.distribution = .fillEqually
    return stack
  }()
  
  private func createCellView(title: String, imageName: String, showArrow: Bool = true, versionText: String? = nil, action: Selector? = nil) -> UIView {
    let containerView = UIView()
    
    // 背景图片
    let backgroundImageView = UIImageView(image: UIImage(named: "mine_cell_bg"))
    backgroundImageView.contentMode = .scaleToFill
    
    // 图标
    let iconImageView = UIImageView(image: UIImage(named: imageName))
    iconImageView.contentMode = .scaleAspectFit
    
    // 标题
    let titleLabel = UILabel()
    titleLabel.text = title
    titleLabel.applyMineStyle()
    
    // 添加子视图
    containerView.addSubview(backgroundImageView)
    containerView.addSubview(iconImageView)
    containerView.addSubview(titleLabel)
    
    // 设置约束
    backgroundImageView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    
    iconImageView.snp.makeConstraints { make in
      make.leading.equalTo(16)
      make.centerY.equalToSuperview()
      make.size.equalTo(CGSize(width: 24, height: 24))
    }
    
    titleLabel.snp.makeConstraints { make in
      make.leading.equalTo(iconImageView.snp.trailing).offset(12)
      make.centerY.equalToSuperview()
    }
    
    // 根据需要添加右箭头或版本号
    if showArrow {
      let arrowImageView = UIImageView(image: UIImage(named: "right_arrow"))
      containerView.addSubview(arrowImageView)
      arrowImageView.snp.makeConstraints { make in
        make.trailing.equalTo(-16)
        make.centerY.equalToSuperview()
        make.size.equalTo(CGSize(width: 7, height: 10))
      }
    } else if let version = versionText {
      let versionLabel = UILabel()
      versionLabel.text = version
      versionLabel.font = .systemFont(ofSize: 14, weight: .regular)
      versionLabel.textColor = UIColor(hex: "6C6C6C")
      containerView.addSubview(versionLabel)
      versionLabel.snp.makeConstraints { make in
        make.trailing.equalTo(-16)
        make.centerY.equalToSuperview()
      }
    }
    
    // 如果有点击事件，添加手势识别器
    if let action = action {
      let tapGesture = UITapGestureRecognizer(target: self, action: action)
      containerView.addGestureRecognizer(tapGesture)
      containerView.isUserInteractionEnabled = true
    }
    
    return containerView
  }
  
  private lazy var titleLabel: UILabel = {
    let label = UILabel()
//    label.text = "Moneycat"
//    label.font = .systemFont(ofSize: 20, weight: .heavy)
//    label.textColor = UIColor.white
//
//    label.layer.shadowColor = UIColor.white.cgColor
//    label.layer.shadowOffset = CGSize(width: 0, height: 0)
//    label.layer.shadowRadius = 2.0
//    label.layer.shadowOpacity = 1.0

//    let paragraph = NSMutableParagraphStyle()
//    paragraph.alignment = .center
//
    label.attributedText = NSAttributedString.init(string: "Moneycat",
                                                   attributes: [.font : UIFont.systemFont(ofSize: 20, weight: .heavy),
                                                                .foregroundColor : UIColor.white,
                                                                .strokeColor : UIColor.white,
                                                                .strokeWidth : -8
                                                               ])
    
    let l = UILabel()
    label.addSubview(l)
    l.text = label.text
    l.font = label.font
    l.textColor = UIColor(hex: "06101C")
    l.font = .systemFont(ofSize: 20, weight: .heavy)
    l.snp.makeConstraints { make in
      make.center.equalTo(label)
    }
    
    return label
  }()
  
  private lazy var subTitleLabel: UILabel = {
    let label = UILabel()
    label.text = "Borrowing Money Is So Easy!"
    label.font = .systemFont(ofSize: 14, weight: .medium)
    label.textColor = UIColor(hex: "06101C")
    return label
  }()
  

  private lazy var upperLogoImageView: UIImageView = {
    let imageView = UIImageView(image: UIImage(named: "mine_upperlogo"))
    imageView.contentMode = .scaleAspectFit
    return imageView
  }()
  
  private lazy var infoContainerImageView: UIImageView = {
    let imageView = UIImageView(image: UIImage(named: "mine_info_container"))
    imageView.contentMode = .scaleAspectFit
    imageView.isUserInteractionEnabled = true
    return imageView
  }()
  
  private lazy var avatarImageView: UIImageView = {
    let imageView = UIImageView(image: UIImage(named: "mine_avatar"))
    imageView.contentMode = .scaleAspectFill
    imageView.clipsToBounds = true
    imageView.layer.cornerRadius = 30 // 设置为宽高的一半以实现圆形效果
    return imageView
  }()
  
  private lazy var phoneNumberLabel: UILabel = {
    let label = UILabel()
    label.text = "+63 \(UserDefaults.standard.string(forKey: "phoneNumber")?.masked() ?? "Unknown")"
    label.font = .systemFont(ofSize: 20, weight: .medium)
    label.textColor = UIColor(hex: "06101C")
    return label
  }()
  
  private func createInfoButton(imageName: String, title: String, action: Selector) -> UIView {
    let containerView = UIView()
    containerView.isUserInteractionEnabled = true  // 确保容器可以接收点击事件
    
    let iconImageView = UIImageView(image: UIImage(named: imageName))
    iconImageView.contentMode = .scaleAspectFit
    iconImageView.isUserInteractionEnabled = true
    let titleLabel = UILabel()
    titleLabel.text = title
    titleLabel.font = .systemFont(ofSize: 14, weight: .medium)
    titleLabel.textColor = UIColor(hex: "06101C")
    titleLabel.numberOfLines = 0
    titleLabel.isUserInteractionEnabled = true
    
    containerView.addSubview(iconImageView)
    containerView.addSubview(titleLabel)
    
    iconImageView.snp.makeConstraints { make in
      make.leading.equalToSuperview()
      make.centerY.equalToSuperview()
      make.size.equalTo(CGSize(width: 24, height: 24))
    }
    
    titleLabel.snp.makeConstraints { make in
      make.leading.equalTo(iconImageView.snp.trailing).offset(8)
      make.centerY.equalToSuperview()
      make.trailing.lessThanOrEqualToSuperview()  // 添加trailing约束
    }
    
    // 修改这里：使用 self 作为 target
    let tapGesture = UITapGestureRecognizer(target: self, action: action)
    titleLabel.addGestureRecognizer(tapGesture)
    iconImageView.addGestureRecognizer(tapGesture)
    
    return containerView
  }
  
  // 添加按钮点击方法
  @objc private func myLoanButtonTapped() {
//    if let tabBarController = UIApplication.shared.keyWindow?.rootViewController as? UITabBarController {
//        tabBarController.selectedIndex = 1  // 假设 loan tab 是第一个标签页
//        self.dismiss(animated: true)
//    }
    
    if let windowScene = self.view.window?.windowScene,
       let sceneDelegate = windowScene.delegate as? SceneDelegate {
      sceneDelegate.switchToRecordTab()
    }
    
    
}
  
  @objc private func customerServiceButtonTapped() {
    
    
    var urlString = APIConfig.customerURL
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
    
    // 显示 WebView
    let webViewController = MyWebViewController(urlString: urlString)
    //            self.navigationController?.pushViewController(webViewController, animated: true)
    let navc = UINavigationController(rootViewController: webViewController)
    navc.modalPresentationStyle = .fullScreen
    present(navc, animated: true)
  

  }

  
  @objc private func privacyAgreementTapped() {
    let vc = MyWebViewController(urlString: APIConfig.privacyURL)
    let navc = UINavigationController(rootViewController: vc)
    navc.modalPresentationStyle = .fullScreen
    present(navc, animated: true)
  }
  
  @objc private func goOutTapped() {
      let setupVC = SetupViewController()
      // navigationController is likely hidden in MineViewController, but we can try pushing
      // MineViewController hides navigation bar in viewDidLoad: navigationController?.setNavigationBarHidden(true, animated: false)
      // So pushing should work fine, and SetupViewController also hides it or manages it.
      // SetupViewController has its own custom navigation bar and back button.
      navigationController?.pushViewController(setupVC, animated: true)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
       let sceneDelegate = windowScene.delegate as? SceneDelegate {
      
      sceneDelegate.tabWindow?.isHidden = false
    }
  }
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // 隐藏导航栏
    navigationController?.setNavigationBarHidden(true, animated: false)
    
    // 设置背景色
    view.backgroundColor = .white
    
    // 添加视图
    view.addSubview(topImageView)
    view.addSubview(containerView)
    
    // 设置约束
    topImageView.snp.makeConstraints { make in
      make.leading.trailing.top.equalToSuperview()
    }
    
    containerView.snp.makeConstraints { make in
      make.leading.trailing.bottom.equalToSuperview()
      make.top.equalTo(topImageView.snp.bottom).offset(-20) // 向上覆盖 20pt
    }
    
    // 添加 tips 图片
    containerView.addSubview(tipsImageView)
    let tapTip = UITapGestureRecognizer(target: self, action: #selector(tapTip))
    tipsImageView.addGestureRecognizer(tapTip)
    // 设置 tips 图片约束
    tipsImageView.snp.makeConstraints { make in
      make.top.equalTo(containerView).offset(20)
      make.centerX.equalTo(containerView)
      // 使用图片原始大小
      if let image = UIImage(named: "mine_tips") {
        make.size.equalTo(CGSize(width: image.size.width, height: image.size.height))
      }
    }
    
    // 添加 stackView
    containerView.addSubview(stackView)
    stackView.isUserInteractionEnabled = true
    // 设置 stackView 约束
    stackView.snp.makeConstraints { make in
      make.top.equalTo(tipsImageView.snp.bottom).offset(20)
      make.centerX.equalToSuperview()
    }
    
    // 添加 cell 项
    let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "1.0.0"
    let items = [
      (title: "Privacy Agreement", imageName: "mine_privacy", showArrow: true, version: nil as String?, action: #selector(privacyAgreementTapped) as Selector?),
      (title: "Version", imageName: "mine_version", showArrow: false, version: version, action: nil as Selector?),
      (title: "Set up", imageName: "mine_goout", showArrow: true, version: nil as String?, action: #selector(goOutTapped) as Selector?)
    ]
    
    for item in items {
      let cellView = createCellView(title: item.title,
                                    imageName: item.imageName,
                                    showArrow: item.showArrow,
                                    versionText: item.version,
                                    action: item.action)
      stackView.addArrangedSubview(cellView)
    }
    

    // 添加标题标签
    view.addSubview(titleLabel)
    
    // 设置标题标签约束
    titleLabel.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(56)
      make.leading.equalToSuperview().offset(20)
    }
    
    // 添加标题标签
    view.addSubview(subTitleLabel)
    
    // 设置标题标签约束
    subTitleLabel.snp.makeConstraints { make in
      make.top.equalTo(titleLabel.snp.bottom).offset(8)
      make.leading.equalToSuperview().offset(20)
    }
    
    // 添加 upper logo
    view.addSubview(upperLogoImageView)
    
    // 设置 upper logo 约束
    upperLogoImageView.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(44)
      make.trailing.equalToSuperview().offset(-20)
      // 使用图片原始大小
      if let image = UIImage(named: "mine_upperlogo") {
        make.size.equalTo(CGSize(width: image.size.width, height: image.size.height))
      }
    }
    
    // 添加 info container
    view.addSubview(infoContainerImageView)
    
    // 设置 info container 约束
    infoContainerImageView.snp.makeConstraints { make in
      make.bottom.equalTo(containerView.snp.top)
      make.centerX.equalToSuperview()
      // 使用图片原始大小
      if let image = UIImage(named: "mine_info_container") {
        make.size.equalTo(CGSize(width: image.size.width, height: image.size.height))
      }
    }
    
    // 添加头像和电话号码
    infoContainerImageView.addSubview(avatarImageView)
    infoContainerImageView.addSubview(phoneNumberLabel)
    
    // 设置头像约束
    avatarImageView.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(20)
      make.leading.equalToSuperview().offset(60)
      make.size.equalTo(CGSize(width: 60, height: 60))
    }
    
    // 设置电话号码标签约束
    phoneNumberLabel.snp.makeConstraints { make in
      make.leading.equalTo(avatarImageView.snp.trailing).offset(12)
      make.centerY.equalTo(avatarImageView)
    }
    
    // 创建按钮容器视图
    let buttonsContainer = UIView()
    buttonsContainer.isUserInteractionEnabled = true

    infoContainerImageView.addSubview(buttonsContainer)
    
    // 创建两个按钮
    let myLoanButton = createInfoButton(imageName: "mine_myloan",
                                        title: "My loan",
                                        action: #selector(myLoanButtonTapped))
    let customerServiceButton = createInfoButton(imageName: "mine_customerservice",
                                                 title: "Customer\nservice",
                                                 action: #selector(customerServiceButtonTapped))
    
    buttonsContainer.addSubview(myLoanButton)
    buttonsContainer.addSubview(customerServiceButton)
    
    // 设置按钮容器约束
    buttonsContainer.snp.makeConstraints { make in
      make.top.equalTo(avatarImageView.snp.bottom).offset(20)
      make.leading.trailing.equalToSuperview().inset(20)
      make.height.equalTo(60)  // 增加容器高度
      make.bottom.equalToSuperview().offset(-20)  // 添加底部间距
    }
    
    // 设置按钮约束
    myLoanButton.snp.makeConstraints { make in
      make.leading.equalToSuperview().offset(30)
      make.centerY.equalToSuperview()
      make.width.equalTo(buttonsContainer.snp.width).multipliedBy(0.4)
    }
    
    customerServiceButton.snp.makeConstraints { make in
      make.trailing.equalToSuperview().offset(-30)
      make.centerY.equalToSuperview()
      make.width.equalTo(buttonsContainer.snp.width).multipliedBy(0.4)
    }
    
    let leftButton = UIButton(type: .custom)
    leftButton.translatesAutoresizingMaskIntoConstraints = false
    buttonsContainer.addSubview(leftButton)
    leftButton.addTarget(self, action: #selector(myLoanButtonTapped), for: .touchUpInside)
    leftButton.snp.makeConstraints { make in
      make.leading.top.bottom.equalToSuperview()
      make.width.equalToSuperview().multipliedBy(0.5)
    }
    
    let rightButton = UIButton(type: .custom)
    rightButton.translatesAutoresizingMaskIntoConstraints = false
    buttonsContainer.addSubview(rightButton)
    rightButton.addTarget(self, action: #selector(customerServiceButtonTapped), for: .touchUpInside)
    rightButton.snp.makeConstraints { make in
      make.trailing.top.bottom.equalToSuperview()
      make.width.equalToSuperview().multipliedBy(0.5)
    }
  }
  
  @objc func tapTip() {
    let vc = MyWebViewController(urlString: APIConfig.privacyURL)
    let navc = UINavigationController(rootViewController: vc)
    navc.modalPresentationStyle = .fullScreen
    present(navc, animated: true)
  }
}
