Pod::Spec.new do |s|
  s.name          = "ActionSheetPicker"
  s.version       = "1.5.0"
  s.summary    = "Quickly reproduce the dropdown UIPickerView / ActionSheet functionality from Safari on iPhone/ iOS / CocoaTouch."
  s.homepage   = "https://github.com/skywinder/ActionSheetPicker-3.0"
  s.license       = 'BSD'
  s.author      = {
  'Tim Cinel'               => 'email@timcinel.com',
  'Filote Stefan'          => 'http://github.com/sfilo',
  'Brett Gibson'          => 'http://github.com/brettg',
  'John Garland'          => 'http://github.com/johnnyg',
  'Mark van den Broek' => 'http://github.com/heyhoo',
  'Evan Cordell'          => 'http://github.com/ecordell',
  'Greg Combs'           => 'http://github.com/grgcombs',
  'Hari Karam Singh'    => 'http://github.com/Club15CC',
  'Petr Korolev' => 'https://github.com/skywinder' }
  s.source       = { :git => 'https://github.com/skywinder/ActionSheetPicker-3.0.git', :tag => "#{s.version}" }
  s.platform       = :ios
  s.source_files  = 'ActionSheetPicker.h', 'Pickers/*.{h,m}'
  s.public_header_files = 'ActionSheetPicker.h', 'Pickers/*.h'
  s.framework   = 'UIKit'
  s.requires_arc = true
end
