
import UIKit
import SnapKit

//// Add CloudDisplayable protocol above the cell class
protocol BadDisplayable {
  var bad: String { get }
}

// Make Attack conform to CloudDisplayable
extension GetUserInfoResponse.MiddleInfo.StoppedItem.LineItem: BadDisplayable {}

enum InfomationInputCellStyle {
  case input
  case select
  case citySelect
}

enum KeyboardType: Int {
  case normal = 0
  case number = 1
}

class AuthPersonalInfoCell: UITableViewCell {
  static let identifier = "AuthPersonalInfoCell"
  private(set) var selectedOption: BadDisplayable?
  
  private var cellStyle: InfomationInputCellStyle = .input
   var onButtonTapped: (() -> Void)?
  
  //    var onTextChanged: ((String) -> Void)?
  // 添加选项点击回调
  var onOptionSelected: (() -> Void)?
  
  private lazy var containerView: UIImageView = {
    let imageView = UIImageView(image: UIImage(named: "grxx_bg_04"))
    imageView.isUserInteractionEnabled = true
    imageView.contentMode = .scaleToFill
    return imageView
  }()
  
  private lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 14, weight: .medium)
    label.textColor = UIColor(hex: "4999F7")
    return label
  }()
  
  lazy var valueTextField: UITextField = {
    let textField = UITextField()
    textField.font = .systemFont(ofSize: 14, weight: .medium)
    textField.textColor = UIColor(hex: "06101C")
    return textField
  }()
  
  private let button: UIButton = {
      let button = UIButton(type: .custom)
      button.backgroundColor = .clear
      return button
  }()
  
  private lazy var arrowImageView: UIImageView = {
    let imageView = UIImageView(image: UIImage(named: "right_arrow"))
    imageView.contentMode = .scaleAspectFit
    return imageView
  }()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupUI()
    setupAction()

  }
  
  private func setupAction() {
      button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
  }
  
  @objc func buttonTapped() {
      onButtonTapped?()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupUI() {
    backgroundColor = .clear
    selectionStyle = .none
    
    contentView.addSubview(containerView)
    containerView.addSubview(titleLabel)
    containerView.addSubview(valueTextField)
    containerView.addSubview(arrowImageView)
    containerView.addSubview(button)
    
    arrowImageView.snp.makeConstraints { make in
      make.centerY.equalTo(valueTextField)
      make.trailing.equalToSuperview().offset(-30)
      make.width.equalTo(7)
      make.height.equalTo(10)
    }
    arrowImageView.isHidden = true
    
    containerView.snp.makeConstraints { make in
      make.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 15, bottom: 14, right: 15))
    }
    
    titleLabel.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(12)
      make.leading.equalToSuperview().offset(15)
    }
    
    valueTextField.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(40)
      make.leading.equalToSuperview().offset(30)
      make.trailing.equalToSuperview().offset(-10)
      make.height.equalTo(48)
    }

    button.snp.makeConstraints { make in
        make.edges.equalTo(valueTextField)
    }
  }
  
  @objc private func containerViewTapped() {
    if !arrowImageView.isHidden {
      onOptionSelected?()
    }
  }
  
  
  func configure(title: String, placeholder: String, style: InfomationInputCellStyle, keyboardType: KeyboardType) {
    titleLabel.text = title
    valueTextField.placeholder = placeholder
    self.cellStyle = style
    
    // Configure keyboard type
    valueTextField.keyboardType = keyboardType == .normal ? .default : .numberPad
    
    // Configure based on style
    switch style {
    case .input:
      valueTextField.isEnabled = true
      arrowImageView.isHidden = true
                button.isEnabled = false
//      valueTextField.placeholder = "Please enter"
    case .select, .citySelect:
      valueTextField.isEnabled = false
      arrowImageView.isHidden = false
                button.isEnabled = true
//      valueTextField.placeholder = "Please select"
    }
  }
  
  // Update method to use CloudDisplayable
  func updateSelectedOption(_ option: BadDisplayable) {
      selectedOption = option
      valueTextField.text = option.bad
  }
  
  // Add a public method to clear selection
  func clearSelection() {
      selectedOption = nil
      valueTextField.text = ""
  }
}
