//
//  ActionSheetPicker.m
//	https://github.com/sickanimations/ActionSheetPicker
//  
//  Improvements more than welcome.
//
//  Created by Tim Cinel
//  http://www.timcinel.com/
//

#import "ActionSheetPicker.h"


@implementation ActionSheetPicker

@synthesize view = _view;
@synthesize data = _data;
@synthesize selectedIndex = _selectedIndex;
@synthesize target = _target;
@synthesize action = _action;

@synthesize actionSheet = _actionSheet;
@synthesize pickerView = _pickerView;
@synthesize pickerPosition = _pickerPosition;
@synthesize convenientObject = _convenientObject;

+ (void)displayActionPickerWithView:(UIView *)aView data:(NSArray *)data selectedIndex:(NSInteger)selectedIndex target:(id)target action:(SEL)action {
	ActionSheetPicker *actionSheetPicker = [[ActionSheetPicker alloc] initWithContainingView:aView data:data selectedIndex:selectedIndex target:target action:action];
	actionSheetPicker.convenientObject = YES;
	[actionSheetPicker showActionPicker];
}

- (id)initWithContainingView:(UIView *)aView data:(NSArray *)data selectedIndex:(NSInteger)selectedIndex target:(id)target action:(SEL)action {
	if ((self = [super init]) != nil) {
		self.view = aView;
		self.data = data;
		self.selectedIndex = selectedIndex;
		self.target = target;
		self.action = action;
	}
	return self;
}

#pragma mark -
#pragma mark Implementation

- (void)showActionPicker {
	//spawn actionsheet
	self.actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:nil cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
	[self.actionSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
	
	//spawn pickerview
	CGRect pickerFrame = CGRectMake(0, 40, 0, 0);
	self.pickerView = [[UIPickerView alloc] initWithFrame:pickerFrame];
	
	self.pickerView.delegate = self;
	self.pickerView.dataSource = self;
	self.pickerView.showsSelectionIndicator = YES;
	[self.pickerView selectRow:self.selectedIndex inComponent:0 animated:NO];
	
	[self.actionSheet addSubview:self.pickerView];
	[self.pickerView release];
	
	//spawn segmentedcontrol
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


- (void)actionPickerDone {
		
	[self.actionSheet dismissWithClickedButtonIndex:0 animated:YES];

	[self.target performSelector:self.action withObject:[NSNumber numberWithInt:self.selectedIndex]];
	
	if (self.convenientObject) {
		[self release]; //release convenient object
	}
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
	[self.actionSheet release];
	self.pickerView.delegate = nil;
	self.pickerView.dataSource = nil;
	[self.pickerView release];
	
    [super dealloc];
}

@end
