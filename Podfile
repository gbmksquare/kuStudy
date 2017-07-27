workspace 'kuStudy'
project './kuStudy/kuStudy.xcodeproj'

inhibit_all_warnings!

def shared_pods
  pod 'Alamofire'
  pod 'AlamofireObjectMapper'
end

target 'kuStudy' do
  use_frameworks!
  platform :ios, '9.0'

  pod 'AlamofireNetworkActivityIndicator'
  pod 'Localize-Swift'
  pod 'DZNEmptyDataSet'
  pod 'AcknowList'
  pod 'MXParallaxHeader'
  pod 'SimulatorStatusMagic', :configurations => ['Debug']

  target 'kuStudyTests' do
    inherit! :search_paths
  end
end

target 'kuStudy Today Extension' do
  use_frameworks!
  platform :ios, '9.0'

  pod 'Localize-Swift'
end

target 'kuStudy WatchKit App' do
  use_frameworks!
  platform :watchos, '2.0'
end

target 'kuStudy WatchKit Extension' do
  use_frameworks!
  platform :watchos, '2.0'

  pod 'Localize-Swift'
end

target 'kuStudyKit' do
  use_frameworks!
  platform :ios, '9.0'

  shared_pods

  target 'kuStudyKitTests' do
    inherit! :search_paths
  end

end

target 'kuStudyWatchKit' do
  use_frameworks!
  platform :watchos, '2.0'

  shared_pods
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '3.2'
    end
  end
end
