//
//  ActionSheetPickerViewController.m
//  ActionSheetPicker
//
//  Created by S3166992 on 6/01/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

#import "ActionSheetPickerViewController.h"
#import "ActionSheetPicker.h"

@implementation ActionSheetPickerViewController

@synthesize textField = _textField;
@synthesize animals = _animals;
@synthesize selectedIndex = _selectedIndex;

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.animals = [NSArray arrayWithObjects:@"Aardvark", @"Beaver", @"Cheetah", @"Deer", @"Elephant", @"Frog", @"Gopher", @"Horse", @"Impala", @"...", @"Zebra", nil];
}

#pragma mark -
#pragma mark Implementation

- (IBAction)selectAnItem {
	//Display the ActionSheetPicker
	[ActionSheetPicker displayActionPickerWithView:self.view data:self.animals selectedIndex:self.selectedIndex target:self action:@selector(itemWasSelected:)];
}

- (void)itemWasSelected:(NSNumber *)selectedIndex {
	//Selection was made
	self.selectedIndex = [selectedIndex intValue];
	self.textField.text = [self.animals objectAtIndex:self.selectedIndex];
}

#pragma mark -
#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
	return NO;
}

#pragma mark -
#pragma mark Memory Management

- (void)viewDidUnload {
	[self.textField release];
	self.textField = nil;
}


- (void)dealloc {
	[self.animals release];
    [super dealloc];
}

@end
