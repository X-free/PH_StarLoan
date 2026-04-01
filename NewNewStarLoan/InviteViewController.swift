//
//  InviteViewController.swift
//  NewNewStarLoan
//
//  Created by Albert on 2025/5/22.
//

import UIKit
import Foundation
import ProgressHUD

class InviteViewController: UIViewController {
  
  private lazy var navigationBar: CustomNavigationBar = {
    let nav = CustomNavigationBar()
    nav.backButtonTapped = { [weak self] in
      self?.dismiss(animated: true)
    }
    return nav
  }()
  
  private lazy var backgroundImageView: UIImageView = {
    let iv = UIImageView(image: UIImage(named: "yq_bg"))
    iv.contentMode = .scaleAspectFill
    iv.isUserInteractionEnabled = true
    return iv
  }()
  
  private lazy var centerImageView: UIImageView = {
    let iv = UIImageView(image: UIImage(named: "yq_bg_03"))
    iv.contentMode = .scaleAspectFill
    iv.isUserInteractionEnabled = true

    return iv
  }()
  
  private lazy var topImageView: UIImageView = {
    let iv = UIImageView(image: UIImage(named: "yq_bg_01"))
    iv.contentMode = .scaleAspectFill
    iv.isUserInteractionEnabled = true

    return iv
  }()
  
  
  private lazy var inviteButton: UIButton = {
    let button = UIButton(type: .custom)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setImage(UIImage(named: "yq_b"), for: .normal)
    
    return button
  }()
  
  private lazy var couponImageView: UIImageView = {
    let iv = UIImageView(image: UIImage(named: "yq_bg_04"))
    iv.contentMode = .scaleAspectFill
    return iv
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    
    setupUI()
    // 在视图加载时就隐藏 tabWindow
    
  }
  
  private func setupUI() {
    // 隐藏系统导航栏
    navigationController?.setNavigationBarHidden(true, animated: false)
    // 设置标题
    navigationBar.setTitle("Invite Friends")
    // 添加自定义导航栏
    view.addSubview(navigationBar)
    // 设置导航栏约束
    navigationBar.snp.makeConstraints { make in
      make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
      make.leading.trailing.equalToSuperview()
      make.height.equalTo(44)
    }
    
    view.addSubview(backgroundImageView)
    backgroundImageView.snp.makeConstraints { make in
      make.leading.trailing.bottom.equalToSuperview()
      make.top.equalTo(navigationBar.snp.bottom)
    }
    
    view.addSubview(centerImageView)
    centerImageView.snp.makeConstraints { make in
      make.center.equalToSuperview()
    }
    
    view.addSubview(topImageView)
    topImageView.snp.makeConstraints { make in
      make.top.equalTo(navigationBar.snp.bottom).offset(35)
      make.centerX.equalToSuperview()
    }
    
    centerImageView.addSubview(inviteButton)
    inviteButton.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.bottom.equalToSuperview().offset(-20)
    }
    
    centerImageView.addSubview(couponImageView)
    couponImageView.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.bottom.equalTo(inviteButton.snp.top).offset(-20)
    }
    
    inviteButton.addTarget(self, action: #selector(inviteButtonDidClicked), for: .touchUpInside)
    view.bringSubviewToFront(navigationBar)
  }
  
  @objc func inviteButtonDidClicked() {
    let pb = UIPasteboard.general
    pb.string = "Moneycat"
    ProgressHUD.succeed("Copied success. Go and invite your friend.")
  }
  
  override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      // 隐藏 tabWindow
    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
       let sceneDelegate = windowScene.delegate as? SceneDelegate {
      sceneDelegate.tabWindow?.isHidden = true
    }
  }
}
