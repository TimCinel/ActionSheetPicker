//
//  ActionSheetPicker.h
//  Spent
//
//  Created by Tim Cinel on 3/01/11.
//  Copyright 2011 Thunderous Playground. All rights reserved.
//
//
//	Easily present an ActionSheet with a PickerView to select from a number of immutible options,
//	based on the drop-down replacement in mobilesafari.
//
//	Some code derived from marcio's post on Stack Overflow [ http://stackoverflow.com/questions/1262574/add-uipickerview-a-button-in-action-sheet-how ]  

#import <Foundation/Foundation.h>


@interface ActionSheetPicker : NSObject <UIPickerViewDelegate, UIPickerViewDataSource> {
	UIView *_view;
	
	NSArray *_data;
	NSInteger _selectedIndex;
  NSString *_title;
	
	UIDatePickerMode _datePickerMode;
	NSDate *_selectedDate;
	
	id _target;
	SEL _action;
	
	UIActionSheet *_actionSheet;
	UIPickerView *_pickerView;
	UIDatePicker *_datePickerView;
	NSInteger _pickerPosition;
	
	BOOL _convenientObject;

}

@property (nonatomic, retain) UIView *view;

@property (nonatomic, retain) NSArray *data;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, copy) NSString *title;

@property (nonatomic, assign) UIDatePickerMode datePickerMode;
@property (nonatomic, retain) NSDate *selectedDate;

@property (nonatomic, retain) id target;
@property (nonatomic, assign) SEL action;

@property (nonatomic, retain) UIActionSheet *actionSheet;
@property (nonatomic, retain) UIPickerView *pickerView;
@property (nonatomic, retain) UIDatePicker *datePickerView;
@property (nonatomic, assign) NSInteger pickerPosition;
@property (nonatomic, assign) BOOL convenientObject;

//no memory management required for convenience methods

//display actionsheet picker inside View, loaded with strings from data, with item selectedIndex selected. On dismissal, [target action:(NSNumber *)selectedIndex] is called
+ (void)displayActionPickerWithView:(UIView *)aView data:(NSArray *)data selectedIndex:(NSInteger)selectedIndex target:(id)target action:(SEL)action;
+ (void)displayActionPickerWithView:(UIView *)aView title:(NSString *)title data:(NSArray *)data selectedIndex:(NSInteger)selectedIndex target:(id)target action:(SEL)action;


//display actionsheet datepicker in datePickerMode inside View with selectedDate selected. On dismissal, [target action:(NSDate *)selectedDate] is called
+ (void)displayActionPickerWithView:(UIView *)aView datePickerMode:(UIDatePickerMode)datePickerMode selectedDate:(NSDate *)selectedDate target:(id)target action:(SEL)action;

- (id)initWithContainingView:(UIView *)aView target:(id)target action:(SEL)action;
- (id)initForDataWithContainingView:(UIView *)aView title:(NSString *)title data:(NSArray *)someData selectedIndex:(NSInteger)index target:(id)target action:(SEL)action;
- (id)initForDateWithContainingView:(UIView *)aView datePickerMode:(UIDatePickerMode)datePickerMode selectedDate:(NSDate *)selectedDate target:(id)target action:(SEL)action;

//implementation
- (void)showActionPicker;
- (void)showDataPicker;
- (void)showDatePicker;

- (void)actionPickerDone;

- (void)eventForDatePicker:(id)sender;

@end
