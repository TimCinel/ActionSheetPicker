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

#define YEAR_COMPONENT 0
#define MONTH_COMPONENT 1
#define AVAILABLE_COLOR [UIColor blueColor]
#define UNAVAILABLE_COLOR [UIColor lightGrayColor]

@interface ActionSheetMonthYearPicker()

@property (nonatomic, retain) NSString *startDate;
@property (nonatomic, retain) NSString *endDate;
@property (nonatomic, retain) NSMutableArray *data;
@property (nonatomic, retain) NSMutableArray *years;
@property (nonatomic, retain) NSArray *months;
@property (nonatomic, retain) NSString *separator;
@property (nonatomic) int startYearNum;
@property (nonatomic) int endYearNum;
@property (nonatomic) int startMontheNum;
@property (nonatomic) int endMonthNum;

- (void)parseData;

@end

@implementation ActionSheetMonthYearPicker

@synthesize startDate = _startDate;
@synthesize endDate = _endDate;
@synthesize data = _data;
@synthesize years = _years;
@synthesize months = _months;
@synthesize selectedData = _selectedData;
@synthesize selectedYear = _selectedYear;
@synthesize selectedMonth = _selectedMonth;
@synthesize separator = _separator;
@synthesize startMontheNum = _startMontheNum,startYearNum = _startYearNum, endMonthNum = _endMonthNum, endYearNum = _endYearNum;

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
        [self parseData];
    }
    return self;
}

- (void)dealloc
{
    [_data release];
    _data = nil;
    [_years release];
    _years = nil;
    [_selectedData release];
    _selectedData = nil;
    [super dealloc];
}

- (void)parseData
{
    // date string e.g 2012/09 or 2012.09
    _startYearNum = [[self.startDate substringToIndex:4] intValue];
    _startMontheNum = [[self.startDate substringFromIndex:5] intValue];
    _endYearNum = [[self.endDate substringToIndex:4] intValue];
    _endMonthNum = [[self.endDate substringFromIndex:5] intValue];
    
    self.separator = [self.startDate substringWithRange:NSMakeRange(4, 1)];
    if ((_startYearNum == _endYearNum && _startMontheNum >= _endMonthNum) || (_startYearNum > _endYearNum)) {
        NSAssert(NO,@"Invalid start date and end date.");
    }
    self.years = [self yearsFrom:_startYearNum toEnd:_endYearNum];
    self.months = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12"];
    
    // set the default selected value
    self.selectedMonth = self.months[_startMontheNum-1];
    self.selectedYear = [self.years objectAtIndex:0];
    self.selectedData = [NSString stringWithFormat:@"%@.%@",self.selectedYear,self.selectedMonth];
}

- (NSMutableArray*)yearsFrom:(int)small toEnd:(int)big
{
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (int i=small; i<=big; i++) {
        [arr addObject:[NSString stringWithFormat:@"%d",i]];
    }
    return [arr autorelease];
}

- (UIView *)configuredPickerView {
    if (!self.data)
        return nil;
    CGRect pickerFrame = CGRectMake(0, 40, self.viewSize.width, 216);
    UIPickerView *yearPicker = [[[UIPickerView alloc] initWithFrame:pickerFrame] autorelease];
    yearPicker.delegate = self;
    yearPicker.dataSource = self;
    yearPicker.showsSelectionIndicator = YES;
    self.pickerView = yearPicker;
    
    // set the year and month default value to init picker view
    [yearPicker selectRow:0 inComponent:YEAR_COMPONENT animated:YES];
    [yearPicker selectRow:(_startMontheNum-1) inComponent:MONTH_COMPONENT animated:YES];
    
    return yearPicker;
}

- (void)notifyTarget:(id)target didSucceedWithAction:(SEL)successAction origin:(id)origin
{
    if ([target respondsToSelector:successAction])
        //objc_msgSend(target, successAction, self.selectedData, origin);
        [target performSelector:successAction withObject:self.selectedData];
    else
        NSAssert(NO, @"Invalid target/action ( %s / %s ) combination used for ActionSheetPicker", object_getClassName(target), (char *)successAction);
}

-(UILabel *)componentLabel
{
    CGRect frame = CGRectMake(0.f, 0.f,self.pickerView.bounds.size.width/2,43);
    UILabel *label = [[[UILabel alloc] initWithFrame:frame] autorelease];
    label.textAlignment = UITextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.textColor = AVAILABLE_COLOR;
    label.font = [UIFont boldSystemFontOfSize:17];
    label.userInteractionEnabled = NO;
    return label;
}

#pragma mark - 
#pragma UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == YEAR_COMPONENT) {
        return [self.years count];
    }
    return 12;
}


#pragma mark -
#pragma mark UIPickerViewDelegate

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [pickerView reloadComponent:MONTH_COMPONENT];
    
    int monthCurrentIndex = [pickerView selectedRowInComponent:MONTH_COMPONENT];
    self.selectedYear = [self.years objectAtIndex:[pickerView selectedRowInComponent:YEAR_COMPONENT]];
    if ([self.selectedYear intValue] == self.startYearNum && monthCurrentIndex < self.startMontheNum-1) {
        [pickerView selectRow:(self.startMontheNum-1) inComponent:MONTH_COMPONENT animated:YES];
    }else if ([self.selectedYear intValue] == self.endYearNum && monthCurrentIndex > self.endMonthNum-1){
        [pickerView selectRow:(self.endMonthNum-1) inComponent:MONTH_COMPONENT animated:YES];
    }
    
    self.selectedMonth = self.months[[pickerView selectedRowInComponent:MONTH_COMPONENT]];
    self.selectedYear = [self.years objectAtIndex:[pickerView selectedRowInComponent:YEAR_COMPONENT]];
    self.selectedData = [NSString stringWithFormat:@"%@%@%@",self.selectedYear,self.separator,self.selectedMonth];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *componentView = nil;
    if(view){
        componentView = (UILabel *)view;
    }else{
        componentView = [self componentLabel];
    }
    
    if (component == YEAR_COMPONENT) {
        componentView.text = [self.years objectAtIndex:row];
        return componentView;
    }else{
        if ([pickerView selectedRowInComponent:YEAR_COMPONENT] != -1) {
            self.selectedYear = [self.years objectAtIndex:[pickerView selectedRowInComponent:YEAR_COMPONENT]];
        }
        if ([self.selectedYear intValue] == self.startYearNum || [self.selectedYear intValue] == self.endYearNum) {
            if (([self.selectedYear intValue] == self.startYearNum && row < self.startMontheNum-1) || ([self.selectedYear intValue] == self.endYearNum && row > self.endMonthNum-1)) {
                componentView.textColor = UNAVAILABLE_COLOR;
            }else{
                componentView.textColor = AVAILABLE_COLOR;
            }
        }else{
            componentView.textColor = AVAILABLE_COLOR;
        }
        
        componentView.text = self.months[row];
        return componentView;
    }
}

@end
