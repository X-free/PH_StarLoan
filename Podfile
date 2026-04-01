# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Moneycat' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for NewNewStarLoan
pod 'Alamofire'
pod 'Moya'
pod 'ProgressHUD'
pod 'SnapKit'
pod 'IQKeyboardManagerSwift'
pod 'MJRefresh'
pod 'JLRoutes'
pod 'Kingfisher'
pod 'DZNEmptyDataSet'
pod 'DeviceKit'
pod 'FBSDKCoreKit', '18.0.1'
pod 'SwiftKeychainWrapper'
end


post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
    end
  end
end
