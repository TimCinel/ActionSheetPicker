//
//  ActionSheetPickerViewController.h
//  ActionSheetPicker
//
//  Created by S3166992 on 6/01/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActionSheetPickerViewController : UIViewController <UITextFieldDelegate> {
	IBOutlet UITextField *_textField;
	NSArray *_animals;
	NSInteger _selectedIndex;
}

@property (nonatomic, retain) UITextField *textField;
@property (nonatomic, retain) NSArray *animals;
@property (nonatomic, assign) NSInteger selectedIndex;

- (IBAction)selectAnItem;
- (void)itemWasSelected:(NSNumber *)selectedIndex;

@end

