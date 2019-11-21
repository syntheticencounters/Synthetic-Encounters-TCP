require "json"

package = JSON.parse(File.read(File.join(__dir__, "package.json")))

Pod::Spec.new do |s|
  s.name         = "SETcp"
  s.version      = package["version"]
  s.summary      = package["description"]
  s.description  = <<-DESC
                  Synthetic-Encounters-TCP
                   DESC
  s.homepage     = "https://syntheticencounters.com"
  s.license      = "MIT"
  # s.license    = { :type => "MIT", :file => "FILE_LICENSE" }
  s.author       = { "author" => "mrcvideo@gmail.com" }
  s.platform     = :ios, "11.0"
  s.source       = { :git => "" }

  s.source_files = "ios/*.{h,m}"
  s.requires_arc = true

  s.dependency "React"
  s.dependency "CocoaAsyncSocket"
end
