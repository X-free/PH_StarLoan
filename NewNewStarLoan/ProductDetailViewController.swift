//
//  ProductDetailViewController.swift
//  NewNewStarLoan
//
//  Created by Albert on 2025/5/6.
//

import Foundation
import UIKit
import SnapKit
import ProgressHUD
import AdSupport
import MJRefresh

struct AuthItem {
  let baseImageName: String
  let isFinished: Bool
  let cousin: String
}

class ProductDetailViewController: UIViewController {
  private let analy = AnalyticsService()
  private var isProcessingBorrow = false
  private let borrowButtonCooldown: TimeInterval = 1.0
  
  var dismissCallback: (() -> Void)?
  weak var sceneDelegate: SceneDelegate?
  private var authItems: [AuthItem] = []
  private var idTypeData: [[String]] = []
  
  override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      // 隐藏 tabWindow

    fetchProductDetail()
  }
  
  var productDetail: ProductDetailResponse? {
    didSet {
      let amount = productDetail?.middle.tag.family
      amountLabel.text = "₱\(amount ?? 76000)"
      
      let day = productDetail?.middle.tag.shrieking
      let rate = productDetail?.middle.tag.afghans
      daysLabel.text = "\(day ?? "180") days | \(rate ?? "0.05")/day"
      borrowButton.setTitle(productDetail?.middle.tag.vomiting, for: .normal)
      
      if let title = productDetail?.middle.tag.cratered {
        navigationBar.setTitle(title)
      }
      
      // 更新认证项数据
      if let engineering = productDetail?.middle.engineering {
        authItems = engineering.map { item in
          let baseImageName: String
          switch item.cousin {
          case "nbaallstarf":
            baseImageName = "auth_verify"
          case "nbaallstarg":
            baseImageName = "auth_personal"
          case "nbaallstarh":
            baseImageName = "auth_work"
          case "nbaallstari":
            baseImageName = "auth_contact"
          case "nbaallstarj":
            baseImageName = "auth_bank"
          default:
            baseImageName = "auth_verify"
          }
          return AuthItem(baseImageName: baseImageName, isFinished: item.actually == 1, cousin: item.cousin)
        }
        tableView.reloadData()
      }
    }
  }
  
  var productId: String? 
  
  
  
  private lazy var tableView: UITableView = {
    let tableView = UITableView()
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(AuthCell.self, forCellReuseIdentifier: "AuthCell")
    tableView.separatorStyle = .none
    tableView.backgroundColor = .clear
    tableView.showsVerticalScrollIndicator = false
    tableView.isScrollEnabled = true
    return tableView
  }()
  
  private lazy var containerView: UIView = {
    let view = UIView()
    view.backgroundColor = .white
    view.layer.cornerRadius = 18.0
    view.layer.masksToBounds = true
    return view
  }()
  
  private lazy var navigationBar: CustomNavigationBar = {
    let nav = CustomNavigationBar()
    nav.backButtonTapped = { [weak self] in
      self?.dismissCallback?()  // 调用关闭回调
      self?.dismiss(animated: true)
    }
    return nav
  }()
  
  private lazy var backgroundImageView: UIImageView = {
    let imageView = UIImageView(image: UIImage(named: "cpxq_bg"))
    imageView.isUserInteractionEnabled = true
    return imageView
  }()
  
  private lazy var containerImageView: UIImageView = {
    let imageView = UIImageView(image: UIImage(named: "cpxq_container_top"))
    return imageView
  }()
  
  private lazy var amountLabel: UILabel = {
    let label = UILabel()
    label.text = "₱7,6000"
    label.font = .systemFont(ofSize: 46, weight: .heavy)
    label.textColor = UIColor(hex: "06101C")
    
    // 添加阴影效果
    label.layer.shadowColor = UIColor(hex: "6FF99F").cgColor
    label.layer.shadowOffset = CGSize(width: 2, height: 2)
    label.layer.shadowRadius = 0
    label.layer.shadowOpacity = 1.0
    
    // 添加旋转效果（-3度）
    label.transform = CGAffineTransform(rotationAngle: -3 * .pi / 180)
    
    return label
  }()
  
  private lazy var daysLabel: UILabel = {
    let label = UILabel()
    label.text = "180 | 0.05%/day"
    label.font = .systemFont(ofSize: 14, weight: .medium)
    label.textColor = UIColor(hex: "6C6C6C")
    
    // 添加旋转效果（-3度）
    label.transform = CGAffineTransform(rotationAngle: -3 * .pi / 180)
    return label
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .white
    // 在视图加载时就隐藏 tabWindow
        // 确保在主线程中执行 UI 更新
        DispatchQueue.main.async { [weak self] in
            self?.sceneDelegate?.tabWindow?.isHidden = true
        }
    setupUI()
    
    ProgressHUD.animate("Fetching...")
    Task {
      let _ = try await AddressManager.shared.getAddress()
      ProgressHUD.dismiss()
    }
    
    setupRefreshControl()
    
    // 获取设备信息并加密
    let deviceInfo = DeviceInfoModel.current()
    let encryptedString = deviceInfo.toEncryptedString()
    Task {
      do {
        let _ = try await RiskService.shared.detail(middle: encryptedString)
        
      }
    }
    
    LoactionUpDataManager.manager.startUpLocation()
  }
  
  
  private lazy var borrowButton: UIButton = {
    let button = UIButton(type: .custom)
    button.setBackgroundImage(UIImage(named: "cpxq_b"), for: .normal)
    button.setTitle("Borrow Money", for: .normal)
    button.titleLabel?.font = .systemFont(ofSize: 16, weight: .heavy)
    button.setTitleColor(.white, for: .normal)
    return button
  }()
  
  private func setupUI() {
    // 隐藏系统导航栏
    navigationController?.setNavigationBarHidden(true, animated: false)
    
    // 添加自定义导航栏
    view.addSubview(navigationBar)
    view.addSubview(backgroundImageView)
    view.addSubview(borrowButton)
    
    
    // 设置导航栏约束
    navigationBar.snp.makeConstraints { make in
      make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
      make.leading.trailing.equalToSuperview()
      make.height.equalTo(44)
    }
    
    // 设置标题
    navigationBar.setTitle("Product Details")
    
    backgroundImageView.snp.makeConstraints { make in
      make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(44)
      make.leading.trailing.equalToSuperview()     // 左右充满
      make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20 - 44 - 14)
    }
    
    // 添加借款按钮
    borrowButton.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
      make.width.equalTo(337)
      make.height.equalTo(44)
    }
    
    backgroundImageView.addSubview(containerImageView)
    containerImageView.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.top.equalToSuperview().offset(20)
    }
    
    // 添加金额标签
    containerImageView.addSubview(amountLabel)
    amountLabel.snp.makeConstraints { make in
      make.centerX.equalToSuperview().offset(40)
      make.top.equalToSuperview().offset(30)
    }
    
    // 添加天数标签
    containerImageView.addSubview(daysLabel)
    daysLabel.snp.makeConstraints { make in
      make.trailing.equalTo(amountLabel)
      make.top.equalTo(amountLabel.snp.bottom).offset(-2)
    }
    
    backgroundImageView.addSubview(containerView)
    containerView.snp.makeConstraints { make in
      make.bottom.equalToSuperview().offset(-10)
      make.width.equalTo(337)
      make.centerX.equalToSuperview()
      make.top.equalTo(containerImageView.snp.bottom).offset(10)
    }
    
    containerView.addSubview(tableView)
    tableView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    
    borrowButton.addTarget(self, action: #selector(borrowButtonDidTapped), for: .touchUpInside)
  }
  
  private func setupRefreshControl() {
    let header = MJRefreshNormalHeader(refreshingTarget: self,
                                       refreshingAction: #selector(fetchProductDetail))
    header.setTitle("Pull down to refresh", for: .idle)
    header.setTitle("Release to refresh", for: .pulling)
    header.setTitle("Loading...", for: .refreshing)
    header.lastUpdatedTimeLabel?.isHidden = true // Hide last update time label
    
    tableView.mj_header = header
  }
  
  @objc func borrowButtonDidTapped() {
    // 防止重复点击
    guard !isProcessingBorrow else { return }
    isProcessingBorrow = true
    
    // 延迟重置状态
    DispatchQueue.main.asyncAfter(deadline: .now() + borrowButtonCooldown) { [weak self] in
        self?.isProcessingBorrow = false
    }
    
    if let wedneskpiday = productDetail?.middle.wedneskpiday {
      switch wedneskpiday.cousin {
      case "nbaallstarf":
        handleAuthWay()
      case "nbaallstarg":
        ProgressHUD.animate("Fetching...")
        Task {
          do {
            let response = try await CertificateService.shared.getUserInfo(feud: productId!)  // 使用 productId
            await MainActor.run {
              ProgressHUD.dismiss()
              let vc = AuthPersonalInfoViewController(viewModel: AuthPersonalInfoViewModel(formFields: response.middle.stopped, productId: productId!))
              self.navigationController?.pushViewController(vc, animated: true)
            }
          } catch {
            
          }
        }
        
        break
        
      case "nbaallstarh":
        ProgressHUD.animate("Fetching...")
        Task {
          do {
            let response = try await CertificateService.shared.getWorkInfo(feud: productId!)  // 使用 productId
            await MainActor.run {
              ProgressHUD.dismiss()
              let vc = AuthWorkInfoViewController(viewModel: AuthWorkInfoViewModel(formFields: response.middle.stopped, productId: productId!))
              self.navigationController?.pushViewController(vc, animated: true)
            }
          } catch {
            
          }
        }
        break
        
      case "nbaallstari":
        ProgressHUD.animate("Fetching...")
        Task {
          do {
            let response = try await CertificateService.shared.getContactInfo(feud: productId!)  // 使用 productId
            await MainActor.run {
              ProgressHUD.dismiss()
              let vc = AuthContactViewController(viewModel: AuthContactViewModel(formData: response.middle.intellectual, productId: productId!))
              self.navigationController?.pushViewController(vc, animated: true)
            }
          } catch {
            
          }
        }
        break
        
      case "nbaallstarj":
        ProgressHUD.animate("Fetching...")
        Task {
          do {
            let response = try await CertificateService.shared.getBankCardInfo()
            await MainActor.run {
              ProgressHUD.dismiss()
              let vc = AuthBankInfoViewController(formData: response.middle, productId: productId!)
              self.navigationController?.pushViewController(vc, animated: true)

            }
          }
        }
        break
        
      default:
        break
      }
    } else {
      if let orderNumber = productDetail?.middle.tag.herat {
        let end9 = Int(Date().timeIntervalSince1970)
        MaidianRistManager.manager.upload(foreground: productId ?? "", hammersmith: "9", welcome: "\(end9)", deal: "\(end9)")
        
        Task {
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
        }
      }
    }
  }
  
  func handleAuthWay() {
    ProgressHUD.animate("Fetching...")
    Task {
      do {
        let result = try await CertificateService.shared.getUserPublicInfo(
          feud: productId ?? "3",
          warm: String.generateUUID()
        )
        ProgressHUD.dismiss()
        await MainActor.run {
          idTypeData = result.middle.brow
          
          if result.middle.winked.actually == 0 {
            let vc = AuthWayViewController(idTypes: idTypeData, productId: productId ?? "2")
            self.navigationController?.pushViewController(vc, animated: true)
          } else {
            if result.middle.furrowed == 0 {
              let idType = result.middle.winked.fun
              let vc = AuthFaceViewController(idType: idType!, productId: productId ?? "2")
              self.navigationController?.pushViewController(vc, animated: true)
            } else {
              
            }
          }
        }
      }
    }
  }
  
  @objc private func fetchProductDetail() {
    Task {
      do {
        let result = try await ProductService.shared.getProductDetail(
          feud: productId!,
          staying: String.generateUUID(),
          since: String.generateUUID()
        )

        await MainActor.run {
          productDetail = result
          
          tableView.mj_header?.endRefreshing()
          if let wedneskpiday = result.middle.wedneskpiday {
            print("产品详情数据：", wedneskpiday.cousin)
          }
        }
      } catch {
        print("获取产品详情失败：\(error)")
      }
    }
  }
}





