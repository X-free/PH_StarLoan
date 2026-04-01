//
//  DateSelectionViewController.swift
//  NewNewStarLoan
//
//  Created by Albert on 2025/5/7.
//
import UIKit
import SnapKit
import Foundation

class DateSelectionViewController: UIViewController {
    private var selectedDay: Int
    private var selectedMonth: Int
    private var selectedYear: Int
    private var completion: ((Int, Int, Int) -> Void)?
    
    init(day: Int, month: Int, year: Int, completion: @escaping (Int, Int, Int) -> Void) {
        self.selectedDay = day
        self.selectedMonth = month
        self.selectedYear = year
        self.completion = completion
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
  
  private lazy var backgroundView: UIView = {
      let view = UIView()
      view.backgroundColor = .black
    view.isUserInteractionEnabled = true
      return view
  }()
  
  private lazy var closeButton: UIButton = {
    let button = UIButton(type: .custom)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setImage(UIImage(named: "alert_close"), for: .normal)
    return button
  }()
  
  private lazy var confirmButton: UIButton = {
    let button = UIButton(type: .custom)
    button.setBackgroundImage(UIImage(named: "cpxq_b"), for: .normal)
    button.setTitle("Confirming", for: .normal)
    button.titleLabel?.font = .systemFont(ofSize: 16, weight: .heavy)
    button.setTitleColor(.white, for: .normal)
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
    
  private lazy var pickerView: UIPickerView = {
      let picker = UIPickerView()
      picker.delegate = self
      picker.dataSource = self
      return picker
  }()
  
  private lazy var titleLabel: UILabel = {
      let label = UILabel()
      label.text = "Date Selection"
      label.font = .systemFont(ofSize: 16, weight: .medium)
      label.textColor = UIColor(hex: "06101C")
      label.textAlignment = .center
      return label
  }()
  
  // 将固定的天数数组改为计算属性
  // 修改 days 计算属性的实现
  private var days: [Int] {
      let month = selectedMonth
      let year = selectedYear
      let daysInMonth = getDaysInMonth(month: month, year: year)
      return Array(1...daysInMonth)
  }
  
  // 修改 pickerView 的 didSelectRow 方法
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
      switch component {
      case 1: // 月份改变
          selectedMonth = months[row]
          let currentDay = selectedDay
          // 重新计算天数并更新 days 数组
          let maxDays = getDaysInMonth(month: selectedMonth, year: selectedYear)
          selectedDay = min(currentDay, maxDays)
          pickerView.reloadComponent(0)
          // 更新日期选择
          if let newDayIndex = days.firstIndex(of: selectedDay) {
              pickerView.selectRow(newDayIndex, inComponent: 0, animated: true)
          }
      case 2: // 年份改变
          selectedYear = years[row]
          // 如果是2月，需要重新计算天数（处理闰年）
          if selectedMonth == 2 {
              let currentDay = selectedDay
              let maxDays = getDaysInMonth(month: selectedMonth, year: selectedYear)
              selectedDay = min(currentDay, maxDays)
              pickerView.reloadComponent(0)
              // 更新日期选择
              if let newDayIndex = days.firstIndex(of: selectedDay) {
                  pickerView.selectRow(newDayIndex, inComponent: 0, animated: true)
              }
          }
      case 0: // 日期改变
          selectedDay = days[row]
      default:
          break
      }
  }
  // 添加计算月份天数的方法
  private func getDaysInMonth(month: Int, year: Int) -> Int {
      let calendar = Calendar.current
      let dateComponents = DateComponents(year: year, month: month)
      guard let date = calendar.date(from: dateComponents),
            let range = calendar.range(of: .day, in: .month, for: date) else {
          return 31 // 默认返回31天
      }
      return range.count
  }
  
//  // 在 UIPickerViewDelegate 扩展中添加月份或年份改变时的处理
//  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//      if component == 1 || component == 2 { // 月份或年份改变
//          let currentDay = pickerView.selectedRow(inComponent: 0) + 1
//          pickerView.reloadComponent(0) // 重新加载日期列
//          
//          // 确保选中的日期不超过当月最大天数
//          let maxDay = days.count
//          if currentDay > maxDay {
//              pickerView.selectRow(maxDay - 1, inComponent: 0, animated: true)
//          } else {
//              pickerView.selectRow(currentDay - 1, inComponent: 0, animated: false)
//          }
//      }
//  }
  private let months = Array(1...12)
  private let years = Array(1950...2025)  // 可以根据需求调整年份范围
  
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
      
      backgroundView.addSubview(closeButton)
      closeButton.snp.makeConstraints { make in
        make.bottom.equalTo(containerView.snp.top).offset(-20)
        make.trailing.equalToSuperview().offset(-20)
      }
      
      closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
      
      containerView.addSubview(confirmButton)
      confirmButton.snp.makeConstraints { make in
          make.centerX.equalToSuperview()
          make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
          make.width.equalTo(337)
          make.height.equalTo(44)
      }
      
      confirmButton.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
      containerView.addSubview(titleLabel)
      containerView.addSubview(pickerView)
      
      titleLabel.snp.makeConstraints { make in
          make.top.equalToSuperview().offset(20)
          make.centerX.equalToSuperview()
      }
      
      pickerView.snp.makeConstraints { make in
          make.top.equalTo(titleLabel.snp.bottom).offset(20)
          make.leading.trailing.equalToSuperview()
          make.bottom.equalTo(confirmButton.snp.top).offset(-20)
      }
      
      // 设置初始选中的日期
      selectInitialDate()
  }
  
  private func selectInitialDate() {
      // 找到对应的索引并滚动到指定位置
      if let dayIndex = days.firstIndex(of: selectedDay) {
          pickerView.selectRow(dayIndex, inComponent: 0, animated: false)
      }
      if let monthIndex = months.firstIndex(of: selectedMonth) {
          pickerView.selectRow(monthIndex, inComponent: 1, animated: false)
      }
      if let yearIndex = years.firstIndex(of: selectedYear) {
          pickerView.selectRow(yearIndex, inComponent: 2, animated: false)
      }
  }
  
  @objc private func closeButtonTapped() {
    dismiss(animated: true)
  }
  
  @objc func confirmButtonTapped() {
      // 获取选中的日期
      let selectedDayIndex = pickerView.selectedRow(inComponent: 0)
      let selectedMonthIndex = pickerView.selectedRow(inComponent: 1)
      let selectedYearIndex = pickerView.selectedRow(inComponent: 2)
      
      let day = days[selectedDayIndex]
      let month = months[selectedMonthIndex]
      let year = years[selectedYearIndex]
      
      // 调用回调函数
      completion?(day, month, year)
      dismiss(animated: true)
  }
}

// MARK: - UIPickerViewDelegate & DataSource
extension DateSelectionViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3  // 日、月、年三列
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0: return days.count
        case 1: return months.count
        case 2: return years.count
        default: return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0: return String(format: "%02d", days[row])
        case 1: return String(format: "%02d", months[row])
        case 2: return String(years[row])
        default: return nil
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return component == 2 ? 100 : 60  // 年份列宽一些
    }
}
