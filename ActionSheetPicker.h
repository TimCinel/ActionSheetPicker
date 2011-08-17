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
#import "DistancePickerView.h"

@interface ActionSheetPicker : NSObject <UIPickerViewDelegate, UIPickerViewDataSource> {
	UIView *_view;
	
	NSArray *_data;
	NSInteger _selectedIndex;
	NSString *_title;
	
	UIDatePickerMode _datePickerMode;
	NSDate *_selectedDate;
    
    BOOL _isMeasurement;
    NSString *_bigUnitString;
    NSInteger _selectedBigUnit;
    NSInteger _bigUnitMax;
    NSInteger _bigUnitDigits;
    NSString *_smallUnitString;
    NSInteger _selectedSmallUnit;
    NSInteger _smallUnitMax;
    NSInteger _smallUnitDigits;
	
	id _target;
	SEL _action;
	
	UIActionSheet *_actionSheet;
	UIPopoverController *_popOverController;
	UIPickerView *_pickerView;
	UIDatePicker *_datePickerView;
    DistancePickerView *_distancePickerView;
	NSInteger _pickerPosition;
}

@property (nonatomic, retain) UIView *view;

@property (nonatomic, retain) NSArray *data;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, copy) NSString *title;

@property (nonatomic, assign) UIDatePickerMode datePickerMode;
@property (nonatomic, retain) NSDate *selectedDate;

@property (nonatomic, retain) NSString *bigUnitString;
@property (nonatomic, assign) NSInteger selectedBigUnit;
@property (nonatomic, assign) NSInteger bigUnitMax;
@property (nonatomic, assign) NSInteger bigUnitDigits;
@property (nonatomic, retain) NSString *smallUnitString;
@property (nonatomic, assign) NSInteger selectedSmallUnit;
@property (nonatomic, assign) NSInteger smallUnitMax;
@property (nonatomic, assign) NSInteger smallUnitDigits;

@property (nonatomic, retain) id target;
@property (nonatomic, assign) SEL action;

@property (nonatomic, retain) UIActionSheet *actionSheet;
@property (nonatomic, retain) UIPopoverController *popOverController;
@property (nonatomic, retain) UIPickerView *pickerView;
@property (nonatomic, retain) UIDatePicker *datePickerView;
@property (nonatomic, retain) DistancePickerView *distancePickerView;
@property (nonatomic, assign) NSInteger pickerPosition;

@property (nonatomic, readonly) CGSize viewSize;

//no memory management required for convenience methods

//display actionsheet picker inside View, loaded with strings from data, with item selectedIndex selected. On dismissal, [target action:(NSNumber *)selectedIndex:(id)view] is called
+ (void)displayActionPickerWithView:(UIView *)aView data:(NSArray *)data selectedIndex:(NSInteger)selectedIndex target:(id)target action:(SEL)action title:(NSString *)title;

//display actionsheet datepicker in datePickerMode inside View with selectedDate selected. On dismissal, [target action:(NSDate *)selectedDate:(id)view] is called
+ (void)displayActionPickerWithView:(UIView *)aView datePickerMode:(UIDatePickerMode)datePickerMode selectedDate:(NSDate *)selectedDate target:(id)target action:(SEL)action title:(NSString *)title;

+ (void)displayActionPickerWithView:(UIView *)aView 
                      bigUnitString:(NSString *)bigUnitString  
                         bigUnitMax:(NSInteger)bigUnitMax
                    selectedBigUnit:(NSInteger)selectedBigUnit 
                    smallUnitString:(NSString*)smallUnitString 
                       smallUnitMax:(NSInteger)smallUnitMax
                  selectedSmallUnit:(NSInteger)selectedSmallUnit
                             target:(id)target
                             action:(SEL)action 
                              title:(NSString*)title;

- (id)initWithContainingView:(UIView *)aView target:(id)target action:(SEL)action;

- (id)initForDataWithContainingView:(UIView *)aView data:(NSArray *)data selectedIndex:(NSInteger)selectedIndex target:(id)target action:(SEL)action title:(NSString *)title;

- (id)initForDateWithContainingView:(UIView *)aView datePickerMode:(UIDatePickerMode)datePickerMode selectedDate:(NSDate *)selectedDate target:(id)target action:(SEL)action title:(NSString *)title;

- (id)initForMeasurementWithContainingView:(UIView *)aView 
                             bigUnitString:(NSString *)bigUnitString 
                                bigUnitMax:(NSInteger)bigUnitMax
                           selectedBigUnit:(NSInteger)selectedBigUnit 
                           smallUnitString:(NSString*)smallUnitString 
                              smallUnitMax:(NSInteger)smallUnitMax
                         selectedSmallUnit:(NSInteger)selectedSmallUnit
                                    target:(id)target
                                    action:(SEL)action 
                                     title:(NSString*)title;

//implementation
- (void)showActionPicker;
- (void)showDataPicker;
- (void)showDatePicker;
- (void)showDistancePicker;

- (void)actionPickerDone;
- (void)actionPickerCancel;

- (void)eventForDatePicker:(id)sender;

- (BOOL)isViewPortrait;

@end
