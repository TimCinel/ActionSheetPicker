//
//  ActionSheetPickerAppDelegate.h
//  ActionSheetPicker
//
//  Created by S3166992 on 6/01/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ActionSheetPickerViewController;

@interface ActionSheetPickerAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    ActionSheetPickerViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet ActionSheetPickerViewController *viewController;

@end

