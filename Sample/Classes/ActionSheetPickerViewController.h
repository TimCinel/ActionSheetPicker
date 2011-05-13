//
//  ActionSheetPickerViewController.h
//  ActionSheetPicker
//
//  Created by S3166992 on 6/01/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActionSheetPickerViewController : UIViewController <UITextFieldDelegate> {
	IBOutlet UITextField *_itemTextField;
	IBOutlet UITextField *_dateTextField;
	
	NSArray *_animals;
	
	NSInteger _selectedIndex;
	NSDate *_selectedDate;
}

@property (nonatomic, retain) UITextField *itemTextField;
@property (nonatomic, retain) UITextField *dateTextField;

@property (nonatomic, retain) NSArray *animals;

@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, retain) NSDate *selectedDate;

- (IBAction)selectAnItem;
- (IBAction)selectADate;

- (void)itemWasSelected:(NSNumber *)selectedIndex;
- (void)dateWasSelected:(NSDate *)selectedDate;

@end

