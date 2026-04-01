//
//  AuthPublicSuccessViewController.swift
//  NewNewStarLoan
//
//  Created by Albert on 2025/5/25.
//

import UIKit
import Foundation
import SnapKit
import ProgressHUD

class AuthPublicSuccessViewController: UIViewController {
  
  // Add productId property
  var response: CertificateFirstResponse?
  private let productId: String
  init(productId: String) {
      self.productId = productId
      super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .white
    setupUI()
    
    ProgressHUD.animate("Fetching...")
    Task {
        do {
            let response = try await CertificateService.shared.getUserPublicInfo(feud: productId, warm: String.generateUUID())
            self.response = response
            await MainActor.run {
                ProgressHUD.dismiss()
                updateUIWithResponse()  // 添加这一行
            }
        }
    }
}
  
  
  private lazy var nextStepButton: UIButton = {
    let button = UIButton(type: .custom)
    button.setBackgroundImage(UIImage(named: "cpxq_b"), for: .normal)
    button.setTitle("Next Step", for: .normal)
    button.titleLabel?.font = .systemFont(ofSize: 16, weight: .heavy)
    button.setTitleColor(.white, for: .normal)
    button.addTarget(self, action: #selector(nextStepButtonTapped), for: .touchUpInside)
    return button
  }()
  
  private lazy var navigationBar: CustomNavigationBar = {
    let nav = CustomNavigationBar()
    nav.backButtonTapped = { [weak self] in
      self?.dismiss(animated: true)
    }
    return nav
  }()
  
  private lazy var backgroundImageView: UIImageView = {
    let imageView = UIImageView(image: UIImage(named: "rzcg_bg"))
    imageView.isUserInteractionEnabled = true
    return imageView
  }()
  
  private lazy var successImageView: UIImageView = {
    let imageView = UIImageView(image: UIImage(named: "rzcg_bg_01"))
    imageView.isUserInteractionEnabled = true
    return imageView
  }()
  
  private lazy var containerImageView: UIImageView = {
    let imageView = UIImageView(image: UIImage(named: "rzcg_bg_02"))
    imageView.isUserInteractionEnabled = true
    return imageView
  }()
  
  private lazy var stackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.spacing = 14  // 设置垂直间距为14pt
    return stackView
  }()
  
  private func createInfoView(withTitle title: String, value: String) -> UIView {
    let containerView = UIView()
    
    let imageView = UIImageView(image: UIImage(named: "sfxx_pu_bg_01"))
    imageView.contentMode = .scaleToFill
    
    let titleLabel = UILabel()
    titleLabel.text = title
    titleLabel.font = .systemFont(ofSize: 14, weight: .medium)
    titleLabel.textColor = UIColor(hex: "4999F7")
    
    let valueLabel = UILabel()
    valueLabel.text = value
    valueLabel.font = .systemFont(ofSize: 14, weight: .medium)
    valueLabel.textColor = UIColor(hex: "06101C")
    
    containerView.addSubview(imageView)
    containerView.addSubview(titleLabel)
    containerView.addSubview(valueLabel)
    
    imageView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    
    titleLabel.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(12)
      make.leading.equalToSuperview().offset(15)
    }
    
    valueLabel.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(56)
      make.leading.equalToSuperview().offset(30)
    }
    
    return containerView
  }
  
  private func setupUI() {
    // 隐藏系统导航栏
    navigationController?.setNavigationBarHidden(true, animated: false)
    
    // 添加自定义导航栏和其他基础 UI 元素
    view.addSubview(navigationBar)
    view.addSubview(backgroundImageView)
    view.addSubview(nextStepButton)
    view.addSubview(successImageView)
    view.addSubview(containerImageView)
    
    // 设置基础约束
    navigationBar.snp.makeConstraints { make in
      make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
      make.leading.trailing.equalToSuperview()
      make.height.equalTo(44)
    }
    
    // 设置标题
    navigationBar.setTitle("")
    
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
    
    successImageView.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.top.equalTo(navigationBar.snp.bottom).offset(40)
    }
    
    containerImageView.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.top.equalTo(successImageView.snp.bottom).offset(20)
    }
    
    containerImageView.addSubview(stackView)
    stackView.snp.makeConstraints { make in
        make.top.equalToSuperview().offset(14)
        make.centerX.equalToSuperview()
        make.width.equalTo(337)
    }
}
  
  @objc func nextStepButtonTapped() {
    fetchProductDetail()
  }
  
  // 新增一个方法来更新 UI
  private func updateUIWithResponse() {
      // 清除现有的子视图
      stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
      
      // 添加新的信息视图
      let infoViews = [
          ("Full Name", response?.middle.winked.might?.bad ?? ""),
          ("ID NO.", response?.middle.winked.might?.away ?? ""),
          ("Date of Birth", response?.middle.winked.might?.worry ?? "")
      ]
      
      for (title, value) in infoViews {
          let infoView = createInfoView(withTitle: title, value: value)
          stackView.addArrangedSubview(infoView)
          
          infoView.snp.makeConstraints { make in
              make.height.equalTo(100)
          }
      }
  }
  
  private func fetchProductDetail() {
    ProgressHUD.animate("Fetching...")
    Task {
      do {
        let result = try await ProductService.shared.getProductDetail(
          feud: productId,
          staying: String.generateUUID(),
          since: String.generateUUID()
        )
        await MainActor.run {
          ProgressHUD.dismiss()
          
          if result.middle.wedneskpiday == nil {
            navigationController?.popToRootViewController(animated: true)
            return
          }
          
          if let wedneskpiday = result.middle.wedneskpiday {
            if wedneskpiday.cousin == "nbaallstarh" {
              Task {
                do {
                  let response = try await CertificateService.shared.getWorkInfo(feud: productId)  // 使用 productId
                  await MainActor.run {
                    ProgressHUD.dismiss()
                    let vc = AuthWorkInfoViewController(viewModel: AuthWorkInfoViewModel(formFields: response.middle.stopped, productId: productId))
                    self.navigationController?.pushViewController(vc, animated: true)
                  }
                } catch {
                  
                }
              }
            } else if wedneskpiday.cousin == "nbaallstarg" {
              Task {
                do {
                  let response = try await CertificateService.shared.getUserInfo(feud: productId)  // 使用 productId
                  await MainActor.run {
                    ProgressHUD.dismiss()
                    let vc = AuthPersonalInfoViewController(viewModel: AuthPersonalInfoViewModel(formFields: response.middle.stopped, productId: productId))
                    self.navigationController?.pushViewController(vc, animated: true)
                  }
                } catch {
                  
                }
              }
            } else if wedneskpiday.cousin == "nbaallstari" {
              Task {
                do {
                  let response = try await CertificateService.shared.getContactInfo(feud: productId)  // 使用 productId
                  await MainActor.run {
                    ProgressHUD.dismiss()
                    let vc = AuthContactViewController(viewModel: AuthContactViewModel(formData: response.middle.intellectual, productId: productId))
                    self.navigationController?.pushViewController(vc, animated: true)
                  }
                } catch {
                  
                }
              }
            } else {
              Task {
                do {
                  let response = try await CertificateService.shared.getBankCardInfo()
                  await MainActor.run {

                    let vc = AuthBankInfoViewController(formData: response.middle, productId: productId)
                    self.navigationController?.pushViewController(vc, animated: true)

                  }
                }
              }
            }

          } else {
            self.navigationController?.popViewController(animated: true)
          }
        }
      } catch {
        
      }
    }
  }
}


