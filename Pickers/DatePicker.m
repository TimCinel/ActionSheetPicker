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
//LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
//ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//


#import "DatePicker.h"

@interface DatePicker()
@property (nonatomic, assign) UIDatePickerMode datePickerMode;
@property (nonatomic, retain) NSDate *selectedDate;
@end

@implementation DatePicker
@synthesize selectedDate = _selectedDate;
@synthesize datePickerMode = _datePickerMode;

+ (id)showPickerWithTitle:(NSString *)title 
           datePickerMode:(UIDatePickerMode)datePickerMode selectedDate:(NSDate *)selectedDate                                                                             
                 delegate:(id)delegate onSuccess:(SEL)action origin:(id)origin {
    DatePicker *picker = [[[DatePicker alloc] initWithTitle:title 
                                             datePickerMode:datePickerMode selectedDate:selectedDate    
                                                   delegate:delegate onSuccess:action origin:origin] autorelease];
    [picker showActionPicker];
    return picker;
}

- (id)initWithTitle:(NSString *)title 
     datePickerMode:(UIDatePickerMode)datePickerMode selectedDate:(NSDate *)selectedDate 
           delegate:(id)delegate onSuccess:(SEL)action origin:(id)origin {
    self = [super initWithTitle:title rows:nil initialSelection:0 delegate:delegate onSuccess:action origin:origin];
    if (self) {
        self.datePickerMode = datePickerMode;
        self.selectedDate = selectedDate;
    }
    return self;
}

- (void)dealloc {
    self.selectedDate = nil;
    [super dealloc];
}

- (UIView *)configuredPickerView {
    CGRect datePickerFrame = CGRectMake(0, 40, self.viewSize.width, 216);
    UIDatePicker *datePicker = [[[UIDatePicker alloc] initWithFrame:datePickerFrame] autorelease];
    datePicker.datePickerMode = self.datePickerMode;
    [datePicker setDate:self.selectedDate animated:NO];
    [datePicker addTarget:self action:@selector(eventForDatePicker:) forControlEvents:UIControlEventValueChanged];
    return datePicker;
}

- (void)notifyDelegate:(id)delegate didSucceedWithAction:(SEL)action origin:(id)origin {
    if ([delegate respondsToSelector:action])
        [delegate performSelector:action withObject:self.selectedDate withObject:origin];
}

- (void)eventForDatePicker:(id)sender {
    if (sender && [sender isKindOfClass:[UIDatePicker class]]) {
        UIDatePicker *datePicker = (UIDatePicker *)sender;
        self.selectedDate = datePicker.date;
    }
}

@end
