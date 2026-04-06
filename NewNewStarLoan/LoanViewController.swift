//
//  LoanViewController.swift
//  NewNewStarLoan
//
//  Created by Albert on 2025/5/5.
//

import Foundation
import UIKit
import MJRefresh
import ProgressHUD
import FBSDKCoreKit

class LoanViewController: UIViewController {
  private lazy var  locationService = LocationUpdateService()
  
  private lazy var productCollectionView: UICollectionView = {
      let layout = UICollectionViewFlowLayout()
      // 计算每行可以显示的个数（考虑间距）
      let screenWidth = UIScreen.main.bounds.width
      let totalHorizontalPadding = 20.0 * 2 + 15.0 * 3  // 左右边距 + 3个间距
      let itemHeight = (345 - 15 - 20 * 2)/2
    let itemWidth = 345 - 15 - 20 * 2
      
      layout.itemSize = CGSize(width: itemWidth, height: 120)
      layout.minimumLineSpacing = 12
      layout.minimumInteritemSpacing = 15
      layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
      
      let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.isScrollEnabled = false
      collectionView.backgroundColor = .clear
      collectionView.delegate = self
      collectionView.dataSource = self
      collectionView.register(ProductCell.self, forCellWithReuseIdentifier: "ProductCell")
      collectionView.showsVerticalScrollIndicator = false
      return collectionView
  }()
  
  // 添加一个数据源数组
  private var products: [KarimaProductInfo] = [] {
    didSet {
      self.productCollectionView.reloadData()
      let itemHeight = (345 - 15 - 20 * 2)/2
      let height = products.count * (itemHeight + 15) + 40
      
      self.productCollectionView.snp.updateConstraints { make in
        make.height.equalTo(height)
      }
    }
  }
  
  
  private var repayMessages: [String] = [] {
    didSet {
      updateMessage()
    }
  }
  
  private var repayURL: [String] = []
  
  private var currentMessageIndex = 0
  private var timer: Timer?
  
  // 添加数据解析方法
  private func parseRepayMessages(from tail: [RepaymentInfo]) {
      
      
      repayMessages = tail.map { item in
        item.seats
      }
    
  }
  
  private func parseRepayURL(from tail: [RepaymentInfo]) {
      
      
      repayURL = tail.map { item in
        item.trade
      }
    
  }
  
  private var homePageData: HomePageResponse? {
    didSet {
      //            amountLabel.text = "₱\(homePageData?.middle.counted.tail.first?.accountable"
      if let data = homePageData {
        UserDefaults.standard.set(homePageData?.middle.trek, forKey: "needToShowCustomLocationAlert")
        if data.middle.counted.mountainside == "nbaallstarc" {
          UIView.animate(withDuration: 0.3) {
              self.loanScrollView.alpha = 0
              self.spScrollView.alpha = 1
          } completion: { _ in
              self.loanScrollView.isHidden = true
              self.spScrollView.isHidden = false
          }
          self.spAmountLabel.text = "₱ " + "\(data.middle.counted.tail[0].accountable)"
          let day = data.middle.counted.tail[0].fine
          let rate = data.middle.counted.tail[0].car
          self.spDaysLabel.text = "\(day) | \(rate)/day"
          
          if let window = data.middle.window {
            let _ = parseRepayMessages(from: window.tail)
            let _ = parseRepayURL(from: window.tail)
            self.repayContainerView.isHidden = true
          } else {
            self.repayContainerView.isHidden = true
          }
          products = data.middle.karima?.tail ?? []
          spTopBannerLogoLabel.text = homePageData?.middle.counted.tail[0].cratered
          spTopBannerTitleLabel.text = homePageData?.middle.counted.tail[0].held
          spAvailableCreditLabel.text = homePageData?.middle.counted.tail[0].sickness
          
          spBorrowButton.setTitle(homePageData?.middle.counted.tail[0].vomiting, for: .normal) //
        } else {

          UIView.animate(withDuration: 0.3) {
              self.loanScrollView.alpha = 1
              self.spScrollView.alpha = 0
          } completion: { _ in
            self.loanScrollView.isHidden = false
            self.spScrollView.isHidden = true
          }
          let amount = homePageData?.middle.counted.tail.first?.accountable
          amountLabel.text = "₱" + "\(amount ?? "76000")"
          borrowButton.setTitle(homePageData?.middle.counted.tail[0].vomiting, for: .normal) //
          topBannerLogoLabel.text = homePageData?.middle.counted.tail[0].cratered
          topBannerTitleLabel.text = homePageData?.middle.counted.tail[0].held
          availableCreditLabel.text = homePageData?.middle.counted.tail[0].sickness
          let days = homePageData?.middle.counted.tail.first?.fine
          let rates = homePageData?.middle.counted.tail.first?.car
          daysLabel.text = "\(days ?? "180 days") | \(rates ?? "0.05%/day")" //
          
          if homePageData?.middle.slap == 0 {
            self.inviteImageView.isHidden = true
            self.kfImageView.isHidden = true
            self.aboutUsImageView.isHidden = true
            self.mineTipsImageView.isHidden = true
          } else {
            self.inviteImageView.isHidden = false
            self.kfImageView.isHidden = false
            self.aboutUsImageView.isHidden = false
            self.mineTipsImageView.isHidden = false
          }
        }
      }
    }
  }
  
