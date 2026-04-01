//
//  CustomNavigationBar.swift
//  
//
//  Created by Albert on 2025/5/6.
//

import UIKit
import SnapKit

class CustomNavigationBar: UIView {
    // 回调闭包
    var backButtonTapped: (() -> Void)?
    
    // 标题标签
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .bold)
        label.textColor = UIColor(hex: "06101C")
        label.textAlignment = .center
        return label
    }()
    
    // 返回按钮
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "return_ic"), for: .normal)
        button.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .white
        
        addSubview(titleLabel)
        addSubview(backButton)
        
        // 设置约束
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        backButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(15)
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 44, height: 44))
        }
    }
    
    @objc private func backButtonAction() {
        backButtonTapped?()
    }
    
    // 设置标题
    func setTitle(_ title: String) {
        titleLabel.text = title
    }
}
