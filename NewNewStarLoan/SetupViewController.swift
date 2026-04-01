//
//  SetupViewController.swift
//  NewNewStarLoan
//
//  Created by Albert on 2026/01/26.
//

import UIKit
import SnapKit
import ProgressHUD

class SetupViewController: UIViewController {
    
    private lazy var navigationBar: CustomNavigationBar = {
        let nav = CustomNavigationBar()
        nav.setTitle("Set up")
        nav.backButtonTapped = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        return nav
    }()
    
    private lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "xzrzfs_bg"))
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private lazy var goOutContainer: UIView = {
        let view = UIView()
        
        let bg = UIImageView(image: UIImage(named: "mine_cell_bg"))
        bg.contentMode = .scaleToFill
        view.addSubview(bg)
        bg.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        let icon = UIImageView(image: UIImage(named: "mine_goout"))
        icon.contentMode = .scaleAspectFit
        view.addSubview(icon)
        icon.snp.makeConstraints { make in
            make.leading.equalTo(16)
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 24, height: 24))
        }
        
        let label = UILabel()
        label.text = "Go Out"
        label.applyMineStyle()
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.leading.equalTo(icon.snp.trailing).offset(12)
            make.centerY.equalToSuperview()
        }
        
        let arrow = UIImageView(image: UIImage(named: "right_arrow"))
        view.addSubview(arrow)
        arrow.snp.makeConstraints { make in
            make.trailing.equalTo(-16)
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 7, height: 10))
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(goOutTapped))
        view.addGestureRecognizer(tap)
        view.isUserInteractionEnabled = true
        
        return view
    }()
    
    private lazy var cancelAccountButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Cancel Account", for: .normal)
        button.setTitleColor(UIColor(hex: "6C6C6C"), for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        button.backgroundColor = .white
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(hex: "F1F1F1").cgColor
        button.layer.cornerRadius = 14
        button.addTarget(self, action: #selector(cancelAccountTapped), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        // Add Subviews
        view.addSubview(navigationBar)
        view.addSubview(backgroundImageView)
        view.addSubview(goOutContainer)
        view.addSubview(cancelAccountButton)
        
        // Layout Navigation Bar
        navigationBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(44)
        }
        
        // Layout Background
        backgroundImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(44)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.snp.bottom)
        }
        
        // Layout Go Out Container
        goOutContainer.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(60)
        }
        
        // Layout Cancel Account Button
        cancelAccountButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-40)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
    }
    
    @objc private func goOutTapped() {
        if let windowScene = view.window?.windowScene,
           let sceneDelegate = windowScene.delegate as? SceneDelegate {
            let alertVC = LogoutAlertViewController()
            alertVC.sceneDelegate = sceneDelegate
            alertVC.modalPresentationStyle = .fullScreen
            alertVC.dismissCallback = {
                ProgressHUD.animate()
                Task {
                    let _ = try? await AuthService.shared.logout()
                    ProgressHUD.dismiss()
                    if let windowScene = self.view.window?.windowScene,
                       let sceneDelegate = windowScene.delegate as? SceneDelegate {
                        sceneDelegate.switchToMainInterface()
                    }
                }
            }
            present(alertVC, animated: false)
        }
    }
    
    @objc private func cancelAccountTapped() {
        if let windowScene = view.window?.windowScene,
           let sceneDelegate = windowScene.delegate as? SceneDelegate {
            let alertVC = CancelAccountAlertController()
            alertVC.sceneDelegate = sceneDelegate
            alertVC.modalPresentationStyle = .fullScreen
            alertVC.dismissCallback = {
                ProgressHUD.animate()
                Task {
                    do {
                        let _ = try await AuthService.shared.cancelAccount()
                        ProgressHUD.dismiss()
                        if let windowScene = self.view.window?.windowScene,
                           let sceneDelegate = windowScene.delegate as? SceneDelegate {
                            sceneDelegate.switchToMainInterface()
                        }
                    } catch {
                        ProgressHUD.error(error.localizedDescription)
                    }
                }
            }
            present(alertVC, animated: false)
        }
    }
}