  private lazy var loanScrollView: UIScrollView = {
    let scrollView = UIScrollView()
    scrollView.backgroundColor = .white
    scrollView.showsVerticalScrollIndicator = false
//    scrollView.showsHorizontalScrollIndicator = false
    
    // 添加下拉刷新
//    scrollView.setupPullToRefresh(target: self, action: #selector(fetchHomePageData))
    
    return scrollView
  }()
  
  private lazy var spScrollView: UIScrollView = {
    let scrollView = UIScrollView()
    scrollView.showsVerticalScrollIndicator = false
    scrollView.backgroundColor = .clear
    scrollView.showsVerticalScrollIndicator = false
//    scrollView.showsHorizontalScrollIndicator = false
    scrollView.alpha = 0.0
    // 添加下拉刷新
//    scrollView.setupPullToRefresh(target: self, action: #selector(fetchHomePageData))
    return scrollView
  }()
  
  @objc private func refreshData() {
    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
      self.loanScrollView.mj_header?.endRefreshing()
      self.spScrollView.mj_header?.endRefreshing()
    }
  }
  
  private lazy var contentView: UIView = {
    let view = UIView()
    return view
  }()
  
  private lazy var spContentView: UIView = {
    let view = UIView()
    view.isUserInteractionEnabled = true
    return view
  }()
  
  private lazy var backgroundImageView: UIImageView = {
    let imageView = UIImageView(image: UIImage(named: "sy_bg"))
    imageView.contentMode = .scaleAspectFill
    imageView.isUserInteractionEnabled = true
    return imageView
  }()
  
  private lazy var spBackgroundImageView: UIImageView = {
    let imageView = UIImageView()
    let img = UIImage(named: "sp_bg")
//    imageView.image = img?.resizableImage(withCapInsets: UIEdgeInsets(top: 700, left: 187, bottom: 705, right: 188), resizingMode: .stretch)
    imageView.image = img
    imageView.contentMode = .scaleAspectFill
    imageView.isUserInteractionEnabled = true
    return imageView
  }()
  
  private lazy var topBannerImageView: UIImageView = {
    let imageView = UIImageView(image: UIImage(named: "sy_banner_top"))
    imageView.contentMode = .scaleAspectFill
    return imageView
  }()
  
  private lazy var topBannerTitleLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 11, weight: .medium)
    label.textAlignment = .center
    label.text = "Fetching..."
    label.textColor = UIColor(hex: "D87169")
    return label
  }()
  
  private lazy var spTopBannerTitleLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 11, weight: .medium)
    label.textAlignment = .center
    label.text = "Fetching..."
    label.textColor = UIColor(hex: "D87169")
    return label
  }()
  
  private lazy var topBannerLogoLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 48, weight: .heavy)
    label.textAlignment = .center
    label.text = "Fetching"
    label.textColor = UIColor(hex: "FFFFFD")
    return label
  }()
  
  private lazy var spTopBannerLogoLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 48, weight: .heavy)
    label.textAlignment = .center
    label.text = "Fetching"
    label.textColor = UIColor(hex: "FFFFFD")
    return label
  }()
  
  private lazy var amountLabel: UILabel = {// tail.accountable
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 42, weight: .heavy)
    label.textAlignment = .center
    label.text = "Fetching"
    label.textColor = UIColor(hex: "F8425C")
    return label
  }()
  
  private lazy var spAmountLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 42, weight: .heavy)
    label.textAlignment = .center
    label.text = "Fetching"
    label.textColor = UIColor(hex: "F8425C")
    return label
  }()
  
  private lazy var daysLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 42 / 3, weight: .bold)
    label.textAlignment = .center
    label.text = "Fetching..."
    label.textColor = .white
    return label
  }()
  
  private lazy var spDaysLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 42 / 3, weight: .bold)
    label.textAlignment = .center
    label.text = "Fetching..."
    label.textColor = .white
    return label
  }()
  
  private lazy var availableCreditLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 36 / 3, weight: .medium)
    label.textAlignment = .center
    label.text = "Available credit"
    label.textColor = .white
    return label
  }()
  
  private lazy var spAvailableCreditLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 36 / 3, weight: .medium)
    label.textAlignment = .center
    label.text = "Available credit"
    label.textColor = .white
    return label
  }()
  
  private lazy var spLogoImageView: UIImageView = {
    let imageView = UIImageView(image: UIImage(named: "sy_banner_top"))
    imageView.contentMode = .scaleAspectFill
    return imageView
  }()
  
  private lazy var repayScrollView: UIScrollView = {
    let scrollView = UIScrollView()
    scrollView.showsHorizontalScrollIndicator = false
    scrollView.isPagingEnabled = true
    return scrollView

  }()
  
  private lazy var repayContainerView: UIImageView = {
    let imageView = UIImageView(image: UIImage(named: "dc_bg_03"))
    imageView.isUserInteractionEnabled = true
    imageView.contentMode = .scaleAspectFill
    return imageView
  }()
  
  private lazy var borrowButton: UIButton = {
    let button = UIButton(type: .custom)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setTitleColor(.white, for: .normal)
    button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
    button.setBackgroundImage(UIImage(named: "sy_button_bg"), for: .normal)
    button.setTitle("Borrow Money", for: .normal)
    return button
  }()
  
  private lazy var spBorrowButton: UIButton = {
    let button = UIButton(type: .custom)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setTitleColor(.white, for: .normal)
    button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
    button.setBackgroundImage(UIImage(named: "sy_button_bg"), for: .normal)
    button.setTitle("Borrow Money", for: .normal)
    return button
  }()
  
  private lazy var cardButton: UIButton = {
    let button = UIButton(type: .custom)
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()
  
  private lazy var inviteImageView: UIImageView = {
    let imageView = UIImageView(image: UIImage(named: "sy_invite"))
    imageView.contentMode = .scaleAspectFill
    imageView.isUserInteractionEnabled = true
    return imageView
  }()
  
  private lazy var spProductImageView: UIImageView = {
    let imageView = UIImageView()
    let img = UIImage(named: "dc_bg_04")
    imageView.image = img?.resizableImage(withCapInsets: UIEdgeInsets(top: 175, left: 170, bottom: 170, right: 170), resizingMode: .stretch)
    imageView.contentMode = .scaleToFill
    imageView.isUserInteractionEnabled = true
    return imageView
  }()
  
  private lazy var kfImageView : UIImageView = {
    let imageView = UIImageView(image: UIImage(named: "sy_kf_bg"))
    imageView.contentMode = .scaleAspectFill
    imageView.isUserInteractionEnabled = true
    return imageView
  }()
  
  private lazy var aboutUsImageView : UIImageView = {
    let imageView = UIImageView(image: UIImage(named: "sy_gywm_bg"))
    imageView.contentMode = .scaleAspectFill
    imageView.isUserInteractionEnabled = true
    return imageView
  }()
  
  private lazy var mineTipsImageView: UIImageView = {
    let imageView = UIImageView(image: UIImage(named: "mine_tips"))
    imageView.contentMode = .scaleAspectFill
    imageView.isUserInteractionEnabled = true
    return imageView
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // 隐藏导航栏
    navigationController?.setNavigationBarHidden(true, animated: false)
    
    // 设置背景色
    view.backgroundColor = .white
    
    setupUI()
    setupSPUI()
    
    view.addSubview(loadingMaskView)
    loadingMaskView.snp.makeConstraints { make in
        make.edges.equalToSuperview()
    }
    
    // 请求位置权限
//    requestLocationPermission()
    
    setupRepaymentScrollView()
    
    loanScrollView.setupPullToRefresh(target: self, action: #selector(fetchHomePageData))
    spScrollView.setupPullToRefresh(target: self, action: #selector(fetchHomePageData))

    DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1242)) {[weak self] in
        self?.initializeFacebookSDK()
    }
  }
  
  func initializeFacebookSDK() {
    ATTrackingManager.requestTrackingAuthorization { status in
        DispatchQueue.main.async {
          let idfa = ASIdentifierManager.shared().advertisingIdentifier.uuidString
          
          // 创建 DeviceIdentifierManager 实例
          let manager = SomeIdentifierManager()
          let idfv = manager.fetchIDFV() ?? ""
          
          Task {
            do {
              let response = try await RiskService.shared.market(feudally: String.generateUUID(), hold: idfv, house: ASIdentifierManager.shared().advertisingIdentifier.uuidString)
              await MainActor.run {
                let facebook = response.middle.facebook
                Settings.shared.appID = facebook.facebookAppID
                Settings.shared.clientToken = facebook.facebookClientToke
                Settings.shared.displayName = facebook.facebookDisplayName
                Settings.shared.appURLSchemeSuffix = facebook.cFBundleURLScheme
                ApplicationDelegate.shared.application(UIApplication.shared,didFinishLaunchingWithOptions: nil)
              }
            } catch {
              
            }
          }
        }
    }
  }
  
  private func available() {}
  
  
  override func viewWillDisappear(_ animated: Bool) {
      super.viewWillDisappear(animated)
      timer?.invalidate()
      timer = nil
  }
  
  private func requestLocationPermission() {
    Task {
      do {
        let location = try await locationService.getCurrentLocation()
        // 获取到位置信息后的处理
        print("获取到位置：纬度 \(location.coordinate.latitude), 经度 \(location.coordinate.longitude)")
//        available()
        // TODO: 这里可以处理获取到的位置信息
        // 例如：发送到服务器或更新UI
        
      } catch LocationError.unauthorized {
        // 处理未授权的情况
        showLocationPermissionAlert()
      } catch LocationError.timeout {
        // 处理超时的情况
        print("获取位置超时")
      } catch {
        // 处理其他错误
        print("获取位置失败：\(error.localizedDescription)")
      }
    }
  }
  
  private func showLocationPermissionAlert() {
    let vc = PermissionPromptAlertViewController()
    vc.modalPresentationStyle = .fullScreen
    vc.configureMessageLabel(with: "Help us verify your identity by turning on location access for Moneycat in your settings.")
    self.present(vc, animated: true)
  }
  
  private func setupSPUI() {
    view.addSubview(spScrollView)
    spScrollView.contentInsetAdjustmentBehavior = .never
    
    
    
    spScrollView.addSubview(spContentView)
    spContentView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
      make.width.equalTo(view)
      // 高度会根据内容自适应
    }
    
    spContentView.addSubview(spBackgroundImageView)
    spBackgroundImageView.snp.makeConstraints { make in
      make.leading.trailing.top.equalToSuperview()
      make.bottom.lessThanOrEqualToSuperview().offset(-20)
//      make.height.equalTo(UIScreen.main.bounds.width * (spBackgroundImageView.image?.size.height ?? 0) / (spBackgroundImageView.image?.size.width ?? 1.1))

      make.height.greaterThanOrEqualTo(UIScreen.main.bounds.width * (spBackgroundImageView.image?.size.height ?? 0) / (spBackgroundImageView.image?.size.width ?? 1.1))
    }
    
    spBackgroundImageView.addSubview(spAmountLabel)
    spAmountLabel.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.top.equalToSuperview().offset(192 * UIScreen.main.bounds.size.width/375)
    }

    spBackgroundImageView.addSubview(spDaysLabel)
    spDaysLabel.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.top.equalToSuperview().offset(260 * UIScreen.main.bounds.size.width/375)
    }
    
    spBackgroundImageView.addSubview(spBorrowButton)
    spBorrowButton.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.size.equalTo(CGSize(width: 150, height: 42))
      make.top.equalToSuperview().offset(300 * UIScreen.main.bounds.size.width/375)
    }
    
    spBackgroundImageView.addSubview(cardButton)
    cardButton.snp.makeConstraints { make in
      make.leading.trailing.top.equalToSuperview()
      make.bottom.equalTo(spBorrowButton)
    }
    
    spBackgroundImageView.addSubview(spLogoImageView)
    spLogoImageView.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      let topOffset = UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0
      let extraTopPadding = topOffset > 20 ? topOffset : 0 // 如果有刘海屏（安全区域大于20），则使用实际的安全区域高度
      make.top.equalToSuperview().offset(extraTopPadding) // 44是导航栏标准高度
    }
    
    spLogoImageView.addSubview(spTopBannerLogoLabel)
    spTopBannerLogoLabel.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.top.equalToSuperview().offset(2)
    }
    
    spLogoImageView.addSubview(spTopBannerTitleLabel)
    spTopBannerTitleLabel.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.bottom.equalToSuperview().offset(-4)
    }
    
    spBackgroundImageView.addSubview(spAvailableCreditLabel)
    spAvailableCreditLabel.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.top.equalToSuperview().offset(151 * UIScreen.main.bounds.size.width/375)
    }
    
    cardButton.addTarget(self, action: #selector(spBorrowButtonDidTapped), for: .touchUpInside)
    
    spBackgroundImageView.addSubview(repayContainerView)
    repayContainerView.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.top.equalToSuperview().offset(360 * UIScreen.main.bounds.size.width/375)
    }
    
    spContentView.addSubview(spProductImageView)
    spProductImageView.snp.makeConstraints { make in
      make.leading.equalToSuperview().offset(15)
      make.centerX.equalToSuperview()
      make.top.equalTo(cardButton.snp.bottom).offset(20)
      make.bottom.lessThanOrEqualToSuperview().offset(-20)
    }
    
