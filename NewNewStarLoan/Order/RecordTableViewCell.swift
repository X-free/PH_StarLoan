//
//  RecordTableViewCell.swift
//  NewNewStarLoan
//
//  Created by Albert on 2025/5/11.
//
import UIKit
import Foundation
import SnapKit

class RecordTableViewCell: UITableViewCell {
  static let cellIdentifier = "RecordTableViewCell"
  
  private lazy var containerView: UIView = {
    let view = UIView()
    view.backgroundColor = .clear
    return view
  }()
  
  private lazy var backgroundImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFill
    return imageView
  }()
  
  private lazy var statusLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 14, weight: .medium)
    label.textColor = .white
    label.textAlignment = .center
    return label
  }()
  
  private lazy var logoImageView: UIImageView = {
    let imageView = UIImageView(image: UIImage(named: "order_logo"))
    imageView.contentMode = .scaleAspectFit
    return imageView
  }()
  
  private lazy var productLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 14, weight: .heavy)
    label.textColor = UIColor(hex: "06101C")
    return label
  }()
  
  private lazy var amountLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 24, weight: .heavy)
    label.textColor = UIColor(hex: "06101C")
    return label
  }()
  
  private lazy var amountTitleLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 12)
    label.textColor = UIColor(hex: "6C6C6C")
    label.text = "Loan amount"
    return label
  }()
  
  private lazy var dateLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 14, weight: .bold)
    label.textColor = UIColor(hex: "06101C")
    return label
  }()
  
  private lazy var dateTitleLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 12)
    label.textColor = UIColor(hex: "6C6C6C")
    label.text = "Repayment date"
    return label
  }()
  
  private lazy var actionButton: UIButton = {
    let button = UIButton(type: .custom)
    button.setBackgroundImage(UIImage(named: "alert_destrutive"), for: .normal)
    button.titleLabel?.font = .systemFont(ofSize: 12, weight: .heavy)
    button.setTitleColor(.white, for: .normal)
    button.isHidden = true
    return button
  }()
  
  private lazy var warningContainer: UIStackView = {
    let stack = UIStackView()
    stack.axis = .horizontal
    stack.spacing = 4
    stack.alignment = .center
    stack.isHidden = true
    return stack
  }()
  
  private lazy var warningIcon: UIImageView = {
    let imageView = UIImageView(image: UIImage(named: "order_ic"))
    imageView.contentMode = .scaleAspectFit
    return imageView
  }()
  
  private lazy var warningLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 12)
    label.textColor = UIColor(hex: "EB612C")
    label.numberOfLines = 0
    return label
  }()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  
  private func setupUI() {
    contentView.backgroundColor = .clear
    selectionStyle = .none
    
    contentView.addSubview(containerView)
    containerView.snp.makeConstraints { make in
      make.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15))
    }
    
    containerView.addSubview(backgroundImageView)
    backgroundImageView.snp.makeConstraints { make in
      //      make.edges.equalToSuperview()
      make.top.equalToSuperview().offset(15)
      make.leading.trailing.equalToSuperview()
    }
    
    // 添加状态标签
    backgroundImageView.addSubview(statusLabel)
    statusLabel.snp.makeConstraints { make in
      make.leading.equalToSuperview()
      make.top.equalToSuperview()
      make.width.equalTo(100 * UIScreen.main.bounds.width/375)
    }
    
    // 添加logo区域
    let logoStack = UIStackView(arrangedSubviews: [logoImageView, productLabel])
    logoStack.spacing = 4
    logoStack.alignment = .center
    
    backgroundImageView.addSubview(logoStack)
    logoStack.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(7 * UIScreen.main.bounds.width/375)
      make.trailing.equalToSuperview().offset(-20)
    }
    
    logoImageView.snp.makeConstraints { make in
      make.size.equalTo(CGSize(width: 24, height: 24))
    }
    
    // 添加金额区域
    let amountStack = UIStackView(arrangedSubviews: [amountLabel, amountTitleLabel])
    amountStack.axis = .vertical
    amountStack.spacing = 5
    amountStack.alignment = .center
    
    backgroundImageView.addSubview(amountStack)
    amountStack.snp.makeConstraints { make in
      make.leading.equalToSuperview().offset(10)
      make.top.equalTo(statusLabel.snp.bottom).offset(15 * UIScreen.main.bounds.width/375)
      make.width.equalToSuperview().multipliedBy(0.5).offset(-20)
    }
    
    // 添加日期区域
    let dateStack = UIStackView(arrangedSubviews: [dateLabel, dateTitleLabel])
    dateStack.axis = .vertical
    dateStack.spacing = 10
    dateStack.alignment = .leading
    
    backgroundImageView.addSubview(dateStack)
    dateStack.snp.makeConstraints { make in
      make.leading.equalTo(amountStack.snp.trailing).offset(10)
      make.bottom.equalTo(amountStack)
      make.trailing.equalToSuperview().offset(-15)
    }
    
    // 添加操作按钮
    backgroundImageView.addSubview(actionButton)
    actionButton.snp.makeConstraints { make in
      make.leading.equalToSuperview().offset(24 * UIScreen.main.bounds.width/375)
      make.bottom.equalToSuperview().offset(-15 * UIScreen.main.bounds.width/375)
      make.width.equalTo(106)
      make.height.equalTo(34)
    }
    
    // 添加警告信息
    warningContainer.addArrangedSubview(warningIcon)
    warningContainer.addArrangedSubview(warningLabel)
    
    contentView.addSubview(warningContainer)
    // 修改警告信息的约束
    warningContainer.snp.makeConstraints { make in
//      make.top.equalTo(backgroundImageView.snp.bottom).offset(6)
      make.leading.trailing.equalToSuperview().inset(20)
      make.bottom.equalToSuperview().offset(-8)
    }
    
    warningIcon.snp.makeConstraints { make in
      make.size.equalTo(CGSize(width: 12, height: 12))
      //      make.bottom.equalToSuperview().offset(-8)
    }
  }
  
  func configure(with item: OrderItem) {
    // 设置背景图片
    backgroundImageView.image = UIImage(named: getBackgroundImage(heartily: item.liveries.heartily))
    
    // 设置状态
    statusLabel.text = item.liveries.dreams
    
    // 设置产品信息
    productLabel.text = item.liveries.cratered
    
    // 设置金额
    amountLabel.text = item.liveries.few
    
    // 设置日期
    dateLabel.text = item.liveries.enjoyed
    dateTitleLabel.text = item.liveries.sight
    
    // 设置按钮
    if !item.liveries.wise.isEmpty {
      actionButton.isHidden = false
      actionButton.setTitle(item.liveries.wise, for: .normal)
    } else {
      actionButton.isHidden = true
    }
    
    // 设置警告信息
    if !item.liveries.shoulder.isEmpty {
      warningContainer.isHidden = false
      warningLabel.text = item.liveries.shoulder
    } else {
      warningContainer.isHidden = true
    }
  }
  
  private func getBackgroundImage(heartily: Int) -> String {
    switch heartily {
    case 1: return "dd_delay_bg"    // 逾期
    case 2: return "dd_repay_bg"    // 还款中
    case 3: return "dd_apply_bg"    // 未申请
    case 4: return "dd_review_bg"   // 审核中
    case 5: return "dd_finish_bg"   // 已完成
    default: return "dd_apply_bg"
    }
  }
}

