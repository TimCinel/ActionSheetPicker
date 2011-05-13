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

@synthesize itemTextField = _itemTextField;
@synthesize dateTextField = _dateTextField;

@synthesize animals = _animals;

@synthesize selectedIndex = _selectedIndex;
@synthesize selectedDate = _selectedDate;

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.animals = [NSArray arrayWithObjects:@"Aardvark", @"Beaver", @"Cheetah", @"Deer", @"Elephant", @"Frog", @"Gopher", @"Horse", @"Impala", @"...", @"Zebra", nil];
}

#pragma mark -
#pragma mark IBActions

- (IBAction)selectAnItem {
	//Display the ActionSheetPicker
	[ActionSheetPicker displayActionPickerWithView:self.view data:self.animals selectedIndex:self.selectedIndex target:self action:@selector(itemWasSelected:) title:@"Select Animal"];
}

- (IBAction)selectADate {
	//Display the ActionSheetPicker
	[ActionSheetPicker displayActionPickerWithView:self.view datePickerMode:UIDatePickerModeDate selectedDate:[NSDate date] target:self action:@selector(dateWasSelected:) title:@"Select Date"]; 
}

#pragma mark -
#pragma mark Implementation

- (void)itemWasSelected:(NSNumber *)selectedIndex {
	//Selection was made
	self.selectedIndex = [selectedIndex intValue];
	self.itemTextField.text = [self.animals objectAtIndex:self.selectedIndex];
}

- (void)dateWasSelected:(NSDate *)selectedDate {
	//Date selection was made
	self.selectedDate = selectedDate;
	self.dateTextField.text = [self.selectedDate description];
}

#pragma mark -
#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
	return NO;
}

#pragma mark -
#pragma mark Memory Management

- (void)viewDidUnload {
	self.itemTextField = nil;
	self.dateTextField =nil;
}



- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}


- (void)dealloc {
	self.animals = nil;
	self.selectedDate = nil;
	
    [super dealloc];
}

@end
