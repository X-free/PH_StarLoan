//
//  CitySelectViewController.swift
//  NewNewStarLoan
//
//  Created by Albert on 2025/5/8.
//

import UIKit
import SnapKit
import Combine

// 在类定义前添加枚举
enum AddressLevel: Int {
    case region = 0
    case province = 1
    case city = 2
}

class CitySelectViewController: UIViewController {
  
  // Add publishers
  private var cancellables = Set<AnyCancellable>()
  private let selectedRegionPublisher = CurrentValueSubject<Region?, Never>(nil)
  private let selectedProvincePublisher = CurrentValueSubject<Province?, Never>(nil)
  private let selectedCityPublisher = CurrentValueSubject<City?, Never>(nil)
  
  // Update properties to use publishers
  private var selectedRegion: Region? {
    didSet { selectedRegionPublisher.send(selectedRegion) }
  }
  private var selectedProvince: Province? {
    didSet { selectedProvincePublisher.send(selectedProvince) }
  }
  private var selectedCity: City? {
    didSet { selectedCityPublisher.send(selectedCity) }
  }
  
  var onConfirm: ((Region?, Province?, City?) -> Void)?
  
  // Add properties to store initial selection
  var initialRegion: Region?
  var initialProvince: Province?
  var initialCity: City?
  
  private var addressData: AddressData? {
    didSet {
      self.tableView.reloadData()
    }
  }
  private var currentLevel: AddressLevel = .region
  // Add property to track current button
  private var currentButtonIndex: Int = 0
  
  private let buttonStackView: UIStackView = {
      let stackView = UIStackView()
      stackView.axis = .vertical
      stackView.distribution = .fillEqually
      stackView.spacing = 15
      return stackView
  }()
  
  private let seperatorLineView: UIView = {
    let view = UIView()
    view.backgroundColor = .init(hex: "F1F1F1")
    return view
  }()
  
  private let button1: UIButton = {
      let button = UIButton(type: .custom)
      button.setTitle("Choose", for: .normal)
      button.setTitleColor(UIColor(hex: "4999F7"), for: .normal)
      
      button.titleLabel?.font = .systemFont(ofSize: 13, weight: .medium)
      return button
  }()
  
  private let button2: UIButton = {
      let button = UIButton(type: .custom)
      button.setTitle("Choose", for: .normal)
      button.setTitleColor(UIColor(hex: "4999F7"), for: .normal)
      
      button.titleLabel?.font = .systemFont(ofSize: 13, weight: .medium)
      return button
  }()
  
  private let button3: UIButton = {
      let button = UIButton(type: .custom)
      button.setTitle("Choose", for: .normal)
      button.setTitleColor(UIColor(hex: "4999F7"), for: .normal)
      
      button.titleLabel?.font = .systemFont(ofSize: 13, weight: .medium)
      return button
  }()
  
  private lazy var backgroundView: UIView = {
    let view = UIView()
    view.backgroundColor = .black.withAlphaComponent(0.6)
    view.isUserInteractionEnabled = true
    return view
  }()
  
  private lazy var topImageView:UIImageView = {
    let iv = UIImageView()
    iv.image = UIImage(named: "sfxx_pu_bg")
    return iv
  }()
  
  private lazy var containerView: UIView = {
    let view = UIView()
    view.backgroundColor = .white
    view.isUserInteractionEnabled = true
    view.layer.cornerRadius = 24
    return view
  }()
  
  private lazy var closeButton: UIButton = {
    let button = UIButton(type: .custom)
    button.setImage(UIImage(named: "alert_close"), for: .normal)
    
    return button
  }()
  
  private lazy var centerLabel: UILabel = {
    let label = UILabel()
    label.textAlignment = .center
    label.textColor = .white
    label.text = "Select City"
    label.font = .systemFont(ofSize: 16, weight: .bold)
    return label
  }()
  
  private lazy var selectLabel: UILabel = {
    let label = UILabel()
    
    label.textColor = .init(hex: "06101C")
    label.text = "Please Select"
    label.font = .systemFont(ofSize: 14, weight: .medium)
    return label
  }()
  private lazy var confirmButton: UIButton = {
    let button = UIButton(type: .custom)
    button.setBackgroundImage(UIImage(named: "cpxq_b"), for: .normal)
    button.setTitle("Confirming", for: .normal)
    button.isEnabled = false
    button.alpha = 0.5
    button.titleLabel?.font = .systemFont(ofSize: 16, weight: .heavy)
    button.setTitleColor(.white, for: .normal)
    return button
  }()
  
