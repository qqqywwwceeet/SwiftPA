
Pod::Spec.new do |s|

  s.name = "SwiftPA"
  s.version = "1.0.1"
  s.summary = "Extensions For Swift"
  s.homepage = "https://github.com/qqqywwwceeet/SwiftPA"
  s.license = { :type => 'MIT', :file => 'LICENSE' }
  
  s.author = { "qqqywwwceeet" => "qqqywwwceeet@outlook.com" }
  s.ios.deployment_target = '14.0'
  s.swift_version = "5.0"
  s.static_framework = true
  s.source = {:git => "https://github.com/qqqywwwceeet/SwiftPA.git", :tag => "#{s.version}"}
  s.source_files = ["SwiftPA/*.swift"]
  
end
