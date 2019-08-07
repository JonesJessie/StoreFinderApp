# StoreFinderApp
App that uses the yelp API to find local nearby food to eat and allows the user to "like" a place and 
to see previously liked places when in the area again, uses AlamoFireImage and moya. 

# App Features
1. loads local restaurants and eatery based on location
2. description when clicked of each location
3. a like button in form of a heart

# Requirements

Xcode 9.2+
Swift 4.0+
alamofireImage
moya

# How To Build
Need to run pod install for AlamofireImage and Moya
Add the following to your podfile the run pod install

# AlamofireImage 
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '10.0'
use_frameworks!

target '<Your Target Name>' do
    pod 'AlamofireImage', '~> 3.5'
end
Then, run the following command:

$ pod install

# Moya 
pod 'Moya', '~> 13.0'
or 
pod 'Moya/RxSwift', '~> 13.0'
or
pod 'Moya/ReactiveSwift', '~> 13.0'
Then run pod install.
