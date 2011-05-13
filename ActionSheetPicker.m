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
@synthesize title = _title;

@synthesize selectedDate = _selectedDate;
@synthesize datePickerMode = _datePickerMode;

@synthesize target = _target;
@synthesize action = _action;

@synthesize actionSheet = _actionSheet;
@synthesize pickerView = _pickerView;
@synthesize datePickerView = _datePickerView;
@synthesize pickerPosition = _pickerPosition;

@synthesize convenientObject = _convenientObject;

#pragma mark -
#pragma mark NSObject

+ (void)displayActionPickerWithView:(UIView *)aView data:(NSArray *)data selectedIndex:(NSInteger)selectedIndex target:(id)target action:(SEL)action title:(NSString *)title {
	ActionSheetPicker *actionSheetPicker = [[ActionSheetPicker alloc] initForDataWithContainingView:aView data:data selectedIndex:selectedIndex target:target action:action title:title];
	actionSheetPicker.convenientObject = YES;
	[actionSheetPicker showActionPicker];
}

+ (void)displayActionPickerWithView:(UIView *)aView datePickerMode:(UIDatePickerMode)datePickerMode selectedDate:(NSDate *)selectedDate target:(id)target action:(SEL)action title:(NSString *)title{
	ActionSheetPicker *actionSheetPicker = [[ActionSheetPicker alloc] initForDateWithContainingView:aView datePickerMode:datePickerMode selectedDate:selectedDate target:target action:action title:title];
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

- (id)initForDataWithContainingView:(UIView *)aView data:(NSArray *)data selectedIndex:(NSInteger)selectedIndex target:(id)target action:(SEL)action title:(NSString *)title{
	if ([self initWithContainingView:aView target:target action:action] != nil) {
		self.data = data;
		self.selectedIndex = selectedIndex;
		self.title = title;
	}
	return self;
}

- (id)initForDateWithContainingView:(UIView *)aView datePickerMode:(UIDatePickerMode)datePickerMode selectedDate:(NSDate *)selectedDate target:(id)target action:(SEL)action title:(NSString *)title {
	if ([self initWithContainingView:aView target:target action:action] != nil) {
		self.datePickerMode = datePickerMode;
		self.selectedDate = selectedDate;
		self.title = title;
	}
	return self;
}

#pragma mark -
#pragma mark Implementation

- (void)showActionPicker {
	//spawn actionsheet
	_actionSheet = [[UIActionSheet alloc] initWithTitle:[self isViewPortrait]?nil:@"\n\n\n" delegate:nil cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
	[self.actionSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
	
	if (nil != self.data)
		//show data picker
		[self showDataPicker];
	else
		//show date picker
		[self showDatePicker];
	 
	UIToolbar *pickerDateToolbar = [[UIToolbar alloc] initWithFrame:[self isViewPortrait]?CGRectMake(0, 0, 320, 44):CGRectMake(0, 0, 480, 44)];
	pickerDateToolbar.barStyle = UIBarStyleBlackOpaque;
	
	NSMutableArray *barItems = [[NSMutableArray alloc] init];
	
	UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(actionPickerCancel)];
	[barItems addObject:cancelBtn];
	[cancelBtn release];
	
	UIBarButtonItem *flexSpace = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil] autorelease];
	[barItems addObject:flexSpace];
	
	//Add tool bar title label
	if (nil != self.title){
		UILabel *toolBarItemlabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 180,30)];
		
		[toolBarItemlabel setTextAlignment:UITextAlignmentCenter];	
		[toolBarItemlabel setTextColor:[UIColor whiteColor]];	
		[toolBarItemlabel setFont:[UIFont boldSystemFontOfSize:16]];	
		[toolBarItemlabel setBackgroundColor:[UIColor clearColor]];	
		toolBarItemlabel.text = self.title;	
		
		UIBarButtonItem *buttonLabel =[[UIBarButtonItem alloc]initWithCustomView:toolBarItemlabel];
		[toolBarItemlabel release];	
		[barItems addObject:buttonLabel];	
		[buttonLabel release];	
		
		[barItems addObject:flexSpace];
	}
	
	//add "Done" button 	
	UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(actionPickerDone)];
	[barItems addObject:barButton];
	[barButton release];
	
	[pickerDateToolbar setItems:barItems animated:YES];
	[barItems release];
	
	[self.actionSheet addSubview:pickerDateToolbar];
	[pickerDateToolbar release];

	[self.actionSheet showInView:self.view];
	if ( [self isViewPortrait] )
		[self.actionSheet setBounds:CGRectMake(0, 0, 320, 485)];
	else 
		[self.actionSheet setBounds:CGRectMake(0, 0, 480, 325)];
}

- (void)showDataPicker {
	//spawn pickerview
	CGRect pickerFrame = CGRectMake(0, 40, 0, 0);
	_pickerView = [[UIPickerView alloc] initWithFrame:pickerFrame];
	
	self.pickerView.delegate = self;
	self.pickerView.dataSource = self;
	self.pickerView.showsSelectionIndicator = YES;
	[self.pickerView selectRow:self.selectedIndex inComponent:0 animated:NO];
	
	[self.actionSheet addSubview:self.pickerView];
}

- (void)showDatePicker {
	//spawn datepickerview
	CGRect datePickerFrame = CGRectMake(0, 40, 0, 0);
	_datePickerView = [[UIDatePicker alloc] initWithFrame:datePickerFrame];
	self.datePickerView.datePickerMode = self.datePickerMode;
	
	[self.datePickerView setDate:self.selectedDate];
	[self.datePickerView addTarget:self action:@selector(eventForDatePicker:) forControlEvents:UIControlEventValueChanged];
	
	[self.actionSheet addSubview:self.datePickerView];
}

- (void)actionPickerDone {
		
	[self.actionSheet dismissWithClickedButtonIndex:0 animated:YES];
	
	if (nil != self.data) {
		//send data picker message
		[self.target performSelector:self.action withObject:[NSNumber numberWithInt:self.selectedIndex]];
	} else {
		//send date picker message
		[self.target performSelector:self.action withObject:self.selectedDate];
	}
	
	if (self.convenientObject)
		[self release]; //release convenient object
	
}

- (void)actionPickerCancel {
	[self.actionSheet dismissWithClickedButtonIndex:0 animated:YES];
}

- (BOOL) isViewPortrait {
	UIInterfaceOrientation currentOrientation = [UIApplication sharedApplication].statusBarOrientation;
	return (currentOrientation == UIInterfaceOrientationPortrait || currentOrientation == UIInterfaceOrientationPortraitUpsideDown);
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
//	NSLog(@"ActionSheet Dealloc");
	self.actionSheet = nil;
		
	self.pickerView.delegate = nil;
	self.pickerView.dataSource = nil;
	self.pickerView = nil;
	
	[self.datePickerView removeTarget:self action:@selector(eventForDatePicker:) forControlEvents:UIControlEventValueChanged];
	self.datePickerView = nil;
	self.selectedDate = nil;
	
    [super dealloc];
}

@end
