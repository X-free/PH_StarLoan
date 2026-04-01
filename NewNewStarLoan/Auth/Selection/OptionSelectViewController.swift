import UIKit
import SnapKit
import Combine
import Kingfisher

struct OptionsModel {
  let title: String
  let imageUrl: String
  let value: String
}

class OptionSelectViewController: UIViewController {
  private var cancellables = Set<AnyCancellable>()
  private let selectedOptionPublisher = CurrentValueSubject<OptionsModel?, Never>(nil)
  
  // MARK: - Properties
  var onConfirm: ((OptionsModel) -> Void)?
  private var selectModels: [OptionsModel] = []
  var initialOption: OptionsModel?
  
  private var selectedOption: OptionsModel? {
    didSet {
      selectedOptionPublisher.send(selectedOption)
    }
  }
  
  // Add activity indicator property
  private lazy var iconActivityIndicator: UIActivityIndicatorView = {
      let indicator = UIActivityIndicatorView(style: .medium)
      indicator.hidesWhenStopped = true
      return indicator
  }()
  
  private func setupCombine() {
    selectedOptionPublisher
      .map { option -> Bool in
        // Enable button only when an option is selected
        return option != nil
      }
      .sink { [weak self] isSelected in
        self?.confirmButton.isEnabled = isSelected
        self?.confirmButton.alpha = isSelected ? 1.0 : 0.5
      }
      .store(in: &cancellables)
  }
  
  private lazy var backgroundView: UIView = {
    let view = UIView()
    view.backgroundColor = .black.withAlphaComponent(0.6)
    view.isUserInteractionEnabled = true
    return view
  }()
  
  private lazy var containerView: UIView = {
    let view = UIView()
    view.backgroundColor = .white
    view.layer.cornerRadius = 24
    return view
  }()
  
  private lazy var topImageView:UIImageView = {
    let iv = UIImageView()
    iv.image = UIImage(named: "sfxx_pu_bg")
    return iv
  }()
  
  private lazy var closeButton: UIButton = {
    let button = UIButton(type: .custom)
    button.setImage(UIImage(named: "alert_close"), for: .normal)
    button.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
    return button
  }()
  
  private lazy var centerLabel: UILabel = {
    let label = UILabel()
    label.textAlignment = .center
    label.textColor = .white
    label.font = .systemFont(ofSize: 16, weight: .bold)
    return label
  }()
  
  private lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.text = "Bank Name"
    label.font = .systemFont(ofSize: 16, weight: .bold)
    label.textColor = .white
    return label
  }()
  
  private lazy var tableView: UITableView = {
    let tableView = UITableView()
    tableView.delegate = self
    tableView.dataSource = self
    tableView.separatorStyle = .none
    tableView.backgroundColor = .clear
    tableView.showsVerticalScrollIndicator = false
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    return tableView
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
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    setupCombine()
  }
    
  func configure(title: String, options: [OptionsModel], selectedValue: String? = nil) {
    centerLabel.text = title
    self.selectModels = options
    
    // Find and set the initially selected option
    if let selectedValue = selectedValue {
      let initialOption = options.first { $0.title == selectedValue }
      setupInitialSelection(option: initialOption)
    }
    
    self.tableView.reloadData()
  }
  
  // Update setupInitialSelection to include scrolling
  func setupInitialSelection(option: OptionsModel?) {
    if let option = option {
      self.initialOption = option
      self.selectedOption = option
      // Add a slight delay to ensure the table view is laid out
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
        self?.scrollToSelectedOption()
      }
    } else {
      self.initialOption = nil
      self.selectedOption = nil
    }
    tableView.reloadData()
  }
  
  // Add this method to scroll to selected option
  private func scrollToSelectedOption() {
    if let selectedOption = selectedOption,
       let index = selectModels.firstIndex(where: { $0.title == selectedOption.title }) {
      let indexPath = IndexPath(row: index, section: 0)
      tableView.scrollToRow(at: indexPath, at: .middle, animated: false)
    }
  }
  private func setupUI() {
    view.backgroundColor = .clear
    
    
    view.addSubview(backgroundView)
    backgroundView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    
    view.addSubview(containerView)
    containerView.snp.makeConstraints { make in
      make.bottom.leading.trailing.equalToSuperview()
      make.height.equalTo(348)
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
    //
    
    //
    containerView.addSubview(confirmButton)
    confirmButton.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
      make.width.equalTo(337)
      make.height.equalTo(44)
    }
    
    confirmButton.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
    
    containerView.addSubview(tableView)
    tableView.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(20)
      make.leading.trailing.equalToSuperview().inset(15)
      make.bottom.equalTo(confirmButton.snp.top).offset(-20)
    }
  }
  
  @objc private func closeButtonTapped() {
    dismiss(animated: true)
  }
  
  @objc private func confirmButtonTapped() {
    if let selectedOption = selectedOption {
      onConfirm?(selectedOption)
      dismiss(animated: true)
    }
  }
}

extension OptionSelectViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return selectModels.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
    cell.backgroundColor = .white
    cell.layer.cornerRadius = 8
    cell.clipsToBounds = true
    let option = selectModels[indexPath.row]
    // Configure cell
    cell.textLabel?.text = selectModels[indexPath.row].title
    cell.textLabel?.font = .systemFont(ofSize: 14)
    
    // Add iconImageView if it doesn't exist
    let iconImageView = cell.viewWithTag(100) as? UIImageView ?? {
        let imageView = UIImageView()
        imageView.tag = 100
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 4
        imageView.clipsToBounds = true
        cell.contentView.addSubview(imageView)

        // Add activity indicator to iconImageView
        imageView.addSubview(self.iconActivityIndicator)
        self.iconActivityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        return imageView
    }()
    
          // Load image and setup constraints based on imageUrl
          if !option.imageUrl.isEmpty, let url = URL(string: option.imageUrl) {
              iconImageView.isHidden = false
              // Start animating before loading image
              self.iconActivityIndicator.startAnimating()
    
              iconImageView.snp.remakeConstraints { make in
                  make.leading.equalToSuperview().offset(16)
                  make.centerY.equalToSuperview()
                  make.width.height.equalTo(24)
              }
    
              iconImageView.kf.setImage(with: url, placeholder: nil) { [weak self] result in
                  // Stop animating after image is loaded
                  self?.iconActivityIndicator.stopAnimating()
              }
              cell.textLabel?.snp.remakeConstraints { make in
                  make.leading.equalTo(iconImageView.snp.trailing).offset(12)
                  make.centerY.equalToSuperview()
                  make.trailing.equalToSuperview().offset(-40)
              }
    
              // Rest of the cell setup remains the same
          } else {
              // Hide image view and reset text label to original position
              iconImageView.isHidden = true
              iconImageView.snp.remakeConstraints { make in
                  make.width.height.equalTo(0)
              }
    
              // Text label in original position
              cell.textLabel?.snp.remakeConstraints { make in
                  make.leading.equalToSuperview().offset(16)
                  make.centerY.equalToSuperview()
                  make.trailing.equalToSuperview().offset(-40)
              }
          }
    
    let checkImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 14, height: 14))
    let isSelected = selectModels[indexPath.row].title == selectedOption?.title
    checkImage.image = isSelected ? UIImage(named: "checkmark_selected") : UIImage(named: "checkmark_unselected")
//    cell.accessoryView = checkImage
    
    if isSelected {
      cell.contentView.backgroundColor = UIColor.init(hex: "#DCF6FB")
    }else {
      cell.contentView.backgroundColor = .white
    }
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 56
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    
    let option = selectModels[indexPath.row]
    selectedOption = option
    tableView.reloadData()
  }
}
