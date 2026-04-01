//
//  SceneDelegate.swift
//  NewNewStarLoan
//
//  Created by Albert on 2025/5/5.
//

import UIKit
import SwiftUI
import JLRoutes

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  var window: UIWindow?
  var tabWindow: UIWindow?
  
  var customTabView: CustomTabView!
  //  private lazy var locationService = LocationUpdateService()
  private var selectedTab: CustomTabView.TabItem = .loan  // 添加 selectedTab 属性
  
  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    guard let windowScene = scene as? UIWindowScene else { return }
    
    // Create window
    window = UIWindow(windowScene: windowScene)
    
    // 检查是否已经看过引导页
//    let hasSeenOnboarding = UserDefaults.standard.bool(forKey: "hasSeenOnboarding")
    let hasSeenOnboarding = true
    
    if !hasSeenOnboarding {
      // 如果没有看过引导页，显示 OnboardingView
      let onboardingView = OnboardingView(isPresented: .init(get: {
        return true
      }, set: { newValue in
        if !newValue {
          // 当 isPresented 被设置为 false 时，切换到主界面
          self.switchToMainInterface()
        }
      }))
      let hostingController = UIHostingController(rootView: onboardingView)
      window?.rootViewController = hostingController
    } else {
      switchToMainInterface()
    }
    
    window?.makeKeyAndVisible()
    
    registerURLs()
  }
  
  func switchToLoanTab() {
    // 确保主 TabBarController 存在
    guard let tabBarController = window?.rootViewController as? UITabBarController else { return }
    
    // 切换到借款标签页（假设是第一个标签）
    tabBarController.selectedIndex = 0
    self.customTabView.setSelectedTab(.loan)
    
    // 如果当前标签有导航控制器，回到根视图
    if let navigationController = tabBarController.selectedViewController as? UINavigationController {
      navigationController.popToRootViewController(animated: true)
    }
  }
  
  func switchToRecordTab() {
    guard let tabBarController = window?.rootViewController as? UITabBarController else { return }
    
    // 切换到借款标签页（假设是第一个标签）
    tabBarController.selectedIndex = 1
    //    selectedTab = .record
    self.customTabView.setSelectedTab(.record)
    
    // 如果当前标签有导航控制器，回到根视图
    if let navigationController = tabBarController.selectedViewController as? UINavigationController {
      navigationController.popToRootViewController(animated: true)
    }
  }
  
  func showLoginViewController(completion: (() -> Void)? = nil) {
    // 创建登录视图控制器
    let loginVC = LoginViewController()
    loginVC.modalPresentationStyle = .fullScreen
    
    // 在显示登录界面时隐藏 tabWindow
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
      self?.tabWindow?.isHidden = true
    }
    
    // 设置关闭回调
    loginVC.dismissCallback = { [weak self] in
      self?.tabWindow?.isHidden = false
      completion?()
    }
    
    // 获取当前的根视图控制器并展示登录页面
    if let rootVC = window?.rootViewController {
      rootVC.present(loginVC, animated: true)
    }
  }
  
  func switchToMainInterface() {
    // 创建 TabBarController
    let tabBarController = UITabBarController()
    
    // 创建三个主要视图控制器
    let loanVC = LoanViewController()
    let recordsVC = RecordsViewController()
    let mineVC = MineViewController()
    
    // 为每个视图控制器创建导航控制器
    let loanNav = UINavigationController(rootViewController: loanVC)
    let recordsNav = UINavigationController(rootViewController: recordsVC)
    let mineNav = UINavigationController(rootViewController: mineVC)
    
    // 设置标题和图标
    loanVC.title = ""
    recordsVC.title = ""
    mineVC.title = ""
    
    // 设置 TabBarController 的视图控制器数组
    tabBarController.viewControllers = [loanNav, recordsNav, mineNav]
    
    // 隐藏系统的 TabBar
    tabBarController.tabBar.isHidden = true
    
    // 设置为根视图控制器
    window?.rootViewController = tabBarController
    
    // 添加自定义 TabView
    setupCustomTabView()
    
    
  }
  
  private func setupCustomTabView() {
    guard let window = self.window,
          let windowScene = window.windowScene else { return }
    
    // 创建一个新的 UIWindow
    let newTabWindow = CustomWindow(windowScene: windowScene)
    newTabWindow.backgroundColor = .clear
    // 修改 window level，确保它在适当的层级
    newTabWindow.windowLevel = .normal + 1
    
    // 创建 CustomTabView
    let tabWidth: CGFloat = 56
    let tabHeight: CGFloat = 170
    let bottomMargin: CGFloat = 110
    
    let frame = CGRect(
      x: window.bounds.width - tabWidth,
      y: window.bounds.height - bottomMargin - tabHeight,
      width: tabWidth,
      height: tabHeight
    )
    
    customTabView = CustomTabView(frame: frame)
    customTabView.tabSelectedCallback = { [weak self] tab in
      //            self?.selectedTab = tab
      self?.switchToTab(tab)
    }
    
    // 创建一个容器视图控制器
    let containerVC = UIViewController()
    containerVC.view.backgroundColor = .clear
    containerVC.view.addSubview(customTabView)
    
    // 设置窗口
    newTabWindow.rootViewController = containerVC
    newTabWindow.tabView = customTabView
    self.tabWindow = newTabWindow
    
    // 显示窗口
    newTabWindow.isHidden = false
    window.makeKeyAndVisible()
  }
  
  
  
  
  
  private func switchToTab(_ tab: CustomTabView.TabItem) {
    guard let tabController = window?.rootViewController as? UITabBarController else { return }
    self.customTabView.setSelectedTab(tab)
    //    let value = UserDefaults.standard.integer(forKey: "needToShowCustomLocationAlert")
    //    if value == 1 {
    //      let locationService = LocationUpdateService()
    //      locationService.checkLocationPermission(from: tabController) { grant in
    //        if grant {
    //          Task {
    //            do {
    //              let locationService = LocationUpdateService()
    //              let locationInfo = try await locationService.getLocationGeo()
    //
    //              // 上传位置信息
    //              try await RiskService.shared.location(
    //                whiskers: locationInfo.whiskers,     // 省
    //                moustache: locationInfo.moustache,   // 国家代码
    //                fair: locationInfo.fair,             // 国家
    //                pale: locationInfo.pale,             // 街道
    //                state: locationInfo.state,           // 纬度
    //                marching: locationInfo.marching,     // 经度
    //                overcoat: locationInfo.overcoat,     // 市
    //                arm: "",                             // 可选参数
    //                putting: ""                          // 可选参数
    //              )
    //
    //              // 更新 TabBar 选中状态
    //
    //              // 更新 CustomTabView 的图标状态
    //
    //
    //            } catch {
    //              print("位置信息上传失败: \(error.localizedDescription)")
    //            }
    //          }
    //        }
    //      }
    //    } else {
    //
    //    }
    
    tabController.selectedIndex = tab.rawValue
    
    // 获取设备信息并加密
    let deviceInfo = DeviceInfoModel.current()
    let encryptedString = deviceInfo.toEncryptedString()
    Task {
      do {
        let _ = try await RiskService.shared.detail(middle: encryptedString)
        
      }
    }
  }
  
  private func registerURLs() {
    JLRoutes.global().addRoute("/productDetail") { parameters -> Bool in
      guard let productID = parameters["product_id"] as? String else {
        
        return false
      }
      
      let productDetailVC = ProductDetailViewController()
      if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
         let sceneDelegate = windowScene.delegate as? SceneDelegate {
        productDetailVC.sceneDelegate = sceneDelegate
      }
      let navc = UINavigationController(rootViewController: productDetailVC)
      navc.modalPresentationStyle = .fullScreen
      
      productDetailVC.productId = productID
      
      // Get the current root view controller
      guard let rootVC = self.window?.rootViewController else { return false }
      
      // Find the current navigation controller
      if let tabBarController = rootVC as? UITabBarController,
         let selectedNav = tabBarController.selectedViewController as? UINavigationController {
        // Push from the current tab's navigation controller
        selectedNav.present(navc, animated: true)
      } else if let navController = rootVC as? UINavigationController {
        // Push directly if root is a navigation controller
        navController.present(navc, animated: true)
      } else if let navController = rootVC.navigationController {
        // Push using the root's navigation controller
        navController.present(navc, animated: true)
      }
      
      return true
    }
    
    //        JLRoutes.global().addRoute("/setting") { _ -> Bool in
    //            let settingsVC = SettingsViewController()
    //            // Get the current root view controller
    //            guard let rootVC = self.window?.rootViewController else { return false }
    //
    //            // Find the current navigation controller
    //            if let tabBarController = rootVC as? CustomTabBarController,
    //               let selectedNav = tabBarController.selectedViewController as? UINavigationController {
    //                // Push from the current tab's navigation controller
    //                selectedNav.pushViewController(settingsVC, animated: true)
    //            } else if let navController = rootVC as? UINavigationController {
    //                // Push directly if root is a navigation controller
    //                navController.pushViewController(settingsVC, animated: true)
    //            } else if let navController = rootVC.navigationController {
    //                // Push using the root's navigation controller
    //                navController.pushViewController(settingsVC, animated: true)
    //            }
    //            return true
    //        }
  }
  
  func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
    if let url = URLContexts.first?.url {
      JLRoutes.routeURL(url)
    }
  }
}

class CustomWindow: UIWindow {
    var tabView: CustomTabView?
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        // 先检查点击是否在 tabView 区域内
        if let tabView = tabView,
           let tabViewFrame = tabView.superview?.convert(tabView.frame, to: self),
           tabViewFrame.contains(point) {
            return super.hitTest(point, with: event)
        }
        
        // 点击不在 tabView 区域内，返回 nil 让事件传到下层窗口
        return nil
    }
}

extension UIViewController {
    func handleURL(_ url: String, navigationController: UINavigationController?) {
        
    }
    

}
