Pod::Spec.new do |s|
  s.name         = "StreamReader"
  s.version      = "0.2.1"
  s.summary      = "Line-by-line file reader"
  s.description  = <<-DESC
     Small library that reads lines from a file.

     Default line delimiter (`\n`), string encoding (`UTF-8`) and chunk size (`4096`) can be set with optional parameters.    
  DESC
  s.homepage     = "https://github.com/hectr/swift-stream-reader"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "Hèctor Marquès" => "h@mrhector.me" }
  s.social_media_url   = "https://twitter.com/elnetus"
  s.ios.deployment_target = "8.0"
  s.osx.deployment_target = "10.9"
  s.watchos.deployment_target = "2.0"
  s.tvos.deployment_target    = "9.0"
  s.source       = { :git => "https://github.com/hectr/swift-stream-reader.git", :tag => s.version.to_s }
  s.source_files = "Sources/**/*"
  s.frameworks   = "Foundation"
end
