//
//  AuthFaceViewController.swift
//  NewNewStarLoan
//
//  Created by Albert on 2025/5/7.
//

import UIKit
import Foundation
import SnapKit
import Photos
import AVFoundation
import ProgressHUD
import AdSupport

class AuthFaceViewController: UIViewController {
  
  private let analy = AnalyticsService()

  var start4 = 0
  private lazy var imagePicker: MyCustomImagePickerController = {
      let picker = MyCustomImagePickerController()
//    picker.hideCameraButton()
      picker.delegate = self
    picker.sourceType = .camera
      return picker
  }()
  
  var productId: String?
  var idType: String?
  
  init(idType: String, productId: String) {
    self.idType = idType
    
    self.productId = productId
    super.init(nibName: nil, bundle: nil)
    
    analy.startTracking(.chooseIdRecognize, additionalParams: ["product_id": productId])
    start4 = Int(Date().timeIntervalSince1970)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private lazy var scrollView: UIScrollView = {
      let scrollView = UIScrollView()
      scrollView.showsHorizontalScrollIndicator = false
      return scrollView
  }()
  
  private lazy var stackView: UIStackView = {
      let stackView = UIStackView()
      stackView.axis = .horizontal
      stackView.spacing = 8
      stackView.alignment = .top  // 设置为顶部对齐
      stackView.distribution = .fill  // 改为 fill 而不是 fillEqually
      return stackView
  }()
  
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
  
  private lazy var nextStepButton: UIButton = {
    let button = UIButton(type: .custom)
    button.setBackgroundImage(UIImage(named: "cpxq_b"), for: .normal)
    button.setTitle("Next Step", for: .normal)
    button.titleLabel?.font = .systemFont(ofSize: 16, weight: .heavy)
    button.setTitleColor(.white, for: .normal)
    return button
  }()
  
  private lazy var backgroundImageView: UIImageView = {
    let imageView = UIImageView(image: UIImage(named: "xzrzfs_bg"))
    imageView.isUserInteractionEnabled = true
    return imageView
  }()
  
  private lazy var containerImageView01: UIImageView = {
    let imageView = UIImageView(image: UIImage(named: "sczj_bg_01"))
    imageView.isUserInteractionEnabled = true
    return imageView
  }()
  
  private lazy var containerImageView02: UIImageView = {
    let imageView = UIImageView(image: UIImage(named: "sczj_bg_02"))
    imageView.isUserInteractionEnabled = true
    return imageView
  }()
  
  private lazy var containerImageView03: UIImageView = {
    let imageView = UIImageView(image: UIImage(named: "sczj_bg_03"))
    imageView.isUserInteractionEnabled = true
    return imageView
  }()
  
  private lazy var idBgImageView: UIImageView = {
    let imageView = UIImageView(image: UIImage(named: "sczj_id_bg"))
    imageView.isUserInteractionEnabled = true
    return imageView
  }()
  
  private lazy var idImageView: UIImageView = {
    let imageView = UIImageView(image: UIImage(named: "rl_bg_04"))
    imageView.isUserInteractionEnabled = true
    return imageView
  }()
  
  private lazy var containerImageView04: UIImageView = {
    let imageView = UIImageView(image: UIImage(named: "sczj_bg_04"))
    imageView.isUserInteractionEnabled = true
    return imageView
  }()
  
  private lazy var captureButton: UIButton = {
    let button = UIButton(type: .custom)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setImage(UIImage(named: "sczj_capture"), for: .normal)
    return button
  }()
  
  private lazy var typeLabel: UILabel = {
    let label = UILabel()
    label.textAlignment = .center
    label.textColor = .white
    label.font = .systemFont(ofSize: 14, weight: .bold)
    return label
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    setupUI()
  }
  
  private func setupUI() {
    // 隐藏系统导航栏
    navigationController?.setNavigationBarHidden(true, animated: false)
    
    // 添加自定义导航栏
    view.addSubview(navigationBar)
    view.addSubview(backgroundImageView)
    view.addSubview(nextStepButton)
    
    // 设置导航栏约束
    navigationBar.snp.makeConstraints { make in
      make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
      make.leading.trailing.equalToSuperview()
      make.height.equalTo(44)
    }
    
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
    
    backgroundImageView.addSubview(containerImageView01)
    containerImageView01.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(14)
      make.leading.trailing.equalToSuperview().inset(15)
      
    }
    
    backgroundImageView.addSubview(containerImageView02)
    containerImageView02.snp.makeConstraints { make in
      make.top.equalTo(containerImageView01.snp.bottom)
      make.leading.trailing.equalTo(containerImageView01)
      
    }
    
    backgroundImageView.addSubview(containerImageView03)
    containerImageView03.snp.makeConstraints { make in
      make.top.equalTo(containerImageView02.snp.bottom)
      make.leading.trailing.equalTo(containerImageView01)
      
    }
    
    backgroundImageView.addSubview(containerImageView04)
    containerImageView04.snp.makeConstraints { make in
      make.top.equalTo(containerImageView03.snp.bottom)
      make.leading.trailing.equalTo(containerImageView01)
    }
    
    // 设置标题
    navigationBar.setTitle("Verify Identity")
    
    containerImageView02.addSubview(idBgImageView)
    idBgImageView.snp.makeConstraints { make in
      make.center.equalToSuperview()
      make.top.equalToSuperview().offset(5)
    }
//    
    idBgImageView.addSubview(idImageView)
    idImageView.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.top.equalToSuperview().offset(20)
    }
    