class NewRecordTableViewCell: UITableViewCell {
  static let cellIdentifier = "NewRecordTableViewCell"
  
  private lazy var warningContainer: UIStackView = {
      let stack = UIStackView()
      stack.axis = .horizontal
      stack.spacing = 4
      stack.alignment = .center
      stack.isHidden = true
      return stack
  }()
  
  private lazy var warningIcon: UIImageView = {
      let imageView = UIImageView(image: UIImage(named: "order_ic"))
      imageView.contentMode = .scaleAspectFit
      return imageView
  }()
  
  private lazy var warningLabel: UILabel = {
      let label = UILabel()
      label.font = .systemFont(ofSize: 12)
      label.textColor = UIColor(hex: "EB612C")
      label.numberOfLines = 0
      return label
  }()
  
  private lazy var backgroundImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFit
    return imageView
  }()
  
  private lazy var logoImageView: UIImageView = {
    let imageView = UIImageView(image: UIImage(named: "order_logo"))
    imageView.contentMode = .scaleAspectFit
    return imageView
  }()
  
  private lazy var productLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 14, weight: .heavy)
    label.text = "Moneycat"
    label.textColor = UIColor(hex: "06101C")
    return label
  }()
  
  private lazy var amountLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 24, weight: .heavy)
    label.textColor = UIColor(hex: "06101C")
    return label
  }()
  
  private lazy var amountTitleLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 12)
    label.textColor = UIColor(hex: "6C6C6C")
    label.text = "Loan amount"
    return label
  }()
  
  private lazy var dateLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 14, weight: .bold)
    label.textColor = UIColor(hex: "06101C")
    return label
  }()
  
  private lazy var dateTitleLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 12)
    label.textColor = UIColor(hex: "6C6C6C")
    label.text = "Repayment date"
    return label
  }()
  
  private lazy var actionButton: UIButton = {
    let button = UIButton(type: .custom)
    button.setBackgroundImage(UIImage(named: "alert_destrutive"), for: .normal)
    button.titleLabel?.font = .systemFont(ofSize: 12, weight: .heavy)
    button.setTitleColor(.white, for: .normal)
    button.isHidden = true
    return button
  }()
  
  private func setupUI() {
    contentView.backgroundColor = .clear
    selectionStyle = .none
    
    contentView.addSubview(backgroundImageView)
    // 基础约束，包括初始的高度约束
    backgroundImageView.snp.makeConstraints { make in
//      make.centerX.equalToSuperview()
      make.leading.trailing.equalToSuperview().inset(15)
      make.top.equalToSuperview().offset(10)
      make.height.equalTo(backgroundImageView.snp.width).multipliedBy(438.0/945.0) // 设置默认高度比例
      make.bottom.lessThanOrEqualToSuperview().offset(-20)
    }
    
    // 添加logo区域
    let logoStack = UIStackView(arrangedSubviews: [logoImageView, productLabel])
    logoStack.spacing = 4
    logoStack.alignment = .center
    
    backgroundImageView.addSubview(logoStack)
    logoStack.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(7 * UIScreen.main.bounds.width/375)
      make.trailing.equalToSuperview().offset(-20)
    }
    
    logoImageView.snp.makeConstraints { make in
      make.size.equalTo(CGSize(width: 24, height: 24))
    }
    
    // 添加金额区域
    let amountStack = UIStackView(arrangedSubviews: [amountLabel, amountTitleLabel])
    amountStack.axis = .vertical
    amountStack.spacing = 5
    amountStack.alignment = .leading
    
    backgroundImageView.addSubview(amountStack)
    amountStack.snp.makeConstraints { make in
      make.leading.equalToSuperview().offset(24)
      make.top.equalTo(logoStack.snp.bottom).offset(15 * UIScreen.main.bounds.width/375)
      make.width.equalToSuperview().multipliedBy(0.5).offset(-20)
    }
    
    // 添加日期区域
    let dateStack = UIStackView(arrangedSubviews: [dateLabel, dateTitleLabel])
    dateStack.axis = .vertical
    dateStack.spacing = 5
    dateStack.alignment = .leading
    
    backgroundImageView.addSubview(dateStack)
    dateStack.snp.makeConstraints { make in
      make.leading.equalTo(amountStack.snp.trailing).offset(10)
      make.bottom.equalTo(amountStack)
      make.trailing.equalToSuperview().offset(-15)
    }
    
    // 添加操作按钮
    backgroundImageView.addSubview(actionButton)
    actionButton.snp.makeConstraints { make in
        make.leading.equalToSuperview().offset(24 * UIScreen.main.bounds.width/375)
        make.bottom.equalToSuperview().offset(-15 * UIScreen.main.bounds.width/375)
        make.width.equalTo(106)
        make.height.equalTo(34)
    }
    
    // 添加警告信息
    warningContainer.addArrangedSubview(warningIcon)
    warningContainer.addArrangedSubview(warningLabel)
    
    contentView.addSubview(warningContainer)
    warningContainer.snp.makeConstraints { make in
        make.top.equalTo(backgroundImageView.snp.bottom).offset(6)
        make.leading.trailing.equalToSuperview().inset(20)
//        make.bottom.lessThanOrEqualToSuperview().offset(-8)
    }
    
    warningIcon.snp.makeConstraints { make in
        make.size.equalTo(CGSize(width: 12, height: 12))
    }
  }
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func configure(with item: OrderItem) {
    // 设置背景图片
    backgroundImageView.image = UIImage(named: getBackgroundImage(heartily: item.liveries.heartily))
    
    // 根据不同状态设置不同的高度约束
    let isLargeImage = [1, 2, 3].contains(item.liveries.heartily) // delay、repayment、apply 状态
    
    // 重新设置约束，而不是更新
    backgroundImageView.snp.remakeConstraints { make in
      make.centerX.equalToSuperview()
      make.leading.trailing.equalToSuperview().inset(15)
      make.top.equalToSuperview().offset(20)
      if isLargeImage {
        // 945:438 的比例
        make.height.equalTo(backgroundImageView.snp.width).multipliedBy(438.0/945.0)
      } else {
        // 945:318 的比例
        make.height.equalTo(backgroundImageView.snp.width).multipliedBy(318.0/945.0)
      }
      make.bottom.lessThanOrEqualToSuperview().offset(-20)
    }
    
    
    // 设置金额
    amountLabel.text = item.liveries.few
    
    // 设置日期
    dateLabel.text = item.liveries.enjoyed
    dateTitleLabel.text = item.liveries.sight
    
    productLabel.text = item.cratered
    logoImageView.kf.setImage(with: URL(string: item.watched), placeholder: UIImage(named: "order_logo"))
    
    // 根据状态设置按钮标题和日期标签文本
    if [1, 2].contains(item.liveries.heartily) { // delay 和 repayment 状态
        actionButton.isHidden = false
        actionButton.setTitle("Repayment", for: .normal)
        dateTitleLabel.text = "Repayment date"
    } else if item.liveries.heartily == 3 { // apply 状态
        actionButton.isHidden = false
        actionButton.setTitle("Go Apply", for: .normal)
        dateTitleLabel.text = "Borrowing date"
    } else {
        actionButton.isHidden = true
    }
    
    // 设置警告信息
    if !item.liveries.shoulder.isEmpty {
        warningContainer.isHidden = false
        warningLabel.text = item.liveries.shoulder
    } else {
        warningContainer.isHidden = true
    }
  }
  
  private func getBackgroundImage(heartily: Int) -> String {
    switch heartily {
    case 1: return "dd_delay_bg"    // 逾期
    case 2: return "dd_repay_bg"    // 还款中
    case 3: return "dd_apply_bg"    // 未申请
    case 4: return "dd_review_bg"   // 审核中
    case 5: return "dd_finish_bg"   // 已完成
    default: return "dd_apply_bg"
    }
  }
  
  
}
