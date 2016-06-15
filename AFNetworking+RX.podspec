









Pod::Spec.new do |s|
  s.name     = "AFNetworking+RX"
  s.version  = "3.1.0.12"
  s.license  = "MIT"
  s.summary  = "AFNetworking+RX is a simple ext of AFNetworking"
  s.homepage = "https://github.com/xzjxylophone/AFNetworking-RX"
  s.author   = { 'Rush.D.Xzj' => 'xzjxylophoe@gmail.com' }
  s.social_media_url = "http://weibo.com/xzjxylophone"
  s.source   = { :git => 'https://github.com/xzjxylophone/AFNetworking-RX.git', :tag => "v#{s.version}" }
  s.description = %{
    AFNetworking+RX is a simple ext of AFNetworking.
  }
  s.source_files = 'AFNetworking-RX/*.{h,m}'
  s.frameworks = 'Foundation', 'UIKit'
  s.requires_arc = true
  s.platform = :ios, '7.0'
  s.dependency 'AFNetworking'
end






