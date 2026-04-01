//
//  ContentView.swift
//  StarLoan
//
//  Created by Albert on 2025/3/24.
//

import UIKit

class CustomTabView: UIView {
    
    enum TabItem: Int {
        case loan = 0
        case record
        case mine
        
        var normalImage: UIImage? {
            switch self {
            case .loan:
                return UIImage(named: "tab_loan_unselected")
            case .record:
                return UIImage(named: "tab_record_unselected")
            case .mine:
                return UIImage(named: "tab_mine_unselected")
            }
        }
        
        var selectedImage: UIImage? {
            switch self {
            case .loan:
                return UIImage(named: "tab_loan_selected")
            case .record:
                return UIImage(named: "tab_record_selected")
            case .mine:
                return UIImage(named: "tab_mine_selected")
            }
        }
    }
    
    private var buttons: [UIButton] = []
  private var selectedIndex: Int = 0 {
    didSet {
      buttons[oldValue].isSelected = false
      buttons[selectedIndex].isSelected = true
    }
  }
    var tabSelectedCallback: ((TabItem) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        // 设置背景
        let backgroundImageView = UIImageView(image: UIImage(named: "tab_bg"))
        backgroundImageView.frame = CGRect(x: 0, y: 0, width: 56, height: 170)  // 设置固定大小
        backgroundImageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(backgroundImageView)
        
        // 创建按钮
        let items: [TabItem] = [.loan, .record, .mine]
        let buttonHeight: CGFloat = 138/3
        let buttonWidth: CGFloat = 129/3
        let spacing: CGFloat = 8
        let topMargin: CGFloat = 8  // 第一个按钮距离顶部的边距
        
        for (index, item) in items.enumerated() {
            let button = UIButton(type: .custom)
            // 计算按钮的水平居中位置
            let centerX = (56 - buttonWidth) / 2  // 使用固定宽度 56
            // 计算按钮的垂直位置，考虑顶部边距和按钮间距
            let y = topMargin + CGFloat(index) * (buttonHeight + spacing)
            
            button.frame = CGRect(x: centerX,
                                y: y,
                                width: buttonWidth,
                                height: buttonHeight)
            button.setImage(item.normalImage, for: .normal)
            button.setImage(item.selectedImage, for: .selected)
            button.tag = index
            button.addTarget(self, action: #selector(tabButtonTapped(_:)), for: .touchUpInside)
            button.isSelected = index == selectedIndex
            
            addSubview(button)
            buttons.append(button)
        }
    }
    
    @objc private func tabButtonTapped(_ sender: UIButton) {
      guard let item = TabItem(rawValue: sender.tag) else { return }
      
      if !AuthService.isLogin() {
        if let windowScene = self.window?.windowScene,
           let sceneDelegate = windowScene.delegate as? SceneDelegate {
            
          sceneDelegate.showLoginViewController()
        }
        return
      }
      
      let value = UserDefaults.standard.integer(forKey: "needToShowCustomLocationAlert")
      if value == 1 {
        let locationService = LocationUpdateService()
        locationService.checkLocationPermission(from: nil) { grant in
          if grant {
            self.buttons[self.selectedIndex].isSelected = false
            sender.isSelected = true
            self.selectedIndex = sender.tag
            
            self.tabSelectedCallback?(item)

          } else {
            locationService.showPermissionAlert()
          }
        }

      } else {
        self.buttons[self.selectedIndex].isSelected = false
        sender.isSelected = true
        self.selectedIndex = sender.tag
        
        self.tabSelectedCallback?(item)
      }
    }
    
    func setSelectedTab(_ tab: TabItem) {
        let index = tab.rawValue
        guard index != selectedIndex else { return }
        
        buttons[selectedIndex].isSelected = false
        buttons[index].isSelected = true
        selectedIndex = index
    }
}
