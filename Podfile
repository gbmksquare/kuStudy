workspace 'kuStudy'
project './kuStudy/kuStudy.xcodeproj'

inhibit_all_warnings!

def shared_pods
  pod 'Alamofire'
  pod 'AlamofireObjectMapper'
end

target 'kuStudy' do
  use_frameworks!
  platform :ios, '10.0'

  pod 'DeviceKit'
  pod 'AlamofireNetworkActivityIndicator'
  pod 'LinearProgressView'
  pod 'DZNEmptyDataSet'
  pod 'AcknowList'
  pod 'CTFeedback'
  pod 'MXParallaxHeader'
  pod 'SimulatorStatusMagic', :configurations => ['Debug']

  target 'kuStudyTests' do
    inherit! :search_paths
  end
end

target 'kuStudy Today Extension' do
  use_frameworks!
  platform :ios, '10.0'

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
  platform :ios, '10.0'

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

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
    	if config.name == 'Release'
    		config.build_settings['SWIFT_OPTIMIZATION_LEVEL'] = '-Owholemodule'
    	else
    		config.build_settings['SWIFT_OPTIMIZATION_LEVEL'] = '-Onone'
    	end
    end
  end
end
