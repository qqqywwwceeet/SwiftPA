
Pod::Spec.new do |s|

  s.name = "SwiftPA"
  s.version = "1.0.0"
  s.summary = "Extensions For Swift"
  s.homepage = "https://github.com/qqqywwwceeet"
  s.license = { :type => 'Apache License, Version 2.0', :text => <<-LICENSE
    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
    LICENSE
  }
  s.author = { "qqqywwwceeet" => "qqqywwwceeet@outlook.com" }
  s.ios.deployment_target = '14.0'
  s.swift_version = "5.0"
  s.static_framework = true
  s.source = {:git => "https://github.com/qqqywwwceeet/SwiftPA.git", :tag => "#{s.version}"}
  s.source_files = ["SwiftPA/*.swift"]
  
end
