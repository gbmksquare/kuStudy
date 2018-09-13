workspace 'kuStudy'
project './kuStudy/kuStudy.xcodeproj'

inhibit_all_warnings!

def shared_pods
  pod 'Alamofire'
  pod 'AlamofireObjectMapper'
end

target 'kuStudy' do
  use_frameworks!
  platform :ios, '11.0'

  pod 'DeviceKit'

  pod 'AlamofireNetworkActivityIndicator'
  pod 'FTLinearActivityIndicator'
  pod 'TONavigationBar'
  pod 'LinearProgressView'
  pod 'MXParallaxHeader'
  pod 'DZNEmptyDataSet'

  pod 'CTFeedback'
  pod 'AcknowList'

  target 'kuStudyTests' do
    inherit! :search_paths
  end

  target 'kuStudy Snapshot' do
    inherit! :search_paths
    pod 'SimulatorStatusMagic'
  end
end

target 'kuStudy Today Extension' do
  use_frameworks!
  platform :ios, '11.0'

  pod 'SnapKit'
end

target 'kuStudy WatchKit App' do
  use_frameworks!
  platform :watchos, '3.0'
end

target 'kuStudy WatchKit Extension' do
  use_frameworks!
  platform :watchos, '3.0'
end

target 'kuStudyKit' do
  use_frameworks!
  platform :ios, '11.0'

  shared_pods

  target 'kuStudyKitTests' do
    inherit! :search_paths
  end

end

target 'kuStudyWatchKit' do
  use_frameworks!
  platform :watchos, '3.0'

  shared_pods
end
