#
# Be sure to run `pod lib lint LWSnapshot_swift.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'LWSnapshot_swift'
  s.version          = '1.0.0'
  s.summary          = 'Swift版本的LWSnapshot - 可自定义选取截取范围的截图组件'

  s.description      = <<-DESC
LWSnapshot_swift 是 LWSnapshot 的 Swift 版本实现。
提供了现代化的 Swift API 用于实现可自定义选取截取范围的截图功能。
支持 SwiftUI 和 UIKit 两种使用方式。
                       DESC

  s.homepage         = 'https://github.com/luowei/LWSnapshot'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'luowei' => 'luowei@wodedata.com' }
  s.source           = { :git => 'https://github.com/luowei/LWSnapshot.git', :tag => "swift-#{s.version}" }

  s.ios.deployment_target = '11.0'
  s.swift_version = '5.0'

  s.source_files = 'LWSnapshot_swift/Classes/**/*.swift'

  s.frameworks = 'UIKit'
end
