//
//  CancelAccountAlertController.swift
//  NewNewStarLoan
//
//  Created by Albert on 2025/5/26.
//

import Foundation
import UIKit
import SnapKit
import ProgressHUD

class CancelAccountAlertController: UIViewController {
  var dismissCallback: (() -> Void)?
  weak var sceneDelegate: SceneDelegate?
  
  private lazy var containerView: UIView = {
      let view = UIView()
      view.backgroundColor = .clear
      return view
  }()
  
  private lazy var backgroundView: UIView = {
      let view = UIView()
      view.backgroundColor = .black
      view.alpha = 0.1
      return view
  }()
  
  private lazy var alertBackgroundImageView: UIImageView = {
      let imageView = UIImageView(image: UIImage(named: "cancel_alert_bg"))
      imageView.contentMode = .scaleToFill
      return imageView
  }()
  
  private lazy var titleLabel: UILabel = {
      let label = UILabel()
      label.text = "Confirm to cancel\naccount?"
    label.numberOfLines = 0
      label.font = .systemFont(ofSize: 16, weight: .heavy)
      label.textColor = UIColor(hex: "06101C")
      label.textAlignment = .center
      return label
  }()
  
  private lazy var messageLabel: UILabel = {
      let label = UILabel()
      label.text = "After canceling your account, your personal information, transaction records, etc. will not be recovered. Please confirm that important data has been backed up, or contact customer service to resolve security issues."
    label.font = .systemFont(ofSize: 14, weight: .medium)
      label.textColor = UIColor(hex: "06101C")
      label.numberOfLines = 0
    label.lineBreakMode = .byTruncatingTail
      label.textAlignment = .center
      return label
  }()
  
  private lazy var leftButton: UIButton = {
      let button = UIButton(type: .custom)
      button.setBackgroundImage(UIImage(named: "alert_default"), for: .normal)
      button.setTitle("Confirm", for: .normal)
      button.titleLabel?.font = .systemFont(ofSize: 15, weight: .bold)
      button.addTarget(self, action: #selector(leftButtonTapped), for: .touchUpInside)
      return button
  }()
  
  private lazy var rightButton: UIButton = {
      let button = UIButton(type: .custom)
      button.setBackgroundImage(UIImage(named: "alert_destrutive"), for: .normal)
      button.setTitle("Cancel", for: .normal)
      button.titleLabel?.font = .systemFont(ofSize: 15, weight: .bold)
      button.addTarget(self, action: #selector(rightButtonTapped), for: .touchUpInside)
      return button
  }()
  
  private var isChecked = false
  
  private lazy var checkButton: UIButton = {
      let button = UIButton(type: .custom)
      button.setImage(UIImage(named: "checkmark_unselected"), for: .normal)
      button.setImage(UIImage(named: "checkmark_selected"), for: .selected)
      button.addTarget(self, action: #selector(checkButtonTapped), for: .touchUpInside)
      return button
  }()
  
  private lazy var agreementLabel: UILabel = {
      let label = UILabel()
      label.text = "I have read and agree to the above"
      label.font = .systemFont(ofSize: 12)
      label.textColor = UIColor(hex: "6C6C6C")
      return label
  }()
  
  override func viewDidLoad() {
      super.viewDidLoad()
      setupUI()
      
      // 在视图加载时就隐藏 tabWindow
      sceneDelegate?.tabWindow?.isHidden = true
  }
  
  override func viewWillDisappear(_ animated: Bool) {
      super.viewWillDisappear(animated)
      // 显示 tabWindow
      sceneDelegate?.tabWindow?.isHidden = false
  }
  
  private func setupUI() {
      view.backgroundColor = .clear
      modalPresentationStyle = .fullScreen
      
      view.addSubview(backgroundView)
      view.addSubview(containerView)
      containerView.addSubview(alertBackgroundImageView)
      containerView.addSubview(titleLabel)
      containerView.addSubview(messageLabel)
      containerView.addSubview(leftButton)
      containerView.addSubview(rightButton)
      containerView.addSubview(checkButton)
      containerView.addSubview(agreementLabel)
      
      setupConstraints()
  }
  
  private func setupConstraints() {
      backgroundView.snp.makeConstraints { make in
          make.edges.equalToSuperview()
      }
      
      containerView.snp.makeConstraints { make in
          make.center.equalToSuperview()
          make.width.equalTo(280)
          make.height.equalTo(330)
      }
      
      alertBackgroundImageView.snp.makeConstraints { make in
        make.center.equalToSuperview()
      }
      
      titleLabel.snp.makeConstraints { make in
          make.top.equalToSuperview().offset(16)
          make.centerX.equalToSuperview()
      }
      
      messageLabel.snp.makeConstraints { make in
          make.top.equalTo(titleLabel.snp.bottom).offset(32)
          make.centerX.equalToSuperview()
        make.leading.trailing.equalToSuperview().inset(16)
      }
//      
      leftButton.snp.makeConstraints { make in
          make.left.equalToSuperview().offset(20)
        make.top.equalTo(messageLabel.snp.bottom).offset(12)
          make.width.equalTo(100)
          make.height.equalTo(40)
      }
//      
      rightButton.snp.makeConstraints { make in
          make.right.equalToSuperview().offset(-20)
          
        make.bottom.width.height.equalTo(leftButton)
          
      }
      
      checkButton.snp.makeConstraints { make in
        make.leading.equalTo(messageLabel)
          make.top.equalTo(leftButton.snp.bottom).offset(16)
          make.width.height.equalTo(20)
      }
      
      agreementLabel.snp.makeConstraints { make in
          make.centerY.equalTo(checkButton)
          make.left.equalTo(checkButton.snp.right).offset(8)
      }
  }
  
  override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      // 隐藏 tabWindow
      if let windowScene = view.window?.windowScene,
         let sceneDelegate = windowScene.delegate as? SceneDelegate {
          sceneDelegate.tabWindow?.isHidden = true
      }
  }
  
  private func animateOut(completion: @escaping () -> Void) {
      UIView.animate(withDuration: 0.25, animations: {
          self.backgroundView.alpha = 0
          self.containerView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
      }) { _ in
          completion()
      }
  }
  
  @objc private func checkButtonTapped() {
      isChecked.toggle()
      checkButton.isSelected = isChecked
  }
  
  @objc func leftButtonTapped() {
      // 确认按钮只有在同意条款时才能执行
      guard isChecked else {
        ProgressHUD.error("You should select the checkbox")
          return
      }
      
    
    animateOut { [weak self] in
        self?.dismiss(animated: false)
        self?.dismissCallback?()
    }
  }
  
  @objc func rightButtonTapped() {
    animateOut { [weak self] in
        self?.dismiss(animated: false)
    }
  }
}
