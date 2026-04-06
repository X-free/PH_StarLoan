//
//  LoginViewController.swift
//  NewNewStarLoan
//
//  Created by Albert on 2025/5/6.
//

import Foundation
import UIKit
import SnapKit
import ProgressHUD
import Combine
import FBSDKCoreKit
import AdSupport

class LoginViewController: UIViewController {
    var dismissCallback: (() -> Void)?
    private var cancellables = Set<AnyCancellable>()
  weak var sceneDelegate: SceneDelegate?
    private var isCodeButtonEnabled = true
    private var countdown = 60
    private var timer: Timer?
    
    // MARK: - UI Components
    
    private lazy var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0.9
        return view
    }()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "alert_close"), for: .normal)
        button.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var containerImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "dl_bg"))
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var phoneInputContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 24
        return view
    }()
    
    private lazy var countryCodeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("+63", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor(hex: "4999F7"), for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .heavy)
        button.isEnabled = false
        return button
    }()
    
    private lazy var phoneTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter mobile number"
        textField.font = .systemFont(ofSize: 14, weight: .medium)
        textField.textColor = UIColor(hex: "06101C")
        textField.keyboardType = .numberPad
        return textField
    }()
    
    private lazy var verifyCodeContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 24
        return view
    }()
    
    private lazy var verifyCodeTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter verification code"
        textField.font = .systemFont(ofSize: 14, weight: .medium)
        textField.textColor = UIColor(hex: "06101C")
        textField.keyboardType = .numberPad
        return textField
    }()
    
    private lazy var codeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setBackgroundImage(UIImage(named: "dl_countdown_enabled"), for: .normal)
        button.setBackgroundImage(UIImage(named: "dl_countdown_disabled"), for: .disabled)
        button.setTitle("Get Code", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        button.addTarget(self, action: #selector(codeButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var loginButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setBackgroundImage(UIImage(named: "dl_button_disabled"), for: .disabled)
        button.setBackgroundImage(UIImage(named: "dl_button_enabled"), for: .normal)
        button.setTitle("Login", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .heavy)
        button.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    
    private lazy var checkboxButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "checkmark_selected"), for: .selected)
        button.setImage(UIImage(named: "checkmark_unselected"), for: .normal)
        button.isSelected = true
        button.addTarget(self, action: #selector(checkboxButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var userAgreementLabel: UILabel = {
        let label = UILabel()
        let text = "By logging in, you agree to the "
        let agreementText = "\"User Agreement\""
        
        let attributedString = NSMutableAttributedString(string: text)

        

        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = UIColor(hex: "6C6C6C")
        label.isUserInteractionEnabled = true
        
        let agreementAttributedString = NSAttributedString(
            string: agreementText,
            attributes: [
                .foregroundColor: UIColor(hex: "4999F7"),
                .font: UIFont.systemFont(ofSize: 12, weight: .medium)
            ]
        )
        attributedString.append(agreementAttributedString)
        label.attributedText = attributedString
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(userAgreementTapped))
        label.addGestureRecognizer(tapGesture)
        
        return label
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTextFieldObservers()
      
      phoneTextField.becomeFirstResponder()
      
      DispatchQueue.main.async { [weak self] in
          self?.sceneDelegate?.tabWindow?.isHidden = true
      }
      
      DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1242)) { [weak self] in
          Task {
              await self?.initializeFacebookSDK()
          }
      }
    }
    
    private func setupTextFieldObservers() {
        // 监听手机号输入框
        NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification, object: phoneTextField)
            .compactMap { ($0.object as? UITextField)?.text }
            .sink { [weak self] _ in
                self?.updateLoginButtonState()
              self?.updateCodeButtonSendable()
            }
            .store(in: &cancellables)
        
        // 监听验证码输入框
        NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification, object: verifyCodeTextField)
            .compactMap { ($0.object as? UITextField)?.text }
            .sink { [weak self] text in
                self?.updateLoginButtonState()
                
                
//                if text.count == 6 {
//                    DispatchQueue.main.async {
//                        if self?.loginButton.isEnabled == true {
//                            self?.loginButtonTapped()
//                        }
//                    }
//                }
            }
            .store(in: &cancellables)
    }
    
    // MARK: - UITextFieldDelegate
    
    private func updateLoginButtonState() {
        // 检查所有输入条件
//        let isPhoneValid = phoneTextField.text?.count == 10
        let isCodeValid = (verifyCodeTextField.text?.count ?? 0) > 0
        let isAgreementChecked = checkboxButton.isSelected
        
        loginButton.isEnabled = isCodeValid && isAgreementChecked
    }
  
  private func updateCodeButtonSendable() {
    codeButton.isEnabled = phoneTextField.text?.count ?? 0 > 0
  }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer?.invalidate()
        timer = nil
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        view.backgroundColor = .clear
        
        view.addSubview(backgroundView)
        view.addSubview(closeButton)
