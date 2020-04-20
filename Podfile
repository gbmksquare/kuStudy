workspace 'kuStudy'
project './kuStudy/kuStudy.xcodeproj'

inhibit_all_warnings!

def shared_pods
  pod 'Alamofire'
end

target 'kuStudy' do
  use_frameworks!
  platform :ios, '13.0'

  pod 'SnapKit' #spm

  pod 'AlamofireNetworkActivityIndicator' #spm
  pod 'FTLinearActivityIndicator' #spm
  
  pod 'AcknowList' #spm

  target 'kuStudyTests' do
    inherit! :search_paths
  end

  target 'kuStudy Snapshot' do
    inherit! :search_paths
  end
end

target 'kuStudy Today Extension' do
  use_frameworks!
  platform :ios, '13.0'

  pod 'SnapKit'
end

target 'kuStudy WatchKit App' do
  use_frameworks!
  platform :watchos, '6.0'
end

target 'kuStudy WatchKit Extension' do
  use_frameworks!
  platform :watchos, '6.0'
end

target 'kuStudyKit' do
  use_frameworks!
  platform :ios, '13.0'

  shared_pods

  target 'kuStudyKitTests' do
    inherit! :search_paths
  end

end

target 'kuStudyWatchKit' do
  use_frameworks!
  platform :watchos, '6.0'

  shared_pods
end

# Fix for Xcode 10 upload watchOS app problem
# https://stackoverflow.com/questions/52304108/xcode-10-gm-invalid-binary-architecture-when-submitting-to-app-store-connect
# post_install do |installer_representation|
#     installer_representation.pods_project.targets.each do |target|
#         target.build_configurations.each do |config|
#             if config.build_settings['SDKROOT'] == 'watchos'  
#               config.build_settings['WATCHOS_DEPLOYMENT_TARGET'] = '6.0'  
#             end
#         end
#     end
# end