  private let tableView: UITableView = {
      let table = UITableView()
      //        table.backgroundColor = .clear
      table.separatorStyle = .none
      table.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
      return table
  }()
  
  @objc func closeButtonTapped() {
    dismiss(animated: true)
  }
  
  fileprivate func setupUI() {
    view.backgroundColor = .clear
    view.addSubview(backgroundView)
    backgroundView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    
    view.addSubview(containerView)
    containerView.snp.makeConstraints { make in
      make.bottom.leading.trailing.equalToSuperview()
      make.height.equalTo(426)
    }
    
    view.addSubview(topImageView)
    topImageView.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.bottom.equalTo(containerView.snp.top)
    }
    
    view.addSubview(closeButton)
    closeButton.snp.makeConstraints { make in
      make.trailing.equalToSuperview().offset(-35)
      make.bottom.equalTo(topImageView.snp.top).offset(-20)
    }
    
    
    //
    topImageView.addSubview(centerLabel)
    centerLabel.snp.makeConstraints { make in
      make.center.equalToSuperview()
    }
    
    containerView.addSubview(confirmButton)
    confirmButton.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
      make.width.equalTo(337)
      make.height.equalTo(44)
    }
    
    containerView.addSubview(buttonStackView)
    buttonStackView.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(10)
      make.leading.equalToSuperview().inset(20)
      
    }
    
    [button1, button2, button3].forEach { buttonStackView.addArrangedSubview($0) }
    
    containerView.addSubview(seperatorLineView)
    seperatorLineView.snp.makeConstraints { make in
      make.height.equalTo(1)
      make.leading.trailing.equalToSuperview().inset(20)
      make.top.equalTo(buttonStackView.snp.bottom).offset(10)
    }
    
    containerView.addSubview(selectLabel)
    selectLabel.snp.makeConstraints { make in
      make.top.equalTo(seperatorLineView.snp.bottom).offset(10)
      make.leading.equalTo(seperatorLineView)
    }
    
    containerView.addSubview(tableView)
    tableView.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview()
      make.top.equalTo(selectLabel.snp.bottom).offset(10)
      make.bottom.equalTo(confirmButton.snp.top).offset(-10)
    }
    
    tableView.dataSource = self
    tableView.delegate = self
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
    
    setupUI()
    
    setupCombine()
    
    Task {
      do {
        let addressResponse = try await AddressManager.shared.getAddress()
        await MainActor.run {
          self.addressData = addressResponse.toAddressData()
        }
      }
    }
    
    closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
    confirmButton.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
    
    button1.addTarget(self, action: #selector(aButtonTapped(_:)), for: .touchUpInside)
    button2.addTarget(self, action: #selector(aButtonTapped(_:)), for: .touchUpInside)
    button3.addTarget(self, action: #selector(aButtonTapped(_:)), for: .touchUpInside)
    
    closeButton.isHidden = true
    
  }
  
  @objc private func confirmButtonTapped() {
//        onConfirm?("Metro Manila")
      onConfirm?(selectedRegion, selectedProvince, selectedCity)
    self.dismiss(animated: true)
//      SwiftMessages.hide()
  }
  
  private func setupCombine() {
      // Combine all selections to determine button state
      Publishers.CombineLatest3(selectedRegionPublisher,
                               selectedProvincePublisher,
                               selectedCityPublisher)
          .map { region, province, city in
              // Enable button only when all three are selected
              region != nil && province != nil && city != nil
          }
          .sink { [weak self] isComplete in
              self?.confirmButton.isEnabled = isComplete
              self?.confirmButton.alpha = isComplete ? 1.0 : 0.5
          }
          .store(in: &cancellables)
  }
}



struct Region: Codable {
  let whirl: Int
  let bad: String
  let dog: [Province]?
}

struct Province: Codable {
  let whirl: Int
  let bad: String
  let dog: [City]?
}

struct City: Codable {
  let whirl: Int
  let bad: String
}

struct AddressData: Codable {
  let hundred: String
  let seats: String
  let middle: [String: String?]
  let dog: [Region]
}

extension CitySelectViewController: UITableViewDataSource, UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard let data = addressData else { return 0 }
    
    switch currentLevel {
    case .region: return data.dog.count
    case .province: return selectedRegion?.dog?.count ?? 0
    case .city: return selectedProvince?.dog?.count ?? 0
    
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
      cell.backgroundColor = .clear
      cell.textLabel?.font = .systemFont(ofSize: 12, weight: .regular)
    // 默认文本颜色
    cell.textLabel?.textColor = .black
      
      switch currentLevel {
      case .region:
          cell.textLabel?.text = addressData?.dog[indexPath.row].bad
        
        if let selectedRegion = selectedRegion,
           selectedRegion.bad == addressData?.dog[indexPath.row].bad {
          cell.textLabel?.textColor = .init(hex: "4999F7")
        }
      case .province:
          cell.textLabel?.text = selectedRegion?.dog?[indexPath.row].bad
        
        if let selectedProvince = selectedProvince,
           selectedProvince.bad == selectedRegion?.dog?[indexPath.row].bad {
          cell.textLabel?.textColor = .init(hex: "4999F7")
        }
      case .city:
          cell.textLabel?.text = selectedProvince?.dog?[indexPath.row].bad
        
        if let selectedCity = selectedCity,
           selectedCity.bad == selectedProvince?.dog?[indexPath.row].bad {
          cell.textLabel?.textColor = .init(hex: "4999F7")
        }
      }
      
      
      return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      //        tableView.deselectRow(at: indexPath, animated: true)
      
      switch currentLevel {
      case .region:
          selectedRegion = addressData?.dog[indexPath.row]
          selectedProvince = nil
          selectedCity = nil
        currentLevel = .province
      case .province:
          selectedProvince = selectedRegion?.dog?[indexPath.row]
          selectedCity = nil
        currentLevel = .city
      case .city:
          selectedCity = selectedProvince?.dog?[indexPath.row]
      }
      
      updateButtons()
      tableView.reloadData()
  }
}

