Pod::Spec.new do |s|
  s.name         = "ActionSheetPicker"
  s.version      = "0.1"
  s.summary      = "Quickly reproduce the dropdown UIPickerView / ActionSheet functionality from Safari on iPhone/ iOS / CocoaTouch."
  s.homepage     = "https://github.com/TimCinel/ActionSheetPicker"

  s.license = {
    :type => 'MIT',
    :file => 'LICENSE'
  }
  
  s.authors      = { "Tim Cinel" => "http://github.com/TimCinel" }
  s.source       = { :git => "https://github.com/TimCinel/ActionSheetPicker.git" }
  s.ios.deployment_target = '5.0'
  s.frameworks  = 'UIKit'
  s.source_files = 'Pickers/**/*.{h,m}', 'ActionSheetPicker.h'
end