Pod::Spec.new do | s |
    s.name = 'ActionSheetPicker-3.0'
    s.version = '1.1.2'
    s.summary = 'Better version of ActionSheetPicker with support iOS7 and other improvements.'
    s.homepage = 'http://skywinder.github.io/ActionSheetPicker-3.0'
    s.license = 'BSD'
    s.authors = {
        'Petr Korolev' => 'https://github.com/skywinder',
        'Tim Cinel' => 'email@timcinel.com',
        'Filote Stefan' => 'http://github.com/sfilo',
        'Brett Gibson' => 'http://github.com/brettg',
        'John Garland' => 'http://github.com/johnnyg',
        'Mark van den Broek' => 'http://github.com/heyhoo',
        'Evan Cordell' => 'http://github.com/ecordell',
        'Greg Combs' => 'http://github.com/grgcombs',
    }
    s.source = { :git => 'https://github.com/skywinder/ActionSheetPicker-3.0.git', :tag => "#{s.version}" }
     s.screenshots   = [ "http://skywinder.github.io/ActionSheetPicker-3.0/Screenshots/date.png",
                        "http://skywinder.github.io/ActionSheetPicker-3.0/Screenshots/distance.png",
                        "http://skywinder.github.io/ActionSheetPicker-3.0/Screenshots/ipad.png",
                        "http://skywinder.github.io/ActionSheetPicker-3.0/Screenshots/string.png"]
    s.requires_arc = true
    s.ios.deployment_target = '6.1'
    s.platform = :ios
    s.public_header_files = 'ActionSheetPicker.h', 'Pickers/*.{h,m}'
    s.source_files = 'ActionSheetPicker.h', 'Pickers/*.{h,m}'
    s.framework = 'UIKit'
end
