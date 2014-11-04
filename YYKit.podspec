#
# Be sure to run `pod lib lint YYKit.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "YYKit"
  s.version          = "0.2.0"
  s.summary          = "Utilities for iOS"
  s.homepage         = "https://github.com/ibireme/YYKit"
  s.license          = 'MIT'
  s.author           = { "ibireme" => "ibireme@gmail.com" }
  s.source           = { :git => "https://github.com/ibireme/YYKit.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.platform     = :ios, '6.0'
  s.ios.deployment_target = '6.0'
  s.requires_arc = true

  s.source_files = 'YYKit/*.{h,m}'
  s.public_header_files = 'YYKit/*.h'
  s.resource_bundles = {
    'YYKit' => ['YYKit/*.png']
  }
  
  non_arc_files = 'YYKit/NSObject+YYAddForARC.{h,m}'
  s.ios.exclude_files = non_arc_files
  s.subspec 'no-arc' do |sna|
    sna.requires_arc = false
    sna.source_files = non_arc_files
  end

  s.frameworks = 'UIKit', 'QuartzCore', 'CoreGraphics', 'CoreText', 'ImageIO', 'Accelerate', 'Security', 'MobileCoreServices'
  s.libraries = 'z'
  # s.dependency 'AFNetworking', '~> 2.3'
end
