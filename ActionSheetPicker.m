//
//  ActionSheetPicker.m
//  Spent
//
//  Created by Tim Cinel on 3/01/11.
//  Copyright 2011 Thunderous Playground. All rights reserved.
//

#import "ActionSheetPicker.h"


@implementation ActionSheetPicker

@synthesize view = _view;

@synthesize data = _data;
@synthesize selectedIndex = _selectedIndex;

@synthesize selectedDate = _selectedDate;
@synthesize datePickerMode = _datePickerMode;

@synthesize target = _target;
@synthesize action = _action;

@synthesize actionSheet = _actionSheet;
@synthesize pickerView = _pickerView;
@synthesize datePickerView = _datePickerView;
@synthesize pickerPosition = _pickerPosition;

@synthesize convenientObject = _convenientObject;

+ (void)displayActionPickerWithView:(UIView *)aView data:(NSArray *)data selectedIndex:(NSInteger)selectedIndex target:(id)target action:(SEL)action {
	ActionSheetPicker *actionSheetPicker = [[ActionSheetPicker alloc] initForDataWithContainingView:aView data:data selectedIndex:selectedIndex target:target action:action];
	actionSheetPicker.convenientObject = YES;
	[actionSheetPicker showActionPicker];
}

+ (void)displayActionPickerWithView:(UIView *)aView datePickerMode:(UIDatePickerMode)datePickerMode selectedDate:(NSDate *)selectedDate target:(id)target action:(SEL)action {
	ActionSheetPicker *actionSheetPicker = [[ActionSheetPicker alloc] initForDateWithContainingView:aView datePickerMode:datePickerMode selectedDate:selectedDate target:target action:action];
	actionSheetPicker.convenientObject = YES;
	[actionSheetPicker showActionPicker];
}


- (id)initWithContainingView:(UIView *)aView target:(id)target action:(SEL)action {
	if ((self = [super init]) != nil) {
		self.view = aView;
		self.target = target;
		self.action = action;
	}
	return self;
}

- (id)initForDataWithContainingView:(UIView *)aView data:(NSArray *)data selectedIndex:(NSInteger)selectedIndex target:(id)target action:(SEL)action {
	if ([self initWithContainingView:aView target:target action:action] != nil) {
		self.data = data;
		self.selectedIndex = selectedIndex;
	}
	return self;
}

- (id)initForDateWithContainingView:(UIView *)aView datePickerMode:(UIDatePickerMode)datePickerMode selectedDate:(NSDate *)selectedDate target:(id)target action:(SEL)action {
	if ([self initWithContainingView:aView target:target action:action] != nil) {
		self.datePickerMode = datePickerMode;
		self.selectedDate = selectedDate;
	}
	return self;
}


#pragma mark -
#pragma mark Implementation

- (void)showActionPicker {
	//spawn actionsheet
	self.actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:nil cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
	[self.actionSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
	
	if (nil != self.data)
		//show data picker
		[self showDataPicker];
	else
		//show date picker
		[self showDatePicker];
	
	//spawn segmentedcontrol (faux done button)
	UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObject:@"Done"]];
	
	segmentedControl.momentary = YES;
	segmentedControl.frame = CGRectMake(260, 7, 50, 30);
	segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
	segmentedControl.tintColor = [UIColor blackColor];
	
	[segmentedControl addTarget:self action:@selector(actionPickerDone) forControlEvents:UIControlEventValueChanged];
	
	[self.actionSheet addSubview:segmentedControl];
	[segmentedControl release];

	[self.actionSheet showInView:self.view];
	[self.actionSheet setBounds:CGRectMake(0, 0, 320, 485)];
}

- (void)showDataPicker {
	//spawn pickerview
	CGRect pickerFrame = CGRectMake(0, 40, 0, 0);
	self.pickerView = [[UIPickerView alloc] initWithFrame:pickerFrame];
	
	self.pickerView.delegate = self;
	self.pickerView.dataSource = self;
	self.pickerView.showsSelectionIndicator = YES;
	[self.pickerView selectRow:self.selectedIndex inComponent:0 animated:NO];
	
	[self.actionSheet addSubview:self.pickerView];
	self.pickerView = nil;
}

- (void)showDatePicker {
	//spawn datepickerview
	CGRect datePickerFrame = CGRectMake(0, 40, 0, 0);
	self.datePickerView = [[UIDatePicker alloc] initWithFrame:datePickerFrame];
	self.datePickerView.datePickerMode = self.datePickerMode;
	
	[self.datePickerView setDate:self.selectedDate];
	[self.datePickerView addTarget:self action:@selector(eventForDatePicker:) forControlEvents:UIControlEventValueChanged];
	
	[self.actionSheet addSubview:self.datePickerView];
	self.datePickerView = nil;
}

- (void)actionPickerDone {
		
	[self.actionSheet dismissWithClickedButtonIndex:0 animated:YES];
	
	if (nil != self.data) 
		//send data picker message
		[self.target performSelector:self.action withObject:[NSNumber numberWithInt:self.selectedIndex]];
	else 
		//send date picker message
		[self.target performSelector:self.action withObject:self.selectedDate];
	
	if (self.convenientObject)
		[self release]; //release convenient object
	
}

#pragma mark -
#pragma mark Callbacks 
	 
- (void)eventForDatePicker:(id)sender {
	UIDatePicker *datePicker = (UIDatePicker *)sender;
	
	self.selectedDate = datePicker.date;
}
	 
#pragma mark -
#pragma mark UIPickerViewDelegate

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
	self.selectedIndex = row;
}

#pragma mark -
#pragma mark UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
	return self.data.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	return [self.data objectAtIndex:row];
}

#pragma mark -
#pragma mark Memory Management


- (void)dealloc {
	self.actionSheet = nil;
	
	self.pickerView.delegate = nil;
	self.pickerView.dataSource = nil;
	self.pickerView = nil;
	
	self.datePickerView = nil;
	self.selectedDate = nil;
	
    [super dealloc];
}

@end
