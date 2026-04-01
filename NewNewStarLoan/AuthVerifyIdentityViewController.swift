//
//  AuthVerifyIdentityViewController.swift
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

extension Notification.Name {
  static let pushToFaceRecognize = NSNotification.Name("pushToFaceRecognize")
}

class AuthVerifyIdentityViewController: UIViewController {
  private let analy = AnalyticsService()
  
  var start3 = 0
  // MARK: - Image Picker Controller
  private lazy var imagePicker: MyCustomImagePickerController = {
      let picker = MyCustomImagePickerController()
      picker.delegate = self
      return picker
  }()
  
  var productId: String?
  var idType: String?
  
  init(idType: String, productId: String) {
    self.idType = idType
    
    self.productId = productId
    super.init(nibName: nil, bundle: nil)
    
    analy.startTracking(.chooseIdFront, additionalParams: ["product_id": productId])
    start3 = Int(Date().timeIntervalSince1970)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
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
    attributedString.append(NSAttributedString(string: "Requirements for photographing ID cards\n", attributes: titleAttributes))
    
    // 灰色文本
    let grayAttributes: [NSAttributedString.Key: Any] = [
      .font: UIFont.systemFont(ofSize: 12, weight: .regular),
      .foregroundColor: UIColor(hex: "6C6C6C"),
      .paragraphStyle: paragraphStyle
    ]
    attributedString.append(NSAttributedString(string: "Hold your valid ID card\n", attributes: grayAttributes))
    attributedString.append(NSAttributedString(string: "When taking the photo, make sure that the ID card's\n", attributes: grayAttributes))
    
    // 蓝色文本
    let blueAttributes: [NSAttributedString.Key: Any] = [
      .font: UIFont.systemFont(ofSize: 12, weight: .regular),
      .foregroundColor: UIColor(hex: "4999F7"),
      .paragraphStyle: paragraphStyle
    ]
    attributedString.append(NSAttributedString(string: "border is intact, the writing is clear, and the\n", attributes: blueAttributes))
    attributedString.append(NSAttributedString(string: "brightness is even.", attributes: blueAttributes))
    
    return attributedString
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
  
  private lazy var idBgImageView: UIImageView = {
    let imageView = UIImageView(image: UIImage(named: "sczj_id_bg"))
    imageView.isUserInteractionEnabled = true
    return imageView
  }()
  
  private lazy var idImageView: UIImageView = {
    let imageView = UIImageView(image: UIImage(named: "sczj_id"))
    imageView.isUserInteractionEnabled = true
    return imageView
  }()
  
  private lazy var captureButton: UIButton = {
    let button = UIButton(type: .custom)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setImage(UIImage(named: "sczj_capture"), for: .normal)
    return button
  }()
  
  private lazy var containerImageView03: UIImageView = {
    let imageView = UIImageView(image: UIImage(named: "sczj_bg_03"))
    imageView.isUserInteractionEnabled = true
    return imageView
  }()
  
  
  private lazy var containerImageView04: UIImageView = {
    let imageView = UIImageView(image: UIImage(named: "sczj_bg_04"))
    imageView.isUserInteractionEnabled = true
    return imageView
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
    
    // Add observer
    NotificationCenter.default.addObserver(self, selector: #selector(pushToFaceRecognize), name: .pushToFaceRecognize, object: nil)
  }
  
  @objc func pushToFaceRecognize() {
    
    let vc = AuthFaceViewController(idType: self.idType!, productId: self.productId!)
    self.navigationController?.pushViewController(vc, animated: true)
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
    
    // 设置标题
    navigationBar.setTitle("Verify Identity")
    
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
    
    containerImageView02.addSubview(idBgImageView)
    idBgImageView.snp.makeConstraints { make in
      make.center.equalToSuperview()
      make.top.equalToSuperview().offset(5)
    }
    
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
    
    typeLabel.text = self.idType
    
    idImageView.addSubview(captureButton)
    captureButton.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    
    captureButton.addTarget(self, action: #selector(captureButtonDidTapped), for: .touchUpInside)
    nextStepButton.addTarget(self, action: #selector(nextStepButtonDidTapped), for: .touchUpInside)
    
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
    
    containerImageView04.addSubview(tipsLabel)
    tipsLabel.snp.makeConstraints { make in
        make.leading.equalToSuperview().offset(20)
        make.top.equalToSuperview()
        make.trailing.equalToSuperview().offset(-20)
        make.bottom.equalToSuperview().offset(-20)
    }
    
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
    let ac = UIAlertController(title: "", message: "Select Photo Or Camera", preferredStyle: .actionSheet)
    ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
    ac.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
      self.handleCamera()
    }))
    ac.addAction(UIAlertAction(title: "Photo Gallery", style: .default, handler: { _ in
      self.handlePhotoGallery()
    }))
    self.navigationController?.present(ac, animated: true)
  }
}

extension AuthVerifyIdentityViewController {
  private func handleCamera() {
    AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
      
      DispatchQueue.main.async {
        guard let self = self else { return }
        
        if granted {
            self.imagePicker.sourceType = .camera
            
            self.imagePicker.cameraDevice = .rear // Use front camera for other steps
            self.imagePicker.cameraCaptureMode = .photo
            self.imagePicker.showsCameraControls = true
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
  
  private func handlePhotoGallery() {
    PHPhotoLibrary.requestAuthorization { [weak self] status in
      
      DispatchQueue.main.async {
        guard let self = self else { return }
        
        if status == .authorized {
          self.imagePicker.sourceType = .photoLibrary
          self.present(self.imagePicker, animated: true)
        } else {
          if #available(iOS 14, *) {
            if status == .restricted || status == .denied {
              let vc = PermissionPromptAlertViewController()
              vc.modalPresentationStyle = .fullScreen
              vc.configureMessageLabel(with: "For verification purposes, please grant Moneycat access to your photo album in your device settings.")
              self.present(vc, animated: true)
            } else if status == .notDetermined {
              PHPhotoLibrary.requestAuthorization { newStatus in
                  DispatchQueue.main.async {
                      if newStatus == .authorized {
                          
                      } else {
                        let vc = PermissionPromptAlertViewController()
                        vc.modalPresentationStyle = .fullScreen
                        vc.configureMessageLabel(with: "For verification purposes, please grant Moneycat access to your photo album in your device settings.")
                        self.present(vc, animated: true)
                      }
                  }
              }
            } else {
              
            }
          } else {
            
          }
        }
      }
      
    }
  }
}

extension AuthVerifyIdentityViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
     
    picker.dismiss(animated: true) {
      guard let image = info[.originalImage] as? UIImage else { return }
      guard let compressedImageData = image.compressTo(maxSizeKB: 500) else { return }
      // 计算数据大小（单位：MB）
      let dataSizeInMB = Double(compressedImageData.count) / (1024 * 1024)
      print("Photo size: \(dataSizeInMB)")
      
      ProgressHUD.animate("Uploading...")
      let request = UploadImageModel(
        hating: self.imagePicker.sourceType == .camera ? 2 : 1,
        feud: Int(self.productId!)!,  // 使用传入的 productId
        mountainside: 11,
        couldn: compressedImageData,
        fun: self.idType!,
        kpidays: "",
        kites: String.generateUUID(),
        sleeping: "1"
      )
      
      Task {
        do {
          let response = try await CertificateService.shared.uploadImage(request)
          ProgressHUD.dismiss()
          if let uploadResponse = try? JSONDecoder().decode(UploadIDResponse.self, from: response) {
            await MainActor.run {
              let vc = ConfirmIDInfoViewController(response: uploadResponse, idType: self.idType)
              vc.modalPresentationStyle = .overFullScreen
              vc.start3 = self.start3
              vc.productid = self.productId ?? ""
              self.present(vc, animated: true)
            }
          } else {
            print("获取上传图片的 response 解码失败了")
          }
        } catch {
          ProgressHUD.error(error.localizedDescription)
          print("图片上传失败：\(error)")
        }
      }
    }
    
    
  }
}

class MyCustomImagePickerController: UIImagePickerController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        

    }
    
     func hideSwitchCameraButton(in view: UIView, delay: TimeInterval) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            self.recursiveHideSwitchCameraButton(in: view)
        }
    }

  private func recursiveHideSwitchCameraButton(in view: UIView) {
    if #available(iOS 26.0, *) {
      let screenWidth = UIScreen.main.bounds.width
      for subview in view.subviews {
        
        if NSStringFromClass(type(of: subview)) == "SwiftUI._UIInheritedView" {
          if subview.frame.minX > screenWidth * 0.5 {
            if subview.bounds.width == 48 && subview.bounds.height == 48 {
              subview.isHidden = true
              return
            }
          }
        }
        recursiveHideSwitchCameraButton(in: subview)
      }
    }else {
      for subview in view.subviews {
        
        if NSStringFromClass(type(of: subview)) == "CAMFlipButton" {
          subview.isHidden = true
          return
        }
        recursiveHideSwitchCameraButton(in: subview)
      }
    }
  }
  
  func hideCameraButton() {
    // 隐藏切换摄像头的按钮
    hideSwitchCameraButton(in: self.view, delay: 0.315)
  }
}

extension AuthVerifyIdentityViewController {
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

extension UIImage {
    /// 压缩图片至目标大小（KB），通过缩放尺寸 + JPEG压缩
    func compressTo(maxSizeKB: Int) -> Data? {
        let maxSize = maxSizeKB * 1024
        var compression: CGFloat = 1.0
        var resizedImage = self

        // 初步压缩
        guard var compressedData = resizedImage.jpegData(compressionQuality: compression) else { return nil }

        // 如果一开始就小于目标大小，直接返回
        if compressedData.count <= maxSize {
            return compressedData
        }

        // 减小尺寸：每次缩放 90%，直到小于目标 size 或宽度太小
        while compressedData.count > maxSize && resizedImage.size.width > 300 {
            let newSize = CGSize(width: resizedImage.size.width * 0.9, height: resizedImage.size.height * 0.9)
            UIGraphicsBeginImageContextWithOptions(newSize, false, resizedImage.scale)
            resizedImage.draw(in: CGRect(origin: .zero, size: newSize))
            resizedImage = UIGraphicsGetImageFromCurrentImageContext() ?? resizedImage
            UIGraphicsEndImageContext()

            if let data = resizedImage.jpegData(compressionQuality: compression) {
                compressedData = data
            }
        }

        // 最后再用二分法压缩质量
        var min: CGFloat = 0.1
        var max: CGFloat = compression
        for _ in 0..<6 {
            let mid = (min + max) / 2
            if let data = resizedImage.jpegData(compressionQuality: mid) {
                compressedData = data
                if data.count < maxSize {
                    min = mid
                } else {
                    max = mid
                }
            }
        }

        return compressedData
    }
}