extension CitySelectViewController {
  private func updateButtons() {
      button1.setTitle(selectedRegion?.bad ?? "Choose", for: .normal)
      button2.setTitle(selectedProvince?.bad ?? "Choose", for: .normal)
      button3.setTitle(selectedCity?.bad ?? "Choose", for: .normal)
      
      // Update button states
      button2.isEnabled = selectedRegion != nil
      button3.isEnabled = selectedProvince != nil
      
      // Set button colors based on enabled state
      button2.setTitleColor(button2.isEnabled ? .init(hex: "4999F7") : .gray, for: .normal)
      button3.setTitleColor(button3.isEnabled ? .init(hex: "4999F7") : .gray, for: .normal)
  }
  
  @objc private func aButtonTapped(_ sender: UIButton) {
      guard let index = [button1, button2, button3].firstIndex(of: sender) else { return }
      
      // Check if button is enabled
      if index == 1 && !button2.isEnabled { return }
      if index == 2 && !button3.isEnabled { return }
      
    // 使用 AddressLevel 枚举
      currentLevel = AddressLevel(rawValue: index) ?? .region
      currentButtonIndex = index
      
      tableView.reloadData()
      scrollToSelectedRow()
  }
  
  private func scrollToSelectedRow() {
      var indexPath: IndexPath?
      switch currentLevel {
      case .region:
          if let selectedRegion = selectedRegion,
             let index = addressData?.dog.firstIndex(where: { $0.bad == selectedRegion.bad }) {
              indexPath = IndexPath(row: index, section: 0)
          }
      case .province:
          if let selectedProvince = selectedProvince,
             let provinces = selectedRegion?.dog,
             let index = provinces.firstIndex(where: { $0.bad == selectedProvince.bad }) {
              indexPath = IndexPath(row: index, section: 0)
          }
      case .city:
          if let selectedCity = selectedCity,
             let cities = selectedProvince?.dog,
             let index = cities.firstIndex(where: { $0.bad == selectedCity.bad }) {
              indexPath = IndexPath(row: index, section: 0)
          }
      }
      
      if let indexPath = indexPath {
          DispatchQueue.main.async {
              self.tableView.scrollToRow(at: indexPath, at: .middle, animated: true)
          }
      }
  }
  
  // Add setup method for initial values
  func setupInitialSelection(region: Region?, province: Province?, city: City?) {
      self.initialRegion = region
      self.initialProvince = province
      self.initialCity = city
      
      // Set initial selection
      self.selectedRegion = region
      self.selectedProvince = province
      self.selectedCity = city
      
      // Update UI
      updateButtons()
      DispatchQueue.main.async { [weak self] in
          self?.tableView.reloadData()
          self?.scrollToSelectedRow()
      }
  }
}
