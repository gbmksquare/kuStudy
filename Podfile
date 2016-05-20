workspace 'kuStudy'
project './kuStudy/kuStudy.xcodeproj'

# inhibit_all_warnings!

def shared_pods
  pod 'Alamofire'
  pod 'AlamofireObjectMapper'
  pod 'SwiftyJSON'
end

target 'kuStudy' do
  use_frameworks!
  platform :ios, '9.0'

  pod 'CTFeedback'
  pod 'Localize-Swift'
  pod 'DZNEmptyDataSet'
  shared_pods

  target 'kuStudyTests' do
    inherit! :search_paths
  end
end

target 'kuStudy Today Extension' do
  use_frameworks!
  platform :ios, '9.0'

  shared_pods
end

target 'kuStudy WatchKit App' do
  use_frameworks!
  platform :watchos, '2.0'
end

target 'kuStudy WatchKit Extension' do
  use_frameworks!
  platform :watchos, '2.0'

  shared_pods
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
