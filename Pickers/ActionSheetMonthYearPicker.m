//
//Copyright (c) 2012, pyanfield@gmail.com
//Extend Tim Cinel's ActionSheetPicker
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
//LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
//ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//

#import "ActionSheetMonthYearPicker.h"

@interface ActionSheetMonthYearPicker()

@property (nonatomic, retain) NSString *startDate;
@property (nonatomic, retain) NSString *endDate;
@property (nonatomic, retain) NSMutableArray *data;
@property (nonatomic, retain) NSMutableArray *years;
@property (nonatomic, retain) UIPickerView *yearPicker;
@property (nonatomic, retain) UIPickerView *monthPicker;
@property (nonatomic, retain) NSString *separator;

- (void)parseData;
- (NSMutableArray*)numbersArrFrom:(int)small toEnd:(int)big;

@end

@implementation ActionSheetMonthYearPicker

@synthesize startDate = _startDate;
@synthesize endDate = _endDate;
@synthesize data = _data;
@synthesize years = _years;
@synthesize yearPicker = _yearPicker;
@synthesize monthPicker = _monthPicker;
@synthesize selectedData = _selectedData;
@synthesize selectedYear = _selectedYear;
@synthesize selectedMonth = _selectedMonth;
@synthesize separator = _separator;

+ (id)showPickerWithTitle:(NSString *)title start:(NSString *)start end:(NSString *)end tartget:(id)target successAction:(SEL)successAction cancelAction:(SEL)cancelAction origin:(id)origin
{
    ActionSheetMonthYearPicker *picker = [[ActionSheetMonthYearPicker alloc] initWithTitle:title start:start end:end tartget:target successAction:successAction cancelAction:cancelAction origin:origin];
    [picker showActionSheetPicker];
    return [picker autorelease];
}

- (id)initWithTitle:(NSString *)title start:(NSString *)start end:(NSString *)end tartget:(id)target successAction:(SEL)successAction cancelAction:(SEL)cancelAction origin:(id)origin
{
    self = [super initWithTarget:target successAction:successAction cancelAction:nil origin:origin];
    if (self) {
        self.title = title;
        _startDate = start;
        _endDate = end;
        _data = [[NSMutableArray alloc] init];
        self.pickers = [[NSMutableArray alloc] init];
        [self parseData];
        self.selectedMonth = [[self.data objectAtIndex:0] objectAtIndex:0];
        self.selectedYear = [self.years objectAtIndex:0];
        self.selectedData = [NSString stringWithFormat:@"%@.%@",self.selectedYear,self.selectedMonth];    }
    return self;
}

- (void)dealloc
{
    [_data release];
    _data = nil;
    [_years release];
    _years = nil;
    [_yearPicker release];
    _yearPicker = nil;
    [_monthPicker release];
    _monthPicker = nil;
    [_selectedData release];
    _selectedData = nil;
    [super dealloc];
}

- (void)parseData
{
    // date string e.g 2012/09 or 2012.09
    NSString *startYear = [self.startDate substringToIndex:4];
    NSString *endYear = [self.endDate substringToIndex:4];
    NSString *startMonth = [self.startDate substringFromIndex:5];
    NSString *endMonth = [self.endDate substringFromIndex:5];
    self.separator = [self.startDate substringWithRange:NSMakeRange(4, 1)];
    if (([startYear isEqualToString:endYear] && [startMonth intValue] >= [endMonth intValue]) || ([startYear intValue] > [endYear intValue])) {
        NSAssert(NO,@"Invalid start date and end date.");
    }
    self.years = [self numbersArrFrom:[startYear intValue] toEnd:[endYear intValue]];
    if ([self.years count] == 1) {
        [self.data addObject:[self numbersArrFrom:[startMonth intValue] toEnd:[endMonth intValue]]];
        return;
    }
    if ([self.years count] > 1) {
        [self.data addObject:[self numbersArrFrom:[startMonth intValue] toEnd:12]];
        for (int i=1; i<[endYear intValue]-[startYear intValue]; i++) {
            [self.data addObject:[self numbersArrFrom:1 toEnd:12]];
        }
        [self.data addObject:[self numbersArrFrom:1 toEnd:[endMonth intValue]]];
        return;
    }
}

- (NSMutableArray*)numbersArrFrom:(int)small toEnd:(int)big
{
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (int i=small; i<=big; i++) {
        [arr addObject:[NSString stringWithFormat:@"%d",i]];
    }
    return [arr autorelease];
}

- (NSMutableArray*)configurePickers
{
    if (!self.data) {
        return nil;
    }
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    CGRect pickerFrame = CGRectMake(0, 40, self.viewSize.width*0.6, 216);
    self.yearPicker = [[UIPickerView alloc] initWithFrame:pickerFrame];
    self.yearPicker.delegate = self;
    self.yearPicker.dataSource = self;
    self.yearPicker.showsSelectionIndicator = YES;
    [arr addObject:self.yearPicker];
    //self.pickerView = yearPicker;
    
    CGRect mFrame = CGRectMake(self.viewSize.width*0.6, 40, self.viewSize.width*0.4, 216);
    self.monthPicker = [[UIPickerView alloc] initWithFrame:mFrame];
    self.monthPicker .delegate = self;
    self.monthPicker .dataSource = self;
    self.monthPicker .showsSelectionIndicator = YES;
    [arr addObject:self.monthPicker ];
    
    return [arr autorelease];
}

- (void)notifyTarget:(id)target didSucceedWithAction:(SEL)successAction origin:(id)origin
{
    if ([target respondsToSelector:successAction])
        //objc_msgSend(target, successAction, self.selectedData, origin);
        [target performSelector:successAction withObject:self.selectedData];
    else
        NSAssert(NO, @"Invalid target/action ( %s / %s ) combination used for ActionSheetPicker", object_getClassName(target), (char *)successAction);
}

#pragma mark - 
#pragma UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if ([pickerView isEqual:self.yearPicker]) {
        return [self.years count];
    }else {
        return [[self.data objectAtIndex:[self.yearPicker selectedRowInComponent:0]] count];
    };
}

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if ([pickerView isEqual:self.yearPicker]) {
        return [self.years objectAtIndex:row];
    }else {
        return [[self.data objectAtIndex:[self.yearPicker selectedRowInComponent:0]] objectAtIndex:row];
    }
}

#pragma mark -
#pragma mark UIPickerViewDelegate

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if ([pickerView isEqual:self.yearPicker]) {
        [self.monthPicker reloadAllComponents];
    }
    //NSLog(@"%@.%@",[self.years objectAtIndex:[self.yearPicker selectedRowInComponent:0]],[[self.data objectAtIndex:[self.yearPicker selectedRowInComponent:0]] objectAtIndex:[self.monthPicker selectedRowInComponent:0]]);
    self.selectedMonth = [[self.data objectAtIndex:[self.yearPicker selectedRowInComponent:0]] objectAtIndex:[self.monthPicker selectedRowInComponent:0]];
    self.selectedYear = [self.years objectAtIndex:[self.yearPicker selectedRowInComponent:0]];
    self.selectedData = [NSString stringWithFormat:@"%@%@%@",self.selectedYear,self.separator,self.selectedMonth];
}

@end
