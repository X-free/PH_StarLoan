//
//  RecordsViewController.swift
//  NewNewStarLoan
//
//  Created by Albert on 2025/5/5.
//
import ProgressHUD
import Foundation
import UIKit
import SnapKit
import DZNEmptyDataSet
import MJRefresh
import Alamofire

// 在 RecordItemType 中添加
enum RecordItemType {
  case delay
  case repay
  case finish
  case apply
  case review
  
  var image: String {
    switch self {
    case .delay: return "dd_delay_bg"
    case .repay: return "dd_repay_bg"
    case .finish: return "dd_finish_bg"
    case .apply: return "dd_apply_bg"
    case .review: return "dd_review_bg"
    }
  }
  
  var description: String? {
    switch self {
    case .delay: return "If you are 3 days late, pay immediately"
    case .repay: return "Pay on time to increase your credit score, pay now"
    default: return nil
    }
  }
  
  var label: String {
    switch self {
    case .delay: return "Delay"
    case .repay: return "Repayment"
    case .finish: return "Finish"
    case .apply: return "Apply"
    case .review: return "Review"
    }
  }
  
  var buttonTitle: String? {
    switch self {
    case .delay, .repay: return "Repayment"
    case .apply: return "Go Apply"
    default: return nil
    }
  }
}

class RecordsViewController: UIViewController {
  private let reachabilityManager = NetworkReachabilityManager()
  private lazy var backgroundImage: UIImageView = {
    let imageView = UIImageView(image: UIImage(named: "dd_k_bg"))
    imageView.contentMode = .scaleAspectFill
    imageView.isUserInteractionEnabled = true
    return imageView
  }()
  
  private lazy var bannerImageView: UIImageView = {
    let imageView = UIImageView(image: UIImage(named: "dd_banner"))
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
    
    return view
  }()
  
  private lazy var scrollView: UIScrollView = {
    let scrollView = UIScrollView()
    scrollView.showsHorizontalScrollIndicator = false
    return scrollView
  }()
  
  private lazy var tableView: UITableView = {
    let tableView = UITableView()
    tableView.delegate = self
    tableView.dataSource = self
    tableView.emptyDataSetSource = self
    tableView.emptyDataSetDelegate = self
    tableView.register(NewRecordTableViewCell.self, forCellReuseIdentifier: NewRecordTableViewCell.cellIdentifier)
    tableView.separatorStyle = .none
    tableView.backgroundColor = .clear
    tableView.showsVerticalScrollIndicator = false
    tableView.isScrollEnabled = true
    tableView.estimatedRowHeight = 180
    tableView.rowHeight = UITableView.automaticDimension
    return tableView
  }()
  
  private var hasNetwork = true {
    didSet {
      tableView.reloadEmptyDataSet()
    }
  }
  
  
  private var selectedIndex = 0 // 添加选中索引的跟踪
  private var orderList: OrderListResponse? {
    didSet {
      tableView.reloadData()
    }
  }
  
  private lazy var buttonStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.spacing = 8
    stackView.distribution = .fillProportionally // 改为 fillProportionally 以保持原始尺寸
    stackView.alignment = .top // 确保向上对齐
    return stackView
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // 隐藏导航栏
    navigationController?.setNavigationBarHidden(true, animated: false)
    
    // 设置背景色
    view.backgroundColor = .white
    
    view.addSubview(backgroundImage)
    backgroundImage.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    
    backgroundImage.addSubview(bannerImageView)
    bannerImageView.snp.makeConstraints { make in
      make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
      make.leading.trailing.equalToSuperview()
    }
    
    backgroundImage.addSubview(containerView)
    containerView.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview().inset(20)
      make.top.equalTo(bannerImageView.snp.bottom).offset(15)
      make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
    }
    
    containerView.addSubview(scrollView)
    
    scrollView.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(15)
      make.height.equalTo(54)
      make.leading.trailing.equalToSuperview().inset(15)
    }
    
    containerView.addSubview(tableView)
    tableView.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview()
      make.top.equalTo(scrollView.snp.bottom).offset(15)
      make.bottom.equalToSuperview().inset(15)
    }
    
    scrollView.addSubview(buttonStackView)
    buttonStackView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    
