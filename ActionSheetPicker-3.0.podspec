Pod::Spec.new do |spec|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  spec.name = 'ActionSheetPicker-3.0'
  spec.version = '2.4.0'
  spec.summary = 'Easily present an ActionSheet with a PickerView, allowing the user to select from a number of immutable options.'

  # This description is used to generate tags and improve search results.
  #   * Think: What does it do? Why did you write it? What is the focus?
  #   * Try to keep it short, snappy and to the point.
  #   * Write the description between the DESC delimiters below.
  #   * Finally, don't worry about the indent, CocoaPods strips it!
  spec.description  = <<-DESC
 Better version of ActionSheetPicker with support iOS7 and other improvements:
   - Spawn pickers with convenience function - delegate or reference not required. Just provide a target/action callback.
   - Add buttons to UIToolbar for quick selection (see ActionSheetDatePicker below)
   - Delegate protocol available for more control
   - Universal (iPhone/iPod/iPad)
  DESC

  spec.homepage = 'https://github.com/skywinder/ActionSheetPicker-3.0'
  spec.screenshots   = [ "http://skywinder.github.io/ActionSheetPicker-3.0/Screenshots/date.png",
                         "http://skywinder.github.io/ActionSheetPicker-3.0/Screenshots/distance.png",
                         "http://skywinder.github.io/ActionSheetPicker-3.0/Screenshots/ipad.png",
                         "http://skywinder.github.io/ActionSheetPicker-3.0/Screenshots/string.png"]


  # ―――  Spec License  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  spec.license = 'BSD'


  # ――― Author Metadata  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Specify the authors of the library, with email addresses. Email addresses
  #  of the authors are extracted from the SCM log. E.g. $ git log. CocoaPods also
  #  accepts just a name if you'd rather not provide an email address.
  #
  #  Specify a social_media_url where others can refer to, for example a twitter
  #  profile URL.
  #

  spec.authors = {
    'Petr Korolev' => 'https://github.com/skywinder',
    'Tim Cinel' => 'email@timcinel.com'
  }

  spec.social_media_url   = "https://twitter.com/skywinder/"

  spec.platform     = :ios, "5.0"
  spec.source = { :git => 'https://github.com/skywinder/ActionSheetPicker-3.0.git', :tag => "#{spec.version}" }

  spec.source_files = 'ActionSheetPicker.h', 'Pickers/*.{h,m}'
  spec.public_header_files = 'ActionSheetPicker.h', 'Pickers/*.h'
  spec.framework = 'UIKit'
  spec.requires_arc = true
end
