Pod::Spec.new do |s|
  s.platform = :ios
  s.ios.deployment_target = '8.0'
  s.name = "AMLocationBased"
  s.summary = "Lib developed this to help developers work with directions between the geo-locations. From this lib can be developed augmented reality projects using the compass and GPS for the direction of other points. There is also the possibility of creating other points from an existing one, informing the direction and distance."
  s.requires_arc = true
  s.version = "0.1.0"
  s.license = { :type => "MIT", :file => "LICENSE" }
  s.author = { “Allan Melo“ => “allanragec@gmail.com” }
  s.homepage = "https://github.com/allanragec/AMLocationBased-iOS.git"
  s.source = { :git => "https://github.com/allanragec/AMLocationBased-iOS.git", :tag => "#{s.version}"}
  s.framework = "UIKit"
  s.source_files = "AMLocationBased/*.{h,m}"
end