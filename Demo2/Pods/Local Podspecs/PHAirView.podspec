Pod::Spec.new do |s|
  s.name             = "PHAirView"
  s.version          = "0.1.0"
  s.summary          = "A short description of PHAirView."
  s.description      = <<-DESC
                       An Airbnb like Sliding Menu
                       DESC
  s.homepage         = "https://github.com/thedamfr/PHAirViewController"
  s.license          = 'MIT'
  s.author           = { "Phuoc Hai" => "taphuochai@gmail.com" }
  s.source           = { :git => "https://github.com/thedamfr/PHAirViewController", :tag => s.version.to_s }

  s.platform     = :ios, '5.0'
  s.requires_arc = true

  s.source_files = 'Source/**/*'
end
