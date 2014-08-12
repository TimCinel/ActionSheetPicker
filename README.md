[![Version](http://img.shields.io/cocoapods/v/ActionSheetPicker-3.0.svg)](http://cocoadocs.org/docsets/ActionSheetPicker-3.0)
[![License](https://img.shields.io/cocoapods/l/ActionSheetPicker-3.0.svg)](http://cocoadocs.org/docsets/ActionSheetPicker-3.0)
[![Platform](https://img.shields.io/cocoapods/p/ActionSheetPicker-3.0.svg)](http://cocoadocs.org/docsets/ActionSheetPicker-3.0)
[![Issues](http://img.shields.io/github/issues/skywinder/ActionSheetPicker-3.0.svg)](https://github.com/skywinder/ActionSheetPicker-3.0/issues?state=open)

Since the [Tim's repo](https://github.com/TimCinel/ActionSheetPicker) is outdated, I forked from his repo and implement a bunch of UI fixes, crush-fixes and different customisation abilites.

I resolved almost all (more than 60 pull requests and issues) in Tim's repo, but new updates will be added here.

`pod 'ActionSheetPicker-3.0', '~> 1.0.18'` (**iOS 8** compatible already!)

Please welcome: **ActionSheetPicker-3.0**, with fix crashes, new pickers and additions!

*Bug reports, feature requests, patches, well-wishes, and rap demo tapes are always welcome.*

_Regards, Petr Korolev_

## ActionSheetPicker = UIPickerView + UIActionSheet ##

Well, that's how it started. Now, the following is more accurate:

 * _**iPhone/iPod** ActionSheetPicker = ActionSheetPicker = A Picker + UIActionSheet_
 * _**iPad** ActionSheetPicker = A Picker + UIPopoverController_


## Overview ##
ActionSheetPicker

Easily present an ActionSheet with a PickerView, allowing user to select from a number of immutable options. Based on the HTML drop-down alternative found in mobilesafari.

Improvements more than welcome - they are kindly requested :)


## Benefits ##

 * Spawn pickers with convenience function - delegate or reference
   not required. Just provide a target/action callback.
 * Add buttons to UIToolbar for quick selection (see ActionSheetDatePicker below)
 * Delegate protocol available for more control
 * Universal (iPhone/iPod/iPad)

## QuickStart ##

There are 4 distinct picker view options: `ActionSheetStringPicker`, `ActionSheetDistancePicker`, `ActionSheetDatePicker`, and `ActionSheetCustomPicker`. We'll focus here on how to use the `ActionSheetStringPicker` since it's most likely the one you want to use.

#### Basic Usage:

```objective-c
// Inside a IBAction method:

// Create an array of strings you want to show in the picker:
NSArray *colors = [NSArray arrayWithObjects:@"Red", @"Green", @"Blue", @"Orange", nil];

[ActionSheetStringPicker showPickerWithTitle:@"Select a Color"
                                        rows:colors
                            initialSelection:0
                                   doneBlock:nil
                                 cancelBlock:nil
                                      origin:sender];
```

#### But you probably want to know when something happens, huh?

```obj-c
// Inside a IBAction method:

// Create an array of strings you want to show in the picker:
NSArray *colors = [NSArray arrayWithObjects:@"Red", @"Green", @"Blue", @"Orange", nil];

[ActionSheetStringPicker showPickerWithTitle:@"Select a Color"
                                        rows:colors
                            initialSelection:0
                                   doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                                      NSLog(@"Picker: %@", picker);
                                      NSLog(@"Selected Index: %@", selectedIndex);
                                      NSLog(@"Selected Value: %@", selectedValue);
                                    }
                                 cancelBlock:^(ActionSheetStringPicker *picker) {
                                      NSLog(@"Block Picker Canceled");
                                    }
                                      origin:sender];
// You can also use self.view if you don't have a sender
```

## Screen Shots ##


![actionsheetpicker-demo](https://cloud.githubusercontent.com/assets/3356474/3878780/50276c2a-2172-11e4-9d4f-a261d1a1331f.gif)

![ActionSheetPicker](https://raw.githubusercontent.com/skywinder/ActionSheetPicker-3.0/master/Screenshots/string.png "ActionSheetPicker")
![ActionSheetDatePicker](https://raw.githubusercontent.com/skywinder/ActionSheetPicker-3.0/master/Screenshots/date.png "ActionSheetDatePicker")
![ActionSheetDatePicker](https://raw.githubusercontent.com/Jack-s/ActionSheetPicker-3.0/master/Screenshots/time.png "ActionSheetDatePicker")
![iPad Support](https://raw.githubusercontent.com/skywinder/ActionSheetPicker-3.0/master/Screenshots/ipad.png "iPad Support")

## ActionSheetCustomPicker Customization

ActionSheetCustomPicker provides the following delegate function that can be used for customization:

```obj-c
- (void)actionSheetPicker:(AbstractActionSheetPicker *)actionSheetPicker configurePickerView:(UIPickerView *)pickerView;
```
This method is called right before `actionSheetPicker` is presented and it can be used to customize the appearance and properties of the `actionSheetPicker` and the `pickerView` associated with it.

## Credits ##

Thanks to all of the contributors for making ActionSheetPicker better for the iOS developer community. See AUTHORS for details.


### Contributors ###

[Filote Stefan](http://github.com/sfilo)

[Brett Gibson](http://github.com/brettg)

[John Garland](http://github.com/johnnyg) (iPad!)

[Mark van den Broek](http://github.com/heyhoo)

[Evan Cordell](http://github.com/ecordell)

[Greg Combs](http://github.com/grgcombs) (Refactor!)

[Petr Korolev](http://github.com/skywinder) (Update, crash-fix update for iOS7, new pickers)

[Nikos Mouzakitis](http://github.com/NikDude)

### Creator ###

[Tim Cinel](http://github.com/TimCinel)

[@TimCinel](http://twitter.com/TimCinel)

[timcinel.com/](http://www.timcinel.com/)
