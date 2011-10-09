//
//  ActionSheetPickerViewController.h
//  ActionSheetPicker
//
//  Created by S3166992 on 6/01/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ActionSheetPicker;

@interface ActionSheetPickerViewController : UIViewController <UITextFieldDelegate> {
	NSArray *_animals;
	
	NSInteger _selectedIndex;
	NSDate *_selectedDate;
}

@property (nonatomic, retain) NSArray *animals;

@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, retain) NSDate *selectedDate;

@property (nonatomic, retain) ActionSheetPicker *actionSheetPicker;

- (IBAction)selectAnItem:(id)sender;
- (IBAction)selectADate:(id)sender;
- (IBAction)animalButtonTapped:(UIBarButtonItem *)sender;
- (IBAction)dateButtonTapped:(UIBarButtonItem *)sender;

- (void)itemWasSelected:(NSNumber *)selectedIndex:(id)element;
- (void)dateWasSelected:(NSDate *)selectedDate:(id)element;

@end