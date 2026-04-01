//
//  MyWebViewController.swift
//  NewNewStarLoan
//
//  Created by Albert on 2025/5/11.
//

import UIKit
import WebKit
import StoreKit
import AdSupport

enum WebMessageHandler: String {
  case cakeJelly = "cakeJelly"
  case sunflower = "sunflower"
  case arbitrar = "arbitrar"
  case ryeBoxwoo = "ryeBoxwoo"
  case teaJellyf = "teaJellyf"
  case sataySheo = "sataySheo"
  
  static var allHandlers: [WebMessageHandler] {
    return [.cakeJelly, .sunflower, .arbitrar, .ryeBoxwoo, .teaJellyf, .sataySheo]
  }
}

class MyWebViewController: UIViewController {
  // MARK: - Properties
  private var urlString: String
  

  
  // Add progress view property
  private let progressView: UIProgressView = {
    let progress = UIProgressView(progressViewStyle: .default)
    progress.progressTintColor = UIColor(hex: "4999F7")
    progress.trackTintColor = UIColor.lightGray
    return progress
  }()
  
  private lazy var webView: WKWebView = {
    // Create webpage preferences
    let preferences = WKWebpagePreferences()
    
    if #available(iOS 14.0, *) {
      preferences.allowsContentJavaScript = true
    } else {
      webView.configuration.preferences.javaScriptEnabled = true
    }
    
    let contentController = WKUserContentController()
    // 使用枚举添加消息处理器
    WebMessageHandler.allHandlers.forEach { handler in
      contentController.add(self, name: handler.rawValue)
    }
    
    let config = WKWebViewConfiguration()
    config.userContentController = contentController
    config.defaultWebpagePreferences = preferences
    
    let webView = WKWebView(frame: .zero, configuration: config)
    webView.navigationDelegate = self
    webView.translatesAutoresizingMaskIntoConstraints = false
    
    webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
    return webView
  }()
  
  // MARK: - Initialization
  init(urlString: String) {
    self.urlString = urlString
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    loadWebContent()
    
    // Show navigation bar
    navigationController?.setNavigationBarHidden(false, animated: false)
    
    // Configure navigation bar appearance with transparent background
    let appearance = UINavigationBarAppearance()
    appearance.configureWithTransparentBackground()
    navigationController?.navigationBar.standardAppearance = appearance
    navigationController?.navigationBar.scrollEdgeAppearance = appearance
    navigationController?.navigationBar.compactAppearance = appearance
    
    // Ensure navigation bar remains transparent
    navigationController?.navigationBar.isTranslucent = true
    navigationController?.navigationBar.backgroundColor = .clear
    navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    navigationController?.navigationBar.shadowImage = UIImage()
    
    // Add progress view below navigation bar
    view.addSubview(progressView)
    progressView.snp.makeConstraints { make in
      make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
      make.leading.trailing.equalToSuperview()
      make.height.equalTo(2)
    }
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      // 隐藏 tabWindow
    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
       let sceneDelegate = windowScene.delegate as? SceneDelegate {
      sceneDelegate.tabWindow?.isHidden = true
    }
  }
  // Add progress observation method
  override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
    if keyPath == "estimatedProgress" {
      progressView.progress = Float(webView.estimatedProgress)
      progressView.isHidden = progressView.progress == 1
    }
  }
  
  // MARK: - UI Setup
  private func setupUI() {
    view.backgroundColor = .white
    
    // Configure navigation bar
    if #available(iOS 14.0, *) {
      navigationItem.backButtonDisplayMode = .minimal
    } else {
      navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    let backButton = UIBarButtonItem(image: UIImage(named: "return_ic")?.withRenderingMode(.alwaysOriginal),
                                     style: .plain,
                                     target: self,
                                     action: #selector(backButtonTapped))
    navigationItem.leftBarButtonItem = backButton
    
    // Add webView
    view.addSubview(webView)
    webView.snp.makeConstraints { make in
      make.edges.equalTo(view.safeAreaLayoutGuide)
    }
  }
  
  // MARK: - Actions
  @objc private func backButtonTapped() {
    if webView.canGoBack {
      webView.goBack()
    } else {
      
      dismiss(animated: true)
    }
  }
  
  
  private func loadWebContent() {
    guard let encodedString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
          let url = URL(string: encodedString) else {
      
      return
    }
    let request = URLRequest(url: url)
    webView.load(request)
  }
}

// MARK: - WKNavigationDelegate
extension MyWebViewController: WKNavigationDelegate {
  func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    title = webView.title
  }
  
  func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
    
  }
  
  
  func abscs(productId: String, orderNo: String) {
    let end10 = Int(Date().timeIntervalSince1970)
    MaidianRistManager.manager.upload(foreground: productId, hammersmith: "10", welcome: "\(end10)", deal: "\(end10)")
  }
}

extension MyWebViewController: WKScriptMessageHandler {
  func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
    
    
    // 使用枚举处理消息
    guard let handler = WebMessageHandler(rawValue: message.name) else { return }
    
    switch handler {
    case .cakeJelly:
      if let params = message.body as? [String] {
        guard params.count >= 2 else { return }
        let productId = params[0]
        let orderNo = params[1]
        
        self.abscs(productId: productId, orderNo: orderNo)
      }
      
    case .sunflower:
      if let url = message.body as? String {
        if url.hasPrefix("http") {
          dismiss(animated: true) {
            let urlWithParams = self.appendCommonParams(to: url)
            self.navigateToWebView(with: urlWithParams)
          }
        } else {
          self.handleDeobfuscatedURL(url)
        }
      }
      
      break
    case .arbitrar:
      dismiss(animated: true)
    case .ryeBoxwoo:
      // 回到 app 首页
      dismiss(animated: true) {
        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
          sceneDelegate.switchToLoanTab()
        }

      }
      break
    case .teaJellyf:
      if let string = message.body as? String {
        if string.hasPrefix("email:") {
            // Handle email
            let email = String(string.dropFirst(6))
            openEmail(with: email)
        } else if string.hasPrefix("tel:") {
            // Handle phone call
            let phoneNumber = String(string.dropFirst(4))
            if let url = URL(string: "tel:\(phoneNumber)") {
                UIApplication.shared.open(url)
            }
        }
      }
    case .sataySheo:
      if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
          if #available(iOS 14.0, *) {
              SKStoreReviewController.requestReview(in: scene)
          } else {
              SKStoreReviewController.requestReview()
          }
      }
    }
  }
  
  func openEmail(with email: String) {
     
    if let phoneNumber = UserDefaults.standard.object(forKey: "phoneNumber") {
      // 构建邮件内容
      let subject = "Moneycat Support" // 邮件主题
      let body = "App: Moneycat\nPhone Number: \(phoneNumber)" // 邮件内容

      // 将主题和内容进行 URL 编码
      let encodedSubject = subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
      let encodedBody = body.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""

      // 构建完整的 mailto URL
      let mailtoString = "mailto:\(email)?subject=\(encodedSubject)&body=\(encodedBody)"

      if let mailtoUrl = URL(string: mailtoString) {
          if UIApplication.shared.canOpenURL(mailtoUrl) {
              UIApplication.shared.open(mailtoUrl)
          }
      }
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
          "boyfine": String.generateUUID()
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
    print("self == \(self)")
    let arr = url.components(separatedBy: "feud=")
    let pro = arr.last ?? ""
    let vc = ProductDetailViewController()
    vc.productId = pro
    
    let navc = UINavigationController(rootViewController: vc)
    navc.modalPresentationStyle = .fullScreen
    self.present(navc, animated: true)
  }

}
