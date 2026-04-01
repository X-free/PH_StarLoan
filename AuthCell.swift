//
//  AuthCell.swift
//  
//
//  Created by Albert on 2025/5/25.
//


// 修改 AuthCell
class AuthCell: UITableViewCell {
  private lazy var authImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFill
    return imageView
  }()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupUI() {
    contentView.addSubview(authImageView)
    authImageView.snp.makeConstraints { make in
      make.edges.equalToSuperview().inset(UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20))
    }
  }
  
  func configure(with authItem: AuthItem) {
    let imageName = authItem.baseImageName + (authItem.isFinished ? "_finished" : "_unfinished")
    authImageView.image = UIImage(named: imageName)
  }
}