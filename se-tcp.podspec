require "json"

package = JSON.parse(File.read(File.join(__dir__, "package.json")))

Pod::Spec.new do |s|
  s.name         = "SyntheticTcp"
  s.version      = package["version"]
  s.summary      = package["description"]
  s.description  = <<-DESC
                  se-tcp
                   DESC
  s.homepage     = "https://github.com/syntheticencounters/Synthetic-Encounters-TCP"
  s.license      = "MIT"
  # s.license    = { :type => "MIT", :file => "FILE_LICENSE" }
  s.authors      = { "Mike Carpenter" => "syntheticencounters@gmail.com" }
  s.platforms    = { :ios => "9.0", :tvos => "10.0" }
  s.source       = { :git => "https://github.com/syntheticencounters/Synthetic-Encounters-TCP.git" }

  s.source_files = "ios/**/*.{h,m,swift}"
  s.requires_arc = true

  s.dependency "React"
end
