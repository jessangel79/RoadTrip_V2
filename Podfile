# Uncomment the next line to define a global platform for your project
platform :ios, '11.0'

source 'https://github.com/CocoaPods/Specs.git'
target 'RoadTrip' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!
  
  pod 'Alamofire', '4.9'
  pod 'SDWebImage', '5.6'
  pod 'Google-Mobile-Ads-SDK'

  target 'RoadTripTests' do
    inherit! :search_paths
    pod 'Alamofire', '4.9'
  end

end

post_install do |installer|
     installer.pods_project.targets.each do |target|
           target.build_configurations.each do |config|
                 config.build_settings['EXCLUDED_ARCHS[sdk=iphonesimulator*]'] = 'arm64'
           end
     end
#    installer.pods_project.build_configurations.each do |config|
#      config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
#    end
end
