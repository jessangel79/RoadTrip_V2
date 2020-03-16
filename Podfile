# Uncomment the next line to define a global platform for your project
platform :ios, '11.0'

source 'https://github.com/CocoaPods/Specs.git'
target 'RoadTrip' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!
  
  pod 'GooglePlaces'
  pod 'Alamofire', '4.9'
  pod 'SDWebImage', '~> 5.0'
  pod 'SDWebImage/MapKit'

  target 'RoadTripTests' do
    inherit! :search_paths
    pod 'GooglePlaces'
    pod 'Alamofire', '4.9'
    pod 'SDWebImage', '~> 5.0'
    pod 'SDWebImage/MapKit'
  end

end