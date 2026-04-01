//
//  AuthWayViewController.swift
//  NewNewStarLoan
//
//  Created by Albert on 2025/5/6.
//

import UIKit
import Foundation
import SnapKit
import AdSupport


class AuthWayViewController: UIViewController {
    let recommendedTypes: [String]
    let otherOptions: [String]
    private let analy = AnalyticsService()
    var productId: String?
  
  var start2 = 0
  
    init(idTypes: [[String]], productId: String) {
        self.recommendedTypes = idTypes[0]
        self.otherOptions = idTypes[1]
      self.productId = productId
      analy.startTracking(.chooseId, additionalParams: ["product_id": productId])
      self.start2 = Int(Date().timeIntervalSince1970)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
  
  private lazy var backgroundImageView: UIImageView = {
    let imageView = UIImageView(image: UIImage(named: "xzrzfs_bg"))
    imageView.isUserInteractionEnabled = true
    return imageView
  }()
  
  private lazy var containerView: UIView = {
    let view = UIView()
    view.backgroundColor = .white
    view.layer.masksToBounds = true
    view.layer.cornerRadius = 18.0
    return view
  }()
  
  private lazy var topImageView: UIImageView = {
    let imageView = UIImageView(image: UIImage(named: "xzrzfs_top_bg"))
    imageView.isUserInteractionEnabled = true
    imageView.contentMode = .scaleAspectFill
    return imageView
  }()
  
  private lazy var tableView: UITableView = {
      let tableView = UITableView()
      tableView.delegate = self
      tableView.dataSource = self
      tableView.register(AuthTypeCell.self, forCellReuseIdentifier: "AuthTypeCell")
      tableView.separatorStyle = .none
      tableView.backgroundColor = .clear
      return tableView
  }()
  
  //  private lazy var topLeftImageView: UIImageView = {
  //    let imageView = UIImageView(image: UIImage(named: "xzrzfs_bg_mask_left"))
  //    imageView.isUserInteractionEnabled = true
  //    imageView.contentMode = .scaleAspectFill
  //    return imageView
  //  }()
  //
  //  private lazy var topRightImageView: UIImageView = {
  //    let imageView = UIImageView(image: UIImage(named: "xzrzfs_bg_mask_right"))
  //    imageView.isUserInteractionEnabled = true
  //    imageView.contentMode = .scaleAspectFill
  //    return imageView
  //  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    
    view.backgroundColor = .white
    setupUI()
  }
  
  private var selectedIndex: Int = 0 {
    didSet {
      updateButtonStates()
    }
  }
  
  private lazy var leftButton: UIButton = {
    let button = UIButton(type: .custom)
    button.setTitle("Recommended", for: .normal)
    button.setTitleColor(UIColor(hex: "06101C"), for: .normal)
    button.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
    button.tag = 0
    button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
    return button
  }()
  
  private lazy var rightButton: UIButton = {
    let button = UIButton(type: .custom)
    button.setTitle("Other", for: .normal)
    button.setTitleColor(UIColor(hex: "06101C"), for: .normal)
    button.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
    button.tag = 1
    button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
    return button
  }()
  
  private lazy var selectedLabel: UILabel = {
    let label = UILabel()
    label.backgroundColor = .white
    label.font = .systemFont(ofSize: 14, weight: .bold)
    label.textColor = UIColor(hex: "06101C")
    label.textAlignment = .center
    return label
  }()
  
  private lazy var selectedIndicatorView: UIView = {
    let view = UIView()
    view.backgroundColor = .white
    return view
  }()
  
