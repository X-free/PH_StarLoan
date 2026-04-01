//
//  PermissionPromptAlertViewController.swift
//  NewNewStarLoan
//
//  Created by Albert on 2025/5/15.
//

import UIKit
import SnapKit

class PermissionPromptAlertViewController: UIViewController {
  
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
    view.alpha = 0.9
      return view
  }()
  
  private lazy var alertBackgroundImageView: UIImageView = {
      let imageView = UIImageView(image: UIImage(named: "tc_pu_bg"))
      imageView.contentMode = .scaleToFill
      return imageView
  }()
  
  
  private lazy var titleLabel: UILabel = {
      let label = UILabel()
      label.text = "Permission Required"
      label.numberOfLines = 0
      label.font = .systemFont(ofSize: 16, weight: .heavy)
      label.textColor = UIColor(hex: "06101C")
      label.textAlignment = .center
      return label
  }()
  
  private lazy var messageLabel: UILabel = {
      let label = UILabel()
      label.text = "Your loan limit is still waiting for\nyou! Remember to come back\noften~"
    label.font = .systemFont(ofSize: 14, weight: .medium)
      label.textColor = UIColor(hex: "06101C")
      label.numberOfLines = 0
      label.textAlignment = .center
      return label
  }()
  
  private lazy var okButton: UIButton = {
      let button = UIButton(type: .custom)
    button.setBackgroundImage(UIImage(named: "alert_default"), for: .normal)
      button.setTitle("Stop", for: .normal)
      button.titleLabel?.font = .systemFont(ofSize: 15, weight: .bold)
      button.addTarget(self, action: #selector(okButtonTapped), for: .touchUpInside)
      return button
  }()
  
  private lazy var cancelButton: UIButton = {
      let button = UIButton(type: .custom)

    button.setBackgroundImage(UIImage(named: "alert_destrutive"), for: .normal)
      button.setTitle("Turning On", for: .normal)
      button.titleLabel?.font = .systemFont(ofSize: 15, weight: .bold)
      button.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
      return button
  }()
  
  override func viewDidLoad() {
      super.viewDidLoad()
      setupUI()
      
    self.view.backgroundColor = .white
      // 在视图加载时就隐藏 tabWindow
      sceneDelegate?.tabWindow?.isHidden = true
  }
  
  
  override func viewWillDisappear(_ animated: Bool) {
      super.viewWillDisappear(animated)
      // 显示 tabWindow
      sceneDelegate?.tabWindow?.isHidden = false
  }
  
  private func setupUI() {
      
      modalPresentationStyle = .fullScreen
      
      view.addSubview(backgroundView)
      view.addSubview(containerView)
      containerView.addSubview(alertBackgroundImageView)
      containerView.addSubview(titleLabel)
      containerView.addSubview(messageLabel)
      containerView.addSubview(okButton)
      containerView.addSubview(cancelButton)
      
      setupConstraints()
  }
  
  private func setupConstraints() {
      backgroundView.snp.makeConstraints { make in
          make.edges.equalToSuperview()
      }
      
      containerView.snp.makeConstraints { make in
          make.center.equalToSuperview()
          make.width.equalTo(280)
          make.height.equalTo(240)
      }
      
      alertBackgroundImageView.snp.makeConstraints { make in
        make.center.equalToSuperview()
      }
      
      titleLabel.snp.makeConstraints { make in
          make.top.equalToSuperview().offset(24)
          make.centerX.equalToSuperview()
      }
      
      messageLabel.snp.makeConstraints { make in
          make.top.equalTo(titleLabel.snp.bottom).offset(40)
        make.leading.trailing.equalToSuperview().inset(20)
      }
      
      okButton.snp.makeConstraints { make in
          make.left.equalToSuperview().offset(20)
          make.bottom.equalToSuperview().offset(-20)
          make.width.equalTo(100)
          make.height.equalTo(40)
      }
      
      cancelButton.snp.makeConstraints { make in
          make.right.equalToSuperview().offset(-20)
          make.bottom.equalToSuperview().offset(-20)
          make.width.equalTo(100)
          make.height.equalTo(40)
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
  
  @objc private func okButtonTapped() {
      animateOut { [weak self] in
          self?.dismiss(animated: false)
          self?.dismissCallback?()
      }
  }
  
  @objc private func cancelButtonTapped() {
      animateOut { [weak self] in
        if let appSettings = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
        }
          self?.dismiss(animated: false)
      }
  }
  
  func configureMessageLabel(with text: String) {
    self.messageLabel.text = text
  }
}