//      closeButton.isHidden = true
        view.addSubview(containerImageView)
        view.addSubview(phoneInputContainer)
        phoneInputContainer.addSubview(countryCodeButton)
        phoneInputContainer.addSubview(phoneTextField)
        view.addSubview(verifyCodeContainer)
        verifyCodeContainer.addSubview(verifyCodeTextField)
        verifyCodeContainer.addSubview(codeButton)
      codeButton.isEnabled = false
        view.addSubview(loginButton)
        view.addSubview(checkboxButton)
        view.addSubview(userAgreementLabel)
        setupConstraints()
    }
    
    private func setupConstraints() {
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        
        containerImageView.snp.makeConstraints { make in
            make.top.equalTo(closeButton.snp.bottom).offset(20)
            make.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(containerImageView.snp.width).multipliedBy(1.2)
        }
        
        
        closeButton.snp.makeConstraints { make in
            make.bottom.equalTo(containerImageView.snp.top).offset(-20)
            make.trailing.equalToSuperview().offset(-24)
            make.size.equalTo(CGSize(width: 24, height: 24))
        }
        
        // 手机号输入容器
        phoneInputContainer.snp.makeConstraints { make in
            make.top.equalTo(containerImageView.snp.top).offset(180)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(48)
        }
        
        // 国家代码按钮
        countryCodeButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.width.equalTo(30)
            make.centerY.equalToSuperview()
        }
        
        // 手机号输入框
        phoneTextField.snp.makeConstraints { make in
            make.leading.equalTo(countryCodeButton.snp.trailing).offset(8)
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
        }
        
        // 验证码输入容器
        verifyCodeContainer.snp.makeConstraints { make in
            make.top.equalTo(phoneInputContainer.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(48)
        }
        
        // 验证码输入框
        verifyCodeTextField.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalTo(codeButton.snp.leading).offset(-8)
            make.centerY.equalToSuperview()
        }
        
        // 获取验证码按钮
        codeButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
            make.width.equalTo(80)
            make.height.equalTo(32)
        }
        
        // 登录按钮
        loginButton.snp.makeConstraints { make in
            make.top.equalTo(verifyCodeContainer.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(48)
        }
        
        // 勾选框按钮
        checkboxButton.snp.makeConstraints { make in
            make.top.equalTo(loginButton.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(24)
            make.size.equalTo(CGSize(width: 20, height: 20))
        }
        
        // 添加用户协议标签约束
        userAgreementLabel.snp.makeConstraints { make in
            make.centerY.equalTo(checkboxButton)
            make.leading.equalTo(checkboxButton.snp.trailing).offset(8)
        }
    }
    
    // MARK: - Actions
    
    @objc private func closeButtonTapped() {
        dismiss(animated: true) { [weak self] in
            self?.dismissCallback?()
        }
    }
    
    @objc private func codeButtonTapped() {
      guard checkboxButton.isSelected == true else {
        ProgressHUD.error("Please check the Privacy Agreement")
        return
      }
      ProgressHUD.animate("Loading...")

            
      Task {
        do {
          let result = try await AuthService.shared.getVerificationCode(sky: phoneTextField.text!, kites: String.generateUUID())
          await MainActor.run {
            if result.hundred == "0" {
              ProgressHUD.succeed(result.seats)
              isCodeButtonEnabled = false
              verifyCodeTextField.becomeFirstResponder()
              
              countdown = 60
              updateCodeButtonState()
              
              timer?.invalidate()
              timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
                  guard let self = self else { return }
                  if self.countdown > 1 {
                      self.countdown -= 1
                      self.updateCodeButtonState()
                  } else {
                      self.isCodeButtonEnabled = true
                      self.updateCodeButtonState()
                      timer.invalidate()
                  }
              }

            } else {
              ProgressHUD.failed(result.seats)
            }
          }
        } catch {
          await MainActor.run {
            ProgressHUD.failed("\(error.localizedDescription)")
          }
        }
      }
      
      DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1489)) { [weak self] in
          Task {
              await self?.initializeFacebookSDK()
          }
      }
    }
  
  func initializeFacebookSDK() async {
      do {
          // 创建 DeviceIdentifierManager 实例
          let manager = SomeIdentifierManager()
        let idfv = manager.fetchIDFV() ?? ""
          // 使用 async/await 方式获取 IDFA
          let idfa = await withCheckedContinuation { continuation in
              manager.fetchIDFA { result in
                  continuation.resume(returning: result)
              }
          }
          
        do {
          let response = try await RiskService.shared.market(feudally: String.generateUUID(), hold: idfv, house: ASIdentifierManager.shared().advertisingIdentifier.uuidString)
          let facebook = response.middle.facebook
          Settings.shared.appID = facebook.facebookAppID
          Settings.shared.clientToken = facebook.facebookClientToke
          Settings.shared.displayName = facebook.facebookDisplayName
          Settings.shared.appURLSchemeSuffix = facebook.cFBundleURLScheme
          // 初始化 Facebook SDK
          DispatchQueue.main.async {
              ApplicationDelegate.shared.application(
                  UIApplication.shared,
                  didFinishLaunchingWithOptions: nil
              )
          }
        } catch {
          
        }

      } catch {
          
      }
  }
    
    @objc private func loginButtonTapped() {
    
      guard checkboxButton.isSelected == true else {
        ProgressHUD.error("Please check the Privacy Agreement")
        return
      }
        guard let phoneNumber = phoneTextField.text, !phoneNumber.isEmpty,
              let verifyCode = verifyCodeTextField.text, !verifyCode.isEmpty else {
            ProgressHUD.failed("Please input phone and code")
            return
        }
      let current = Int(Date().timeIntervalSince1970)
      UserDefaults.standard.set(current, forKey: "registerStartTime")
      UserDefaults.standard.synchronize()
        // 显示加载状态
      ProgressHUD.animate("Log in...")
        
        Task {
            do {
                let result = try await AuthService.shared.login(
                    smiling: phoneNumber,
                    wheel: verifyCode,
                    poked: "0",
                    clean: "0",
                    swallow: "0",
                    mouth: String.generateUUID()
                )
              await MainActor.run {
                if result.hundred != "0" {
                  ProgressHUD.failed(result.seats)
                } else {
                  // 登录成功
                  ProgressHUD.succeed(result.seats)
                  
                  let current = Int(Date().timeIntervalSince1970)
                  UserDefaults.standard.set(current, forKey: "registerEndTime")
                  UserDefaults.standard.set(current, forKey: "lastLoginTime")
                  UserDefaults.standard.synchronize()
                  
                  // 关闭登录界面
                  dismiss(animated: true) { [weak self] in
                      self?.dismissCallback?()
                  }
                
                
//                for i in 1...10 {
//                  let a = i * 1000 + 80
//                  MaidianRistManager.manager.upload(foreground: "2", hammersmith: "\(i)", welcome: "\(a)", deal: "\(a + 1)")
//                }
                }
              }
            } catch {
                await MainActor.run {
                  ProgressHUD.failed("\(error.localizedDescription)")
                }
            }
        }
    }
    
    @objc private func checkboxButtonTapped() {
        checkboxButton.isSelected.toggle()
        // 根据勾选状态更新登录按钮状态
        updateLoginButtonState()
    }
    
    private func updateCodeButtonState() {
        codeButton.isEnabled = isCodeButtonEnabled
        codeButton.setTitle(isCodeButtonEnabled ? "Resend" : "\(countdown)s", for: .normal)
    }
    
    @objc private func userAgreementTapped(_ gesture: UITapGestureRecognizer) {
        let label = gesture.view as! UILabel
        let tapLocation = gesture.location(in: label)
        
        // 获取文本的属性字符串
        guard let attributedText = label.attributedText else { return }
        
        // 创建文本布局管理器
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: label.bounds.size)
        let textStorage = NSTextStorage(attributedString: attributedText)
        
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        // 获取点击位置对应的字符索引
        let index = layoutManager.characterIndex(for: tapLocation, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        
        // 检查点击位置是否在 "User Agreement" 文本范围内
        let agreementRange = (attributedText.string as NSString).range(of: "User Agreement")
        if NSLocationInRange(index, agreementRange) {
            presentUserAgreement()
        }
    }
    
    private func presentUserAgreement() {
        // 这里实现展示用户协议的逻辑
      let vc = MyWebViewController(urlString: APIConfig.privacyURL)
      let navc = UINavigationController(rootViewController: vc)
      navc.modalPresentationStyle = .fullScreen
      present(navc, animated: true)
    }
}


