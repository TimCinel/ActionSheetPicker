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

@synthesize animals = _animals;

@synthesize selectedIndex = _selectedIndex;
@synthesize selectedDate = _selectedDate;
@synthesize selectedBigUnit = _selectedBigUnit;
@synthesize selectedSmallUnit = _selectedSmallUnit;

@synthesize actionSheetPicker = _actionSheetPicker;

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.animals = [NSArray arrayWithObjects:@"Aardvark", @"Beaver", @"Cheetah", @"Deer", @"Elephant", @"Frog", @"Gopher", @"Horse", @"Impala", @"...", @"Zebra", nil];
}

#pragma mark -
#pragma mark IBActions

- (IBAction)selectAnItem:(UIControl *)sender {
	//Display the ActionSheetPicker
	[ActionSheetPicker displayActionPickerWithView:sender data:self.animals selectedIndex:self.selectedIndex target:self action:@selector(itemWasSelected::) title:@"Select Animal"];
}

- (IBAction)selectADate:(UIControl *)sender {
	//Display the ActionSheetPicker
	[ActionSheetPicker displayActionPickerWithView:sender datePickerMode:UIDatePickerModeDate selectedDate:self.selectedDate?:[NSDate date] target:self action:@selector(dateWasSelected::) title:@"Select Date"]; 
}

- (IBAction)animalButtonTapped:(UIBarButtonItem *)sender {
	if (nil != self.actionSheetPicker) {
        [self.actionSheetPicker actionPickerCancel];
    }
    
    //Display the ActionSheetPicker
    self.actionSheetPicker = [[ActionSheetPicker initActionPickerWithBarButtonItem:sender data:self.animals selectedIndex:self.selectedIndex target:self action:@selector(itemWasSelected::) title:@"Select Animal"] retain];    
}

- (IBAction)dateButtonTapped:(UIBarButtonItem *)sender {
	if (nil != self.actionSheetPicker) {
        [self.actionSheetPicker actionPickerCancel];
    }
    
	//Display the ActionSheetPicker
	self.actionSheetPicker = [[ActionSheetPicker initActionPickerWithBarButtonItem:sender datePickerMode:UIDatePickerModeDate selectedDate:self.selectedDate?:[NSDate date] target:self action:@selector(dateWasSelected::) title:@"Select Date"] retain];     
}

- (IBAction)selectAMeasurement:(UIControl *)sender {
    //Display the ActionSheetPicker
    [ActionSheetPicker displayActionPickerWithView:sender 
                                     bigUnitString:@"m" bigUnitMax:330 selectedBigUnit:self.selectedBigUnit 
                                   smallUnitString:@"cm" smallUnitMax:99 selectedSmallUnit:self.selectedSmallUnit
                                            target:self action:@selector(measurementWasSelected:::) title:@"Select Length"];
}

#pragma mark -
#pragma mark Implementation

- (void)itemWasSelected:(NSNumber *)selectedIndex:(id)element {
	//Selection was made
	self.selectedIndex = [selectedIndex intValue];
    if ([element respondsToSelector:@selector(setText:)]) {
        [element setText:[self.animals objectAtIndex:self.selectedIndex]];
    }
}

- (void)dateWasSelected:(NSDate *)selectedDate:(id)element {
	//Date selection was made
	self.selectedDate = selectedDate;
    if ([element respondsToSelector:@selector(setText:)]) {
        [element setText:[self.selectedDate description]];
    }
}

- (void)measurementWasSelected:(NSNumber *)bigUnit:(NSNumber *)smallUnit:(id)element {
    self.selectedBigUnit = [bigUnit intValue];
    self.selectedSmallUnit = [smallUnit intValue];
    [element setText:[NSString stringWithFormat:@"%i m and %i cm", [bigUnit intValue], [smallUnit intValue]]];
}

#pragma mark -
#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
	return NO;
}

#pragma mark -
#pragma mark Memory Management

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}


- (void)dealloc {
	self.animals = nil;
	self.selectedDate = nil;
    
    self.actionSheetPicker = nil;
	
	[super dealloc];
}

@end