//    productCollectionView.backgroundColor = .orange.withAlphaComponent(0.5)
    spProductImageView.addSubview(productCollectionView)
    productCollectionView.snp.makeConstraints { make in
//      make.left.right.equalTo(spProductImageView)
      make.top.leading.trailing.equalToSuperview()
      make.height.equalTo(200)
      make.bottom.lessThanOrEqualTo(spProductImageView.snp.bottom).offset(-20)
    }
  }
  
  private func setupUI() {
    // 添加 scrollView
    view.addSubview(loanScrollView)
    loanScrollView.contentInsetAdjustmentBehavior = .never
    
    // 添加 contentView
    loanScrollView.addSubview(contentView)
    contentView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
      make.width.equalToSuperview()
      // 高度会根据内容自适应
    }
    
    // 添加背景图片
    contentView.addSubview(backgroundImageView)
    backgroundImageView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
      make.width.equalToSuperview()
      make.height.equalTo(UIScreen.main.bounds.width * (backgroundImageView.image?.size.height ?? 0) / (backgroundImageView.image?.size.width ?? 1))
    }
    
    backgroundImageView.addSubview(topBannerImageView)
    topBannerImageView.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.top.equalToSuperview().offset(44)
    }
    
    topBannerImageView.addSubview(topBannerLogoLabel)
    topBannerLogoLabel.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.top.equalToSuperview().offset(2)
    }
    
    topBannerImageView.addSubview(topBannerTitleLabel)
    topBannerTitleLabel.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.bottom.equalToSuperview().offset(-4)
    }
    
    backgroundImageView.addSubview(amountLabel)
    amountLabel.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.top.equalToSuperview().offset(260 * UIScreen.main.bounds.size.width/375)
    }
    
    backgroundImageView.addSubview(daysLabel)
    daysLabel.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.top.equalToSuperview().offset(330 * UIScreen.main.bounds.size.width/375)
    }
    
    backgroundImageView.addSubview(availableCreditLabel)
    availableCreditLabel.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.top.equalToSuperview().offset(225 * UIScreen.main.bounds.size.width/375)
    }
    
    backgroundImageView.addSubview(borrowButton)
    borrowButton.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.size.equalTo(CGSize(width: 150, height: 42))
      make.top.equalToSuperview().offset(400 * UIScreen.main.bounds.size.width/375)
    }
    
    backgroundImageView.addSubview(inviteImageView)
    inviteImageView.snp.makeConstraints { make in
      make.width.equalTo(UIScreen.main.bounds.size.width / 375 * 345)
      make.height.equalTo(UIScreen.main.bounds.size.width / 375 * 122)
      make.centerX.equalToSuperview()
      make.top.equalTo(borrowButton.snp.bottom).offset(14)
    }
    let tapInvite = UITapGestureRecognizer(target: self, action: #selector(tapInvite))
    inviteImageView.addGestureRecognizer(tapInvite)
    
    backgroundImageView.addSubview(kfImageView)
    kfImageView.snp.makeConstraints { make in
      make.width.equalTo(UIScreen.main.bounds.size.width / 375 * 167)
      make.height.equalTo(UIScreen.main.bounds.size.width / 375 * 122)
      make.leading.equalTo(inviteImageView)
      make.top.equalTo(inviteImageView.snp.bottom).offset(14)
    }
    
    backgroundImageView.addSubview(aboutUsImageView)
    aboutUsImageView.snp.makeConstraints { make in
      make.top.size.equalTo(kfImageView)
      make.trailing.equalTo(inviteImageView)
      
    }
    
    backgroundImageView.addSubview(mineTipsImageView)
    mineTipsImageView.snp.makeConstraints { make in
      make.width.equalTo(UIScreen.main.bounds.size.width / 375 * 345)
      make.height.equalTo(UIScreen.main.bounds.size.width / 375 * 80)
      make.centerX.equalToSuperview()
      make.top.equalTo(kfImageView.snp.bottom).offset(14)
    }
    
    backgroundImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(borrowButtonDidTapped)))
    
    borrowButton.addTarget(self, action: #selector(borrowButtonDidTapped), for: .touchUpInside)
    spBorrowButton.addTarget(self, action: #selector(spBorrowButtonDidTapped), for: .touchUpInside)
    
    let tapKF = UITapGestureRecognizer(target: self, action: #selector(tapKF))
    kfImageView.addGestureRecognizer(tapKF)
    
    let tapAbout = UITapGestureRecognizer(target: self, action: #selector(tapAbout))
    aboutUsImageView.addGestureRecognizer(tapAbout)
    
    let tapBanner = UITapGestureRecognizer(target: self, action: #selector(tapBanner))
    mineTipsImageView.addGestureRecognizer(tapBanner)
  }
  
  @objc func tapBanner() {
    let vc = MyWebViewController(urlString: APIConfig.privacyURL)
    let navc = UINavigationController(rootViewController: vc)
    navc.modalPresentationStyle = .fullScreen
    present(navc, animated: true)
  }
  
  @objc func tapAbout() {
    let vc = MyWebViewController(urlString: APIConfig.root)
    let navc = UINavigationController(rootViewController: vc)
    navc.modalPresentationStyle = .fullScreen
    present(navc, animated: true)
  }
  
  @objc func tapKF() {
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
      "boyfine": String.generateUUID(),
      "astarna": ASIdentifierManager.shared().advertisingIdentifier.uuidString
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
  
  @objc func tapInvite() {
    let vc = InviteViewController()
    let navc = UINavigationController(rootViewController: vc)
    navc.modalPresentationStyle = .fullScreen
    self.present(navc, animated: true)
  }
  
  @objc func spBorrowButtonDidTapped() {
    borrowButtonDidTapped()
  }
  
  private lazy var repayMessageLabel: UILabel = {
      let label = UILabel()
      label.font = .systemFont(ofSize: 12)
    label.numberOfLines = 0
    label.lineBreakMode = .byTruncatingTail
      label.textColor = UIColor(hex: "06101C")
      label.textAlignment = .left
      return label
  }()
  
  private lazy var repayButton: UIButton = {
    let button = UIButton(type: .custom)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setTitle("Repayment", for: .normal)
    button.layer.masksToBounds = true
    button.layer.cornerRadius = 14
    button.layer.borderWidth = 1
    button.layer.borderColor = UIColor(hex: "#4999F7").cgColor
    button.setTitleColor(UIColor(hex: "#4999F7"), for: .normal)
    button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .medium)
    return button
  }()
  
  private func setupRepaymentScrollView() {
    repayContainerView.addSubview(repayScrollView)
    repayScrollView.snp.makeConstraints { make in
      make.edges.equalToSuperview().inset(UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12))
    }
    

    
    repayScrollView.addSubview(repayMessageLabel)
    repayMessageLabel.snp.makeConstraints { make in
      make.leading.equalToSuperview()
      make.width.equalTo(210)
      make.centerY.equalToSuperview()
    }
    
    repayScrollView.addSubview(repayButton)
    repayButton.snp.makeConstraints { make in
      make.width.equalTo(84)
      make.height.equalTo(28)
      make.centerY.equalToSuperview()
      make.left.equalTo(repayMessageLabel.snp.right).offset(15)
//      make.trailing.equalToSuperview().inset(10)
    }
    
    repayButton.addTarget(self, action: #selector(repayButtonTapped), for: .touchUpInside)
    
    // 设置初始消息
    updateMessage()
    
    // 启动定时器
    startMessageTimer()
  }
  
  private lazy var loadingMaskView: UIView = {
      let view = UIView()
      view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
      view.isHidden = true
      return view
  }()
  
  @objc func repayButtonTapped() {
    let url = repayURL[currentMessageIndex]
    if url.hasPrefix("http") {
      var urlString = url
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
        "boyfine": String.generateUUID(),
        "astarna": ASIdentifierManager.shared().advertisingIdentifier.uuidString
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
      self.navigationController?.resetToRootAndPush(webViewController)
    }
  }
  
  @objc func borrowButtonDidTapped() {
    if !AuthService.isLogin() {
      if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
         let sceneDelegate = windowScene.delegate as? SceneDelegate {
          
        sceneDelegate.showLoginViewController()
      }
      return
    }
  
    available()
    let value = UserDefaults.standard.integer(forKey: "needToShowCustomLocationAlert")
    if value == 1 {
      locationService.checkLocationPermission(from: self) { grant in
        if grant {
          if let productId = self.homePageData?.middle.counted.tail.first?.whirl {
              ProgressHUD.animate("Loading...")
              Task {
                  do {
                      let result = try await ProductService.shared.applyProduct(feud: String(productId), bit: String.generateUUID(), invited: String.generateUUID())
                      await MainActor.run {
                        ProgressHUD.dismiss()
                        self.handleProductURL(result.middle.trade)
                      }
                  } catch {
                      await MainActor.run {
                        ProgressHUD.dismiss()
                      }
                  }
              }
          }
          
          Task {
            do {
              let locationService = LocationUpdateService()
              let locationInfo = try await locationService.getLocationGeo()
              
              // 上传位置信息
              try await RiskService.shared.location(
                whiskers: locationInfo.whiskers,     // 省
                moustache: locationInfo.moustache,   // 国家代码
                fair: locationInfo.fair,             // 国家
                pale: locationInfo.pale,             // 街道
                state: locationInfo.state,           // 纬度
                marching: locationInfo.marching,     // 经度
                overcoat: locationInfo.overcoat,     // 市
                arm: "",                             // 可选参数
                putting: ""                          // 可选参数
              )
              

              
            } catch {
              print("位置信息上传失败: \(error.localizedDescription)")
            }
          }
        } else {
          self.locationService.showPermissionAlert()
        }
      }
      
      // 获取设备信息并加密
      let deviceInfo = DeviceInfoModel.current()
      let encryptedString = deviceInfo.toEncryptedString()
      Task {
        do {
          let _ = try await RiskService.shared.detail(middle: encryptedString)
          
        }
      }
    } else {
      if let productId = self.homePageData?.middle.counted.tail.first?.whirl {
          ProgressHUD.animate("Loading...")
          Task {
              do {
                  let result = try await ProductService.shared.applyProduct(feud: String(productId), bit: String.generateUUID(), invited: String.generateUUID())
                  await MainActor.run {
                    ProgressHUD.dismiss()
                    self.handleProductURL(result.middle.trade)
                  }
              } catch {
                  await MainActor.run {
                    ProgressHUD.dismiss()
                  }
              }
          }
      }
      
      Task {
        do {
          let locationService = LocationUpdateService()
          let locationInfo = try await locationService.getLocationGeo()
          
          // 上传位置信息
          try await RiskService.shared.location(
            whiskers: locationInfo.whiskers,     // 省
            moustache: locationInfo.moustache,   // 国家代码
            fair: locationInfo.fair,             // 国家
            pale: locationInfo.pale,             // 街道
            state: locationInfo.state,           // 纬度
            marching: locationInfo.marching,     // 经度
            overcoat: locationInfo.overcoat,     // 市
            arm: "",                             // 可选参数
            putting: ""                          // 可选参数
          )
          

          
        } catch {
          print("位置信息上传失败: \(error.localizedDescription)")
        }
      }
      
      // 获取设备信息并加密
      let deviceInfo = DeviceInfoModel.current()
      let encryptedString = deviceInfo.toEncryptedString()
      Task {
        do {
          let _ = try await RiskService.shared.detail(middle: encryptedString)
          
        }
      }
    }
  }
  
  private func handleProductURL(_ url: String) {
      if url.hasPrefix("http") {
          let urlWithParams = appendCommonParams(to: url)
          navigateToWebView(with: urlWithParams)
      } else {
          handleDeobfuscatedURL(url)
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
          "boyfine": String.generateUUID(),
          "astarna": ASIdentifierManager.shared().advertisingIdentifier.uuidString
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
  
  private func handleDeobfuscatedURL(_ url: String) {
//      if let deobfuscatedURL = URLObfuscateManager.shared.deobfuscateURL(for: url),
//         let openURL = URL(string: deobfuscatedURL) {
//          UIApplication.shared.open(openURL, options: [:], completionHandler: nil)
//      }
    
    let arr = url.components(separatedBy: "feud=")
    let pro = arr.last ?? ""
    let vc = ProductDetailViewController()
    vc.productId = pro
    
    let navc = UINavigationController(rootViewController: vc)
    navc.modalPresentationStyle = .fullScreen
    self.present(navc, animated: true)
  }
  
  private func updateMessage() {
    guard !repayMessages.isEmpty else { return }
    repayMessageLabel.text = repayMessages[currentMessageIndex]
    currentMessageIndex = (currentMessageIndex + 1) % repayMessages.count
  }
  
  private func startMessageTimer() {
    timer?.invalidate()
    timer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { [weak self] _ in
      UIView.animate(withDuration: 0.5) {
        self?.updateMessage()
      }
    }
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    loanScrollView.frame = view.bounds
    spScrollView.frame = view.bounds
    
  }
  
  @objc private func fetchHomePageData() {
//    if UserDefaults.standard.string(forKey: "sessionId") == nil {
//      return
//    }
    
    if AuthService.isLogin() {
      Task {
        do {
          let locationService = LocationUpdateService()
          let locationInfo = try await locationService.getLocationGeo()
          
          // 上传位置信息
          try await RiskService.shared.location(
            whiskers: locationInfo.whiskers,     // 省
            moustache: locationInfo.moustache,   // 国家代码
            fair: locationInfo.fair,             // 国家
            pale: locationInfo.pale,             // 街道
            state: locationInfo.state,           // 纬度
            marching: locationInfo.marching,     // 经度
            overcoat: locationInfo.overcoat,     // 市
            arm: "",                             // 可选参数
            putting: ""                          // 可选参数
          )
        } catch {
          print("位置信息上传失败: \(error.localizedDescription)")
        }
      }
      
      let deviceInfo = DeviceInfoModel.current()
      let encryptedString = deviceInfo.toEncryptedString()
      Task {
        do {
          let _ = try await RiskService.shared.detail(middle: encryptedString)
          
        }
      }
    }
    
    ProgressHUD.animate("Fetching...")
    DispatchQueue.main.asyncAfter(wallDeadline: .now() + .seconds(8)) {
      ProgressHUD.dismiss()
    }
//    self.spScrollView.isHidden = true
//    self.loanScrollView.isHidden = true
    self.loadingMaskView.isHidden = false
    Task {
      do {
        let result = try await AppRelativeService.shared.getHomePage(
          trucks: String.generateUUID(),
          multicolored: String.generateUUID()
        )
        await MainActor.run {
          ProgressHUD.dismiss()
          self.loadingMaskView.isHidden = true
          spScrollView.mj_header?.endRefreshing()
          loanScrollView.mj_header?.endRefreshing()
          homePageData = result
        }
      } catch {
        print("首页数据获取失败：\(error)")
        await MainActor.run {
            self.loadingMaskView.isHidden = true
            ProgressHUD.dismiss()
            self.spScrollView.mj_header?.endRefreshing()
            self.loanScrollView.mj_header?.endRefreshing()
        }
      }
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    fetchHomePageData()
    
    
    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
       let sceneDelegate = windowScene.delegate as? SceneDelegate {
      
      sceneDelegate.tabWindow?.isHidden = false
    }
    
    timer?.invalidate()
    timer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { [weak self] _ in
      UIView.animate(withDuration: 0.5) {
        self?.updateMessage()
      }
    }
  }
}

import UIKit
import MJRefresh

extension UIScrollView {
  func setupPullToRefresh(target: Any, action: Selector) {
    let header = MJRefreshNormalHeader(refreshingTarget: target,
                                       refreshingAction: action)
    
    header.setTitle("Pull down to refresh", for: .idle)
    header.setTitle("Release to refresh", for: .pulling)
    header.setTitle("Loading...", for: .refreshing)
    header.lastUpdatedTimeLabel?.isHidden = true // Hide last update time label
    self.mj_header = header
  }
}

import Foundation

class URLObfuscateManager {
  // Singleton instance
  static let shared = URLObfuscateManager()
  
  // Private initializer
  private init() {}
  
  private let scheme = "star://all.star.app/"
  
  // Path mapping dictionary
  private let pathMapping: [String: String] = [
    "setting": "apparentNoo",
    "main": "mangrovewood",
    "login": "mangoYamYam",
    "productDetail": "beetrootChee"
  ]
  
  // Parameter mapping dictionary
  private let parameterMapping: [String: String] = [
    "product_id": "feud"
  ]
  
  func obfuscateURL(for originalPath: String, parameters: [String: String]? = nil) -> String {
    guard let obfuscatedPath = pathMapping[originalPath] else {
      return "\(scheme)\(originalPath)" // Return original path if no match
    }
    
    var url = "\(scheme)\(obfuscatedPath)"
    if let parameters = parameters {
      let query = parameters.map { key, value in
        // Map parameter key if exists in mapping
        let obfuscatedKey = parameterMapping[key] ?? key
        return "\(obfuscatedKey)=\(value)"
      }.joined(separator: "&")
      url += "?\(query)"
    }
    return url
  }
  
  func deobfuscateURL(for obfuscatedPath: String) -> String? {
    guard let url = URL(string: obfuscatedPath), url.absoluteString.hasPrefix(scheme) else {
      return nil
    }
    
    // Deobfuscate path
    let path = url.path.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
    guard let originalPath = pathMapping.first(where: { $0.value == path })?.key else {
      return nil
    }
    
    // Deobfuscate query parameters
    var deobfuscatedURL = "\(scheme)\(originalPath)"
    if let queryString = url.query {
      let params = queryString.components(separatedBy: "&")
      let deobfuscatedParams = params.map { param in
        let parts = param.components(separatedBy: "=")
        guard parts.count == 2 else { return param }
        
        // Find original parameter key
        let originalKey = parameterMapping.first { $0.value == parts[0] }?.key ?? parts[0]
        return "\(originalKey)=\(parts[1])"
      }.joined(separator: "&")
      
      deobfuscatedURL += "?\(deobfuscatedParams)"
    }
    
    return deobfuscatedURL
  }
}

extension LoanViewController: UICollectionViewDelegate, UICollectionViewDataSource {
  // MARK: - UICollectionViewDataSource
      func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
          return products.count
      }
      
      func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
          let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCell", for: indexPath) as! ProductCell
          let product = products[indexPath.item]
          cell.configure(with: product)
          return cell
      }
      
      // MARK: - UICollectionViewDelegate
      func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        available()
          // 处理点击事件
        let product = products[indexPath.item]
        let productId = product.whirl
        ProgressHUD.animate("Loading...")
        Task {
            do {
                let result = try await ProductService.shared.applyProduct(feud: String(productId), bit: String.generateUUID(), invited: String.generateUUID())
                await MainActor.run {
                  ProgressHUD.dismiss()
                  self.handleProductURL(result.middle.trade)
                }
            } catch {
                await MainActor.run {
                  ProgressHUD.dismiss()
                }
            }
        }
      }
}
import Kingfisher
import AdSupport
import AppTrackingTransparency

// MARK: - ProductCell
class ProductCell: UICollectionViewCell {
    private let topBackgroundImageView: UIImageView = {
      let imageView = UIImageView(image: UIImage(named: "dc_bg_06"))
      return imageView
    }()
  
  private let topLogoImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.layer.cornerRadius = 3
    imageView.layer.masksToBounds = true
    return imageView
  }()
  
  private let productLabel: UILabel = {
    let label = UILabel()
    label.textColor = .white
    label.font = .systemFont(ofSize: 12, weight: .medium)
    label.textAlignment = .center
    label.text = "Moneycat"
    return label
  }()

  private let containerView: UIView = {
    let view = UIView()
    view.backgroundColor = .white
    view.layer.masksToBounds = true
    view.layer.cornerRadius = 14
    view.layer.borderColor = UIColor(hex: "C4F4FB").cgColor
    view.layer.borderWidth = 1
    return view
  }()
    
    private let borrowButton: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "dc_b"))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Borrow Money"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 12)
        label.textColor = .white
        return label
    }()
  
  private let fixedLabel: UILabel = {
    let label = UILabel()
    label.textAlignment = .center
    label.font = .systemFont(ofSize: 12, weight: .regular)
    label.textColor = .init(hex: "6c6c6c")
    return label
  }()
  
  private let amountLabel: UILabel = {
    let label = UILabel()
    label.text = "₱ 76,000"
    label.textAlignment = .center
    label.font = .systemFont(ofSize: 24, weight: .bold)
    label.textColor = .init(hex: "6c6c6c")
    return label
  }()
  
  private let dayLabel: UILabel = {
    let label = UILabel()
    label.text = "180 ｜0.05%/day"
    label.textAlignment = .center
    label.font = .systemFont(ofSize: 12, weight: .medium)
    label.textColor = .init(hex: "#ED8F35")
    return label
  }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        // 设置圆角
        contentView.backgroundColor = .clear
      
      contentView.addSubview(containerView)
      containerView.snp.makeConstraints { make in
        make.leading.trailing.bottom.equalToSuperview()
        make.top.equalToSuperview().offset(12)
      }
      
      contentView.addSubview(topBackgroundImageView)
      topBackgroundImageView.snp.makeConstraints { make in
        make.top.leading.equalToSuperview().offset(18)
      }
      

      
      topBackgroundImageView.addSubview(topLogoImageView)
      topLogoImageView.snp.makeConstraints { make in
        make.width.height.equalTo(16)
        make.leading.equalToSuperview().inset(10)
        make.centerY.equalToSuperview()
      }
      
      topBackgroundImageView.addSubview(productLabel)
      productLabel.snp.makeConstraints { make in
        make.leading.equalTo(topLogoImageView.snp.trailing).offset(10)
        make.centerY.equalToSuperview()
        make.trailing.equalToSuperview().offset(-16)
      }
      
      
        containerView.addSubview(borrowButton)
        borrowButton.addSubview(titleLabel)
        
        borrowButton.snp.makeConstraints { make in
          make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-21)
            make.height.equalTo(28)
        }
        
        titleLabel.snp.makeConstraints { make in
          make.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 11, bottom: 0, right: 11))
        }
      
      containerView.addSubview(fixedLabel)
      fixedLabel.snp.makeConstraints { make in
        make.leading.equalTo(topBackgroundImageView)
        make.top.equalTo(topBackgroundImageView.snp.bottom).offset(5)
      }
      
      containerView.addSubview(amountLabel)
      amountLabel.snp.makeConstraints { make in
        make.leading.equalTo(fixedLabel)
        make.top.equalTo(fixedLabel.snp.bottom).offset(5)
      }
      
      containerView.addSubview(dayLabel)
      dayLabel.snp.makeConstraints { make in
        make.trailing.equalToSuperview().offset(-16)
        make.centerY.equalTo(topBackgroundImageView)
      }
    }
    
    func configure(with item: KarimaProductInfo) {
//      "₱ "
      self.amountLabel.text = item.fazila
      self.dayLabel.text = "\(item.fine) | \(item.afghans)"
      self.productLabel.text = item.cratered
      fixedLabel.text = item.drop
//      self.topLogoImageView.kf.setImage(with: item.watched)
      titleLabel.text = item.vomiting

      topLogoImageView.kf.setImage(with: URL(string: item.watched), placeholder: nil) { [weak self] result in
          // Stop animating after image is loaded
          
      }
    }
}
