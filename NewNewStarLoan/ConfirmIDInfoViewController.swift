//
//  ConfirmIDInfoViewController.swift
//  NewNewStarLoan
//
//  Created by Albert on 2025/5/7.
//

import Foundation
import UIKit
import ProgressHUD

class ConfirmIDInfoViewController: UIViewController {
  
  let response: UploadIDResponse?
  let idType: String?
  var start3 = 0
  var productid = ""
  
  private var fullName: String = ""
  private var idNumber: String = ""
  private var dateOfBirth: String = ""
  private var selectedDay: Int = 0
  private var selectedMonth: Int = 0
  private var selectedYear: Int = 0
  
  // 添加确认按钮点击的闭包
  var onConfirm: (() -> Void)?
  
  init(response: UploadIDResponse?, idType: String?, onConfirm: (() -> Void)? = nil) {
    self.response = response
    self.idType = idType
    super.init(nibName: nil, bundle: nil)
    
    // 初始化数据
    if let response = response {
        self.fullName = response.middle.bad
        self.idNumber = response.middle.away
      // 日-月-年
        self.dateOfBirth = "\(response.middle.sofa)-\(response.middle.khala)-\(response.middle.fireplace)"
        
        if let day = Int(response.middle.sofa) {
            self.selectedDay = day
        }
        if let month = Int(response.middle.khala) {
            self.selectedMonth = month
        }
        if let year = Int(response.middle.fireplace) {
            self.selectedYear = year
        }
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private lazy var backgroundView: UIView = {
      let view = UIView()
    view.backgroundColor = .black.withAlphaComponent(0.5)
    view.isUserInteractionEnabled = true
      return view
  }()
  
  private lazy var confirmButton: UIButton = {
    let button = UIButton(type: .custom)
    button.setBackgroundImage(UIImage(named: "cpxq_b"), for: .normal)
    button.setTitle("Confirming", for: .normal)
    button.titleLabel?.font = .systemFont(ofSize: 16, weight: .heavy)
    button.setTitleColor(.white, for: .normal)
    return button
  }()
  
  private lazy var closeButton: UIButton = {
    let button = UIButton(type: .custom)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setImage(UIImage(named: "alert_close"), for: .normal)
    return button
  }()
  
  private lazy var containerView: UIView = {
    let view = UIView()
    view.backgroundColor = .white
    view.layer.masksToBounds = true
    view.layer.cornerRadius = 24
    view.isUserInteractionEnabled = true
    return view
  }()
  
  private lazy var stackView: UIStackView = {
      let stackView = UIStackView()
      stackView.axis = .vertical
      stackView.spacing = 14  // 设置垂直间距为14pt
      return stackView
  }()
  
  private func createInfoView(withTitle title: String, index: Int) -> UIView {
      let containerView = UIView()
      
      let imageView = UIImageView(image: UIImage(named: "sfxx_pu_bg_01"))
      imageView.contentMode = .scaleToFill
      
      let titleLabel = UILabel()
      titleLabel.text = title
      titleLabel.font = .systemFont(ofSize: 14, weight: .medium)
      titleLabel.textColor = UIColor(hex: "4999F7")
      
      containerView.addSubview(imageView)
      containerView.addSubview(titleLabel)
      
      imageView.snp.makeConstraints { make in
          make.edges.equalToSuperview()
      }
      
      titleLabel.snp.makeConstraints { make in
          make.top.equalToSuperview().offset(12)
          make.leading.equalToSuperview().offset(15)
      }
      
      // 根据不同的索引显示不同的内容
      let textField = UITextField()
      textField.font = .systemFont(ofSize: 14, weight: .medium)
      textField.textColor = UIColor(hex: "06101C")
      
      switch index {
      case 0:
          textField.text = fullName
          textField.keyboardType = .default
          textField.addTarget(self, action: #selector(fullNameChanged(_:)), for: .editingChanged)
      case 1:
          textField.text = idNumber
          textField.keyboardType = .default
          textField.addTarget(self, action: #selector(idNumberChanged(_:)), for: .editingChanged)
      case 2:
          textField.text = dateOfBirth
          textField.isEnabled = false  // 日期不可编辑
          
          // 添加点击手势
          let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dateFieldTapped))
        containerView.addGestureRecognizer(tapGesture)
      default:
          break
      }
      
      containerView.addSubview(textField)
      textField.snp.makeConstraints { make in
          make.top.equalToSuperview().offset(40)
          make.leading.equalToSuperview().offset(30)
          make.width.equalTo(305)
          make.height.equalTo(48)
      }
      
      return containerView
  }
  
  override func viewDidLoad() {
      super.viewDidLoad()
      
      view.backgroundColor = .clear
      view.addSubview(backgroundView)
      
      backgroundView.snp.makeConstraints { make in
          make.edges.equalToSuperview()
      }
      
      backgroundView.addSubview(containerView)
      containerView.snp.makeConstraints { make in
          make.bottom.leading.trailing.equalToSuperview()
          make.height.equalTo(454)
      }
      
      // 添加垂直堆栈视图
      containerView.addSubview(stackView)
      stackView.snp.makeConstraints { make in
          make.top.equalToSuperview().offset(14)  // 顶部间距14pt
        make.centerX.equalToSuperview()
        make.width.equalTo(337)
      }
      
      // 添加三个信息视图
      let titles = ["Full Name", "ID NO.", "Date of Birth"]
      for (index, title) in titles.enumerated() {
          let infoView = createInfoView(withTitle: title, index: index)
          stackView.addArrangedSubview(infoView)
          
          // 设置每个信息视图的高度约束
          infoView.snp.makeConstraints { make in
              make.height.equalTo(100)
          }
      }
      
      containerView.addSubview(confirmButton)
      confirmButton.snp.makeConstraints { make in
          make.centerX.equalToSuperview()
          make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
          make.width.equalTo(337)
          make.height.equalTo(44)
      }
    
    backgroundView.addSubview(closeButton)
    closeButton.snp.makeConstraints { make in
      make.bottom.equalTo(containerView.snp.top).offset(-20)
      make.trailing.equalToSuperview().offset(-20)
    }
    
    closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
    confirmButton.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
  }
  
  @objc func confirmButtonTapped() {
    
    Task {
      do {
        let response = try await CertificateService.shared.saveUserProfileRequest(
          worry: dateOfBirth,
          away: idNumber,
          bad: fullName,
          fun: idType!,
          strug: String.generateUUID()
        )
        if response.hundred == "0" {
          let end3 = Int(Date().timeIntervalSince1970)
          MaidianRistManager.manager.upload(foreground: productid, hammersmith: "3", welcome: "\(start3)", deal: "\(end3)")
          
          await MainActor.run {
            // 需要 push 到下一个页面去了。
            dismiss(animated: true) {
//              self.onConfirm?()
              NotificationCenter.default.post(name: .pushToFaceRecognize, object: nil)
              
            }
          }
        } else {
          ProgressHUD.failed(response.seats)
        }
      } catch {
        print("保存用户信息失败：\(error)")
        ProgressHUD.failed(error.localizedDescription)
      }
    }
  }
  
  @objc private func closeButtonTapped() {
    dismiss(animated: true)
  }
  
  @objc private func dateFieldTapped() {
      let dateVC = DateSelectionViewController(
          day: selectedDay,
          month: selectedMonth,
          year: selectedYear
      ) { [weak self] day, month, year in
          self?.selectedDay = day
          self?.selectedMonth = month
          self?.selectedYear = year
          // 更新日期字符串格式，确保与服务器要求的格式一致
          self?.dateOfBirth = String(format: "%02d-%02d-%04d", day, month, year)
          
          // 更新界面显示
          if let stackView = self?.stackView,
             let dateView = stackView.arrangedSubviews[2] as? UIView,
             let textField = dateView.subviews.first(where: { $0 is UITextField }) as? UITextField {
              textField.text = self?.dateOfBirth
          }
      }
      dateVC.modalPresentationStyle = .overFullScreen
      present(dateVC, animated: true)
  }
  
  @objc private func fullNameChanged(_ textField: UITextField) {
      fullName = textField.text ?? ""
  }

  @objc private func idNumberChanged(_ textField: UITextField) {
      idNumber = textField.text ?? ""
  }
}




