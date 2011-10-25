//
//Copyright (c) 2011, Tim Cinel
//All rights reserved.
//
//Redistribution and use in source and binary forms, with or without
//modification, are permitted provided that the following conditions are met:
//* Redistributions of source code must retain the above copyright
//notice, this list of conditions and the following disclaimer.
//* Redistributions in binary form must reproduce the above copyright
//notice, this list of conditions and the following disclaimer in the
//documentation and/or other materials provided with the distribution.
//* Neither the name of the <organization> nor the
//names of its contributors may be used to endorse or promote products
//derived from this software without specific prior written permission.
//
//THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//DISCLAIMED. IN NO EVENT SHALL <COPYRIGHT HOLDER> BE LIABLE FOR ANY
//DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
// LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
//ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//

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
@property (nonatomic, retain) UIBarButtonItem *barButtonItem;

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

//display actionsheet picker anchored to the specified bar button item, loaded with strings from data, with item selectedIndex selected. On dismissal, [target action:(NSNumber *)selectedIndex:(id)view] is called
+ (id)initActionPickerWithBarButtonItem:(UIBarButtonItem *)aButton data:(NSArray *)data selectedIndex:(NSInteger)selectedIndex target:(id)target action:(SEL)action title:(NSString *)title;

//display actionsheet datepicker in datePickerMode anchored to the specified bar button item with selectedDate selected. On dismissal, [target action:(NSDate *)selectedDate:(id)view] is called
+ (id)initActionPickerWithBarButtonItem:(UIBarButtonItem *)aButton datePickerMode:(UIDatePickerMode)datePickerMode selectedDate:(NSDate *)selectedDate target:(id)target action:(SEL)action title:(NSString *)title;

- (id)initWithContainingView:(UIView *)aView target:(id)target action:(SEL)action;

- (id)initWithBarButtonItem:(UIBarButtonItem *)aButton target:(id)target action:(SEL)action;

- (id)initForDataWithContainingView:(UIView *)aView data:(NSArray *)data selectedIndex:(NSInteger)selectedIndex target:(id)target action:(SEL)action title:(NSString *)title;

- (id)initForDataWithBarButtonItem:(UIBarButtonItem *)aButton data:(NSArray *)data selectedIndex:(NSInteger)selectedIndex target:(id)target action:(SEL)action title:(NSString *)title;

- (id)initForDateWithContainingView:(UIView *)aView datePickerMode:(UIDatePickerMode)datePickerMode selectedDate:(NSDate *)selectedDate target:(id)target action:(SEL)action title:(NSString *)title;

- (id)initForDateWithBarButtonItem:(UIBarButtonItem *)aButton datePickerMode:(UIDatePickerMode)datePickerMode selectedDate:(NSDate *)selectedDate target:(id)target action:(SEL)action title:(NSString *)title;

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