//    fetchOrderList()
    
    // 添加按钮
    let buttons = ["All", "Repayment", "Applying", "Finish"]
    for (index, title) in buttons.enumerated() {
      let button = UIButton(type: .custom)
      button.setTitle(title, for: .normal)
      button.setBackgroundImage(UIImage(named: "dd_bg_unselected"), for: .normal)
      button.setBackgroundImage(UIImage(named: "dd_bg_selected"), for: .selected)
      button.setTitleColor(.init(hex: "4999F7"), for: .normal)
      button.setTitleColor(.white, for: .selected)
      button.titleLabel?.font = .systemFont(ofSize: 14, weight: .heavy)
      button.tag = index
      button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
      buttonStackView.addArrangedSubview(button)
      
      // 设置按钮的尺寸约束
      button.snp.makeConstraints { make in
        make.width.equalTo(98)
        if index == 0 {
          make.height.equalTo(51) // 选中状态的高度
        } else {
          make.height.equalTo(44) // 未选中状态的高度
        }
      }
      
      // 设置标题的偏移
      if index == 0 {
        button.titleEdgeInsets = UIEdgeInsets(top: -7, left: 0, bottom: 0, right: 0)
      }
      
      // 设置第一个按钮为选中状态
      if index == 0 {
        button.isSelected = true
      }
    }
    setupRefreshControl()
    setupNetworkMonitoring()
  }
  
  private func setupNetworkMonitoring() {
    reachabilityManager?.startListening { [weak self] status in
      guard let self = self else { return }
      
      switch status {
      case .reachable(_):
        self.hasNetwork = true
        // 如果恢复网络，自动刷新数据
        self.fetchOrderList()
      case .notReachable:
        self.hasNetwork = false
      case .unknown:
        self.hasNetwork = false
      }
    }
  }
  
  deinit {
    reachabilityManager?.stopListening()
  }
  
  
  @objc private func buttonTapped(_ sender: UIButton) {
    // 更新所有按钮状态和高度
    buttonStackView.arrangedSubviews.forEach { view in
      if let button = view as? UIButton {
        let isSelected = button.tag == sender.tag
        button.isSelected = isSelected
        
        // 更新按钮高度
        button.snp.updateConstraints { make in
          make.height.equalTo(isSelected ? 51 : 44)
        }
        
        // 更新标题偏移
        button.titleEdgeInsets = isSelected ?
        UIEdgeInsets(top: -7, left: 0, bottom: 0, right: 0) :
          .zero
      }
    }
    selectedIndex = sender.tag
    
    // 添加动画效果
    UIView.animate(withDuration: 0.3) {
      self.view.layoutIfNeeded()
    }
    
    fetchOrderList()
  }
  
  // 添加获取订单列表方法
  private func fetchOrderList() {
    ProgressHUD.animate("Fetching...")
    // 根据选中的标签获取对应的参数
    let outlined: String
    switch selectedIndex {
    case 0: // All
      outlined = "4"
    case 1: // Repayment
      outlined = "6"
    case 2: // Applying
      outlined = "7"
    case 3: // Finish
      outlined = "5"
    default:
      outlined = "4"
    }
    
    Task {
      do {
        let result = try await OrderService.shared.fetchOrderList(
          outlined: outlined
        )
        await MainActor.run {
          orderList = result
          self.tableView.mj_header?.endRefreshing()
          ProgressHUD.dismiss()
        }
      } catch {
        orderList = nil
        ProgressHUD.dismiss()
      }
    }
  }
}