    idBgImageView.addSubview(typeLabel)
    typeLabel.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview()
      make.bottom.equalToSuperview().offset(-15)
    }
    
    typeLabel.text = "Face"
    
    idImageView.addSubview(captureButton)
    captureButton.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    
    captureButton.addTarget(self, action: #selector(captureButtonDidTapped), for: .touchUpInside)
    nextStepButton.addTarget(self, action: #selector(nextStepButtonDidTapped), for: .touchUpInside)
    
    containerImageView01.addSubview(scrollView)
    scrollView.addSubview(stackView)
    
    scrollView.snp.makeConstraints { make in
      make.top.bottom.equalToSuperview().inset(8)
      make.leading.trailing.equalToSuperview().inset(8)
      
    }
    
    stackView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    
    // 添加图片视图
    let imageConfigs = [
        ("vi_selected", "vi"),
        ("pi_unselected", "pi"),
        ("wi_unselected", "wi"),
        ("ci_unselected", "ci"),
        ("bci_unselected", "bci")
    ]
    
    for (imageName, id) in imageConfigs {
        let imageView = createImageView(imageName: imageName, id: id)
        imageView.contentMode = .scaleAspectFit
        stackView.addArrangedSubview(imageView)
        
        // 不再设置宽高比例约束，而是保持图片原始尺寸
        if let image = UIImage(named: imageName) {
            imageView.snp.makeConstraints { make in
                make.width.equalTo(image.size.width)
                make.height.equalTo(image.size.height)
            }
        }
    }
    
    containerImageView04.addSubview(tipsLabel)
    tipsLabel.snp.makeConstraints { make in
        make.leading.equalToSuperview().offset(20)
        make.top.equalToSuperview()
        make.trailing.equalToSuperview().offset(-20)
        make.bottom.equalToSuperview().offset(-20)
    }
    
    
  }
  
  private lazy var tipsLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    label.attributedText = createTipsAttributedString()
    return label
  }()
  
  private func createTipsAttributedString() -> NSAttributedString {
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.lineSpacing = 4
    
    let attributedString = NSMutableAttributedString()
    
    // 标题
    let titleAttributes: [NSAttributedString.Key: Any] = [
      .font: UIFont.systemFont(ofSize: 13, weight: .medium),
      .foregroundColor: UIColor(hex: "0B0909"),
      .paragraphStyle: paragraphStyle
    ]
    attributedString.append(NSAttributedString(string: "Face photo requirements\n", attributes: titleAttributes))
    
    // 灰色文本
    let grayAttributes: [NSAttributedString.Key: Any] = [
      .font: UIFont.systemFont(ofSize: 12, weight: .regular),
      .foregroundColor: UIColor(hex: "6C6C6C"),
      .paragraphStyle: paragraphStyle
    ]
    attributedString.append(NSAttributedString(string: "Make sure you operate it yourself\n", attributes: grayAttributes))
    attributedString.append(NSAttributedString(string: "When taking photos, \n", attributes: grayAttributes))
    
    // 蓝色文本
    let blueAttributes: [NSAttributedString.Key: Any] = [
      .font: UIFont.systemFont(ofSize: 12, weight: .regular),
      .foregroundColor: UIColor(hex: "4999F7"),
      .paragraphStyle: paragraphStyle
    ]
    attributedString.append(NSAttributedString(string: "make sure there is enough light\n", attributes: blueAttributes))
    attributedString.append(NSAttributedString(string: "face the camera, and follow the prompts", attributes: blueAttributes))
    
    return attributedString
  }
  
  private func createImageView(imageName: String, id: String) -> UIImageView {
      let imageView = UIImageView(image: UIImage(named: imageName))
      imageView.contentMode = .scaleAspectFit
      imageView.accessibilityIdentifier = id
      return imageView
  }
  
  @objc func captureButtonDidTapped() {
    nextStep()
  }
  
  @objc func nextStepButtonDidTapped() {
    nextStep()
  }
  
  private func nextStep() {
    // 直接调用真实的相机即可
    AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
      
      DispatchQueue.main.async {
        guard let self = self else { return }
        
        if granted {
            self.imagePicker.sourceType = .camera
            
            self.imagePicker.cameraDevice = .front // Use front camera for other steps
            self.imagePicker.cameraCaptureMode = .photo
            self.imagePicker.showsCameraControls = true
          self.imagePicker.hideCameraButton()
            self.present(self.imagePicker, animated: true)
        } else {
          let vc = PermissionPromptAlertViewController()
          vc.modalPresentationStyle = .fullScreen
          vc.configureMessageLabel(with: "To verify your identity, we'll need to access your camera. Please turn on camera permissions in your settings.")
          self.present(vc, animated: true)
        }
      }
    }
  }
}

