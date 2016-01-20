workspace 'kuStudy'
xcodeproj 'kuStudy/kuStudy.xcodeproj/'

inhibit_all_warnings!

use_frameworks!

def shared_pods
	pod 'Alamofire'
	pod 'RealmSwift'
	pod 'SwiftyJSON'
	pod 'KeychainAccess'
end

target 'kuStudy' do
	platform :ios, '9.0'
	shared_pods
end

target 'kuStudyKit' do
	platform :ios, '9.0'
	shared_pods
end

target 'kuStudyWatchKit' do
	platform :watchos, '2.0'
	shared_pods
end

target 'kuStudy Today Extension' do
	platform :ios, '9.0'
	shared_pods
end

target 'kuStudy WatchKit Extension' do
	platform :watchos, '2.0'
	shared_pods
end