// 修改 TableView 数据源方法
extension ProductDetailViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return authItems.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "AuthCell", for: indexPath) as! AuthCell
    cell.configure(with: authItems[indexPath.row])
    cell.selectionStyle = .none
    cell.backgroundColor = .clear
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    
    let certItem:AuthItem = authItems[indexPath.row]
    if certItem.cousin == "nbaallstarf" {
      if certItem.isFinished == true {
        let vc = AuthPublicSuccessViewController(productId: productId!)
        self.navigationController?.pushViewController(vc, animated: true)
      } else {
        Task {
          await borrowButtonDidTapped()
        }
      }
    } else {
      if certItem.isFinished == false {
        Task {
          await borrowButtonDidTapped()
        }
      } else {
        if certItem.cousin == "nbaallstarg" {
          ProgressHUD.animate("Fetching...")
          Task {
            do {
              let response = try await CertificateService.shared.getUserInfo(feud: productId!)  // 使用 productId
              await MainActor.run {
                ProgressHUD.dismiss()
                let vc = AuthPersonalInfoViewController(viewModel: AuthPersonalInfoViewModel(formFields: response.middle.stopped, productId: productId!))
                self.navigationController?.pushViewController(vc, animated: true)
              }
            } catch {
              
            }
          }
        } else if certItem.cousin == "nbaallstarh" {
          ProgressHUD.animate("Fetching...")
          Task {
            do {
              let response = try await CertificateService.shared.getWorkInfo(feud: productId!)  // 使用 productId
              await MainActor.run {
                ProgressHUD.dismiss()
                let vc = AuthWorkInfoViewController(viewModel: AuthWorkInfoViewModel(formFields: response.middle.stopped, productId: productId!))
                self.navigationController?.pushViewController(vc, animated: true)
              }
            } catch {
              
            }
          }
        } else if certItem.cousin == "nbaallstari" {
          ProgressHUD.animate("Fetching...")
          Task {
            do {
              let response = try await CertificateService.shared.getContactInfo(feud: productId!)  // 使用 productId
              await MainActor.run {
                ProgressHUD.dismiss()
                let vc = AuthContactViewController(viewModel: AuthContactViewModel(formData: response.middle.intellectual, productId: productId!))
                self.navigationController?.pushViewController(vc, animated: true)
              }
            } catch {
              
            }
          }
        } else if certItem.cousin == "nbaallstarj" {
          ProgressHUD.animate("Fetching...")
          Task {
            do {
              let response = try await CertificateService.shared.getBankCardInfo()
              await MainActor.run {
                ProgressHUD.dismiss()
                let vc = AuthBankInfoViewController(formData: response.middle, productId: productId!)
                self.navigationController?.pushViewController(vc, animated: true)

              }
            }
          }
        }
      }

    }
  }
}
