#
# Be sure to run `pod lib lint cyberpaysdk.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'cyberpaysdk'
  s.version          = '1.0.0'
  s.summary          = 'The iOS SDK for the cyberpay payment gateway'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description  = "The iOS SDK for the cyberpay payment gateway, with a drop in UI"

  s.homepage         = 'https://github.com/cyberspace-ltd/cyberpay-iosx'
   s.screenshots     = 'https://p0.f0.n0.cdn.getcloudapp.com/items/mXuBWGAX/cyberpayios.png?v=8ca7183d8a6b4e264f090e9af4952850'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'davidehigiator' => 'david.ehigiator@cyberspace.net.ng' }
  s.source           = { :git => 'https://github.com/cyberspace-ltd/cyberpay-iosx.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'
  s.swift_version = "5.0"
  s.ios.deployment_target = '11.0'

  s.source_files = 'cyberpaysdk/Classes/**/*'
  s.resources = ['cyberpaysdk/Assets/Assets.xcassets']
#   s.resource_bundles = {
#     'cyberpaysdk' => ['cyberpaysdk/**/*.{pdf,png,jpeg,jpg,storyboard,xib,xcassets}']
#   }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
  s.dependency "RxSwift", "~> 5.1.1"
  s.dependency "RxCocoa", "~> 5.1.1"
  s.dependency "FittedSheets", "~> 1.4.6"
  s.dependency "MaterialComponents/BottomSheet", "~> 94.4.0"
end