  private func setupUI() {
    navigationController?.setNavigationBarHidden(true, animated: false)
    
    // 添加自定义导航栏
    view.addSubview(navigationBar)
    view.addSubview(backgroundImageView)
    
    // 设置导航栏约束
    navigationBar.snp.makeConstraints { make in
      make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
      make.leading.trailing.equalToSuperview()
      make.height.equalTo(44)
    }
    
    // 设置标题
    navigationBar.setTitle("Id Type")
    
    backgroundImageView.snp.makeConstraints { make in
      make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(44)
      make.leading.trailing.equalToSuperview()     // 左右充满
      make.bottom.equalTo(view.snp.bottom)
    }
    
    backgroundImageView.addSubview(containerView)
    containerView.snp.makeConstraints { make in
      make.width.equalTo(335)
      make.bottom.equalToSuperview().offset(-80)
      
      make.centerX.equalToSuperview()
      make.top.equalToSuperview().offset(20)
    }
    
    containerView.addSubview(topImageView)
    topImageView.snp.makeConstraints { make in
      make.top.leading.trailing.equalToSuperview()
      make.height.equalTo(44)  // 设置固定高度
    }
    
    // 添加按钮和指示器
    topImageView.addSubview(leftButton)
    topImageView.addSubview(rightButton)
    topImageView.addSubview(selectedIndicatorView)
    
    // 设置按钮约束
    leftButton.snp.makeConstraints { make in
      make.left.top.equalToSuperview()
      make.width.equalTo(topImageView.snp.width).multipliedBy(0.5)
      make.height.equalTo(44)
    }
    
    rightButton.snp.makeConstraints { make in
      make.right.top.equalToSuperview()
      make.width.equalTo(leftButton.snp.width)
      make.height.equalTo(44)
    }
    
    containerView.addSubview(tableView)
    tableView.snp.makeConstraints { make in
      make.top.equalTo(topImageView.snp.bottom).offset(10)
        make.left.right.bottom.equalToSuperview()
    }
    
//    // 设置选中指示器的初始位置
//    selectedIndicatorView.snp.makeConstraints { make in
//      make.bottom.equalToSuperview().offset(6)
//      make.width.equalTo(topImageView.snp.width).multipliedBy(0.5)
//      make.height.equalTo(5)  // 设置指示器高度
//      make.left.equalToSuperview()
//    }
    
    // 初始化按钮状态
    updateButtonStates()
  }
  
  private func updateButtonStates() {
    // 更新选中指示器的位置
//    selectedIndicatorView.snp.remakeConstraints { make in
//      make.bottom.equalToSuperview().offset(6)
//      make.width.equalTo(topImageView.snp.width).multipliedBy(0.5)
//      make.height.equalTo(5)
//      make.left.equalToSuperview().offset(CGFloat(selectedIndex) * topImageView.bounds.width / 2)
//    }
    
    // 更新按钮文字颜色
    leftButton.setTitleColor(selectedIndex == 0 ? UIColor(hex: "06101C") : UIColor(hex: "6C6C6C"), for: .normal)
    rightButton.setTitleColor(selectedIndex == 1 ? UIColor(hex: "06101C") : UIColor(hex: "6C6C6C"), for: .normal)
    
    // 执行动画
    UIView.animate(withDuration: 0.3) {
      self.view.layoutIfNeeded()
    }
  }
  
  @objc private func buttonTapped(_ sender: UIButton) {
      selectedIndex = sender.tag
      tableView.reloadData()
  }
  
}


// MARK: - UITableView DataSource & Delegate
extension AuthWayViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedIndex == 0 ? recommendedTypes.count : otherOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AuthTypeCell", for: indexPath) as! AuthTypeCell
        let title = selectedIndex == 0 ? recommendedTypes[indexPath.row] : otherOptions[indexPath.row]
        cell.configure(with: title)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedType = selectedIndex == 0 ? recommendedTypes[indexPath.row] : otherOptions[indexPath.row]
        print("选中了: \(selectedType)")
      
      let vc = AuthVerifyIdentityViewController(idType: selectedType, productId: self.productId!)
      self.navigationController?.pushViewController(vc, animated: true)
      
      let end2 = Int(Date().timeIntervalSince1970)
      MaidianRistManager.manager.upload(foreground: productId ?? "", hammersmith: "2", welcome: "\(start2)", deal: "\(end2)")
    }
}