extension AuthFaceViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  func imagePickerController(_ picker: UIImagePickerController,
                             didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    
    picker.dismiss(animated: true) { [self] in
      guard let image = info[.originalImage] as? UIImage else { return }
      guard let compressedImageData = image.compressTo(maxSizeKB: 500) else { return }
      // 计算数据大小（单位：MB）
      let dataSizeInMB = Double(compressedImageData.count) / (1024 * 1024)
      print(dataSizeInMB)
      ProgressHUD.animate("Uploading...")
      let request = UploadImageModel(
        hating: 2,
        feud: 2,
        mountainside: 10,
        couldn: compressedImageData,
        fun: self.idType!,  // 使用传入的 idType
        kpidays: "",
        kites: String.generateUUID(),
        sleeping: "1"
      )
      
      Task {
        do {
          let response = try await CertificateService.shared.uploadImage(request)
          ProgressHUD.dismiss()
          if let uploadResponse = try? JSONDecoder().decode(UploadFaceRegcognizeResponse.self, from: response), uploadResponse.middle.sank == 0 {
            
            let end4 = Int(Date().timeIntervalSince1970)
            MaidianRistManager.manager.upload(foreground: self.productId ?? "", hammersmith: "4", welcome: "\(start4)", deal: "\(end4)")
            
            do {
              let response = try await CertificateService.shared.getUserInfo(feud: productId!)  // 使用 productId
              await MainActor.run {
                let vc = AuthPersonalInfoViewController(viewModel: AuthPersonalInfoViewModel(formFields: response.middle.stopped, productId: productId!))
                self.navigationController?.pushViewController(vc, animated: true)
              }
            } catch {
              
            }
          } else {
            print("获取上传图片的 response 解码失败了")
          }
        } catch {
          print("图片上传失败：\(error)")
          ProgressHUD.error(error.localizedDescription)
        }
      }
    }
    
    
  }
}

extension AuthFaceViewController {
    func compressImage(_ image: UIImage) -> Data? {
        // 压缩图片到指定大小（500KB = 500 * 1024）
        let maxSize = 500 * 1024
        var compression: CGFloat = 1.0
        
        guard let data = image.jpegData(compressionQuality: compression) else { return nil }
        
        // 如果原图小于500KB，直接返回
        if data.count <= maxSize { return data }
        
        // 压缩图片质量
        compression = CGFloat(maxSize) / CGFloat(data.count)
        return image.jpegData(compressionQuality: compression)
    }
}