extension RecordsViewController: UITableViewDataSource, UITableViewDelegate {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//    return 0
    return orderList?.middle.dog.count ?? 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: NewRecordTableViewCell.cellIdentifier) as? NewRecordTableViewCell,
          let item = orderList?.middle.dog[indexPath.row] else {
      return UITableViewCell()
    }
    
    cell.configure(with: item)
    return cell
  }
  
  //    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
  //        // 如果有警告信息，需要额外的高度
  //      if let item = orderList?.middle.dog[indexPath.row],
  //           !item.liveries.shoulder.isEmpty {
  //            return 180 // 带警告信息的高度
  //        }
  //        return 150 // 标准高度
  //    }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    
    let order = orderList?.middle.dog[indexPath.row]
    if let url = order?.dairy {
      if url.hasPrefix("http") {
        let urlWithParams = appendCommonParams(to: url)
        navigateToWebView(with: urlWithParams)
      } else {
//        if let deobfuscatedURL = URLObfuscateManager.shared.deobfuscateURL(for: order!.dairy),
//           let openURL = URL(string: deobfuscatedURL) {
//          UIApplication.shared.open(openURL, options: [:], completionHandler: nil)
//        }
        
        let arr = url.components(separatedBy: "feud=")
        let pro = arr.last ?? ""
        let vc = ProductDetailViewController()
        vc.productId = pro
        
        let navc = UINavigationController(rootViewController: vc)
        navc.modalPresentationStyle = .fullScreen
        self.present(navc, animated: true)
        
      }
    }
    
  }
  
  private func appendCommonParams(to urlString: String) -> String {
    var finalURL = urlString
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
    
    let queryItems = commonParams.map { key, value in
      "\(key)=\(value)"
    }.joined(separator: "&")
    
    finalURL += finalURL.contains("?") ? "&\(queryItems)" : "?\(queryItems)"
    print("处理后的URL：", finalURL)
    return finalURL
  }
  
  private func navigateToWebView(with urlString: String) {
    let webViewController = MyWebViewController(urlString: urlString)
    navigationController?.resetToRootAndPush(webViewController)
  }
}

extension RecordsViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
  func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
    let text = hasNetwork ? "No orders yet" : "No network yet"
    
    let attributes: [NSAttributedString.Key: Any] = [
      .font: UIFont.systemFont(ofSize: 13, weight: .regular),
      .foregroundColor: UIColor(hex: "6c6c6c"),
      .paragraphStyle: {
        let style = NSMutableParagraphStyle()
        style.alignment = .center
        style.lineBreakMode = .byWordWrapping
        return style
      }()
    ]
    
    return NSAttributedString(string: text, attributes: attributes)
  }
  
  
  // Rest of empty data set methods remain the same...
  func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
      return hasNetwork ? UIImage(named: "dd_k_ic") : UIImage(named: "wl_k_ic")
  }
  
  func buttonTitle(forEmptyDataSet scrollView: UIScrollView!, for state: UIControl.State) -> NSAttributedString! {
      let text = hasNetwork ? "Borrow Money" : "Refresh"
      
      let attributes: [NSAttributedString.Key: Any] = [
          .font: UIFont.systemFont(ofSize: 14, weight: .medium),
          .foregroundColor: UIColor(hex: "4999F7")
      ]
      
      return NSAttributedString(string: text, attributes: attributes)
  }
  
  // 添加按钮点击事件处理
  func emptyDataSet(_ scrollView: UIScrollView!, didTap button: UIButton!) {
      if hasNetwork {
          // 跳转到借款页面
          if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
             let sceneDelegate = windowScene.delegate as? SceneDelegate {
              sceneDelegate.switchToLoanTab()
          }
      } else {
          // 刷新数据
          fetchOrderList()
      }
  }
  
  private func buttonBackgroundColor(forEmptyDataSet scrollView: UIScrollView!) -> UIColor! {
      return .white
  }
    
}

extension RecordsViewController {
  func verticalOffset(forEmptyDataSet scrollView: UIScrollView) -> CGFloat {
      return -150 // Adjust this value to move the entire layout up
  }
  
  func spaceHeight(forEmptyDataSet scrollView: UIScrollView) -> CGFloat {
      return 0 // Space between image and title
  }
  
  func verticalSpace(forEmptyDataSet scrollView: UIScrollView, after space: CGFloat) -> CGFloat {
      return 44 // Space between title and button
  }
  
  func buttonImage(forEmptyDataSet scrollView: UIScrollView, for state: UIControl.State) -> UIImage? {
    return (hasNetwork ? UIImage(named: "order_empty") : UIImage(named: "order_refresh"))
  }
  
  private func setupRefreshControl() {
    let header = MJRefreshNormalHeader(refreshingTarget: self,
                                       refreshingAction: #selector(refreshData))
    header.setTitle("Pull down to refresh", for: .idle)
    header.setTitle("Release to refresh", for: .pulling)
    header.setTitle("Loading...", for: .refreshing)
    header.lastUpdatedTimeLabel?.isHidden = true // Hide last update time label
    
    tableView.mj_header = header
  }
  
  
  @objc private func refreshData() {
    // Fetch data for current type
    fetchOrderList()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
       let sceneDelegate = windowScene.delegate as? SceneDelegate {
      
      sceneDelegate.tabWindow?.isHidden = false
    }
    
    refreshData()
  }
}


