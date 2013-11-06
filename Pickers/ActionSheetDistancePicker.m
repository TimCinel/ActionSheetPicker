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

#import "ActionSheetDistancePicker.h"
#import <objc/message.h>

@interface ActionSheetDistancePicker()
@property (nonatomic, strong) NSString *bigUnitString;
@property (nonatomic, assign) NSInteger selectedBigUnit;
@property (nonatomic, assign) NSInteger bigUnitMax;
@property (nonatomic, assign) NSInteger bigUnitDigits;
@property (nonatomic, strong) NSString *smallUnitString;
@property (nonatomic, assign) NSInteger selectedSmallUnit;
@property (nonatomic, assign) NSInteger smallUnitMax;
@property (nonatomic, assign) NSInteger smallUnitDigits;
@end

@implementation ActionSheetDistancePicker
@synthesize bigUnitString = _bigUnitString;
@synthesize bigUnitMax = _bigUnitMax;
@synthesize bigUnitDigits = _bigUnitDigits;
@synthesize selectedBigUnit = _selectedBigUnit;
@synthesize smallUnitString = _smallUnitString;
@synthesize smallUnitMax = _smallUnitMax;
@synthesize smallUnitDigits = _smallUnitDigits;
@synthesize selectedSmallUnit = _selectedSmallUnit;

+ (id)showPickerWithTitle:(NSString *)title bigUnitString:(NSString *)bigUnitString bigUnitMax:(NSInteger)bigUnitMax selectedBigUnit:(NSInteger)selectedBigUnit smallUnitString:(NSString*)smallUnitString smallUnitMax:(NSInteger)smallUnitMax selectedSmallUnit:(NSInteger)selectedSmallUnit target:(id)target action:(SEL)action origin:(id)origin {
   ActionSheetDistancePicker *picker = [[ActionSheetDistancePicker alloc] initWithTitle:title bigUnitString:bigUnitString bigUnitMax:bigUnitMax selectedBigUnit:selectedBigUnit smallUnitString:smallUnitString smallUnitMax:smallUnitMax selectedSmallUnit:selectedSmallUnit target:target action:action origin:origin];
    [picker showActionSheetPicker];
    return picker;
}

- (id)initWithTitle:(NSString *)title bigUnitString:(NSString *)bigUnitString bigUnitMax:(NSInteger)bigUnitMax selectedBigUnit:(NSInteger)selectedBigUnit smallUnitString:(NSString*)smallUnitString smallUnitMax:(NSInteger)smallUnitMax selectedSmallUnit:(NSInteger)selectedSmallUnit target:(id)target action:(SEL)action origin:(id)origin {
    self = [super initWithTarget:target successAction:action cancelAction:nil origin:origin];
    if (self) {
        self.title = title;
        self.bigUnitString = bigUnitString;
        self.bigUnitMax = bigUnitMax;
        self.selectedBigUnit = selectedBigUnit;
        self.smallUnitString = smallUnitString;
        self.smallUnitMax = smallUnitMax;
        self.selectedSmallUnit = selectedSmallUnit;
        self.bigUnitDigits = [[NSString stringWithFormat:@"%i", self.bigUnitMax] length];
        self.smallUnitDigits = [[NSString stringWithFormat:@"%i", self.smallUnitMax] length];
    }
    return self;
}


- (UIView *)configuredPickerView {
    CGRect distancePickerFrame = CGRectMake(0, 40, self.viewSize.width, 216);
    DistancePickerView *picker = [[DistancePickerView alloc] initWithFrame:distancePickerFrame];
    picker.delegate = self;
    picker.dataSource = self;
    picker.showsSelectionIndicator = YES;
    [picker addLabel:self.bigUnitString forComponent:(self.bigUnitDigits - 1) forLongestString:nil];
    [picker addLabel:self.smallUnitString forComponent:(self.bigUnitDigits + self.smallUnitDigits - 1) forLongestString:nil];
    
    NSInteger unitSubtract = 0;
    NSInteger currentDigit = 0;
    
    for (int i = 0; i < self.bigUnitDigits; ++i) {
        NSInteger factor = (int)pow((double)10, (double)(self.bigUnitDigits - (i+1)));
        currentDigit = (( self.selectedBigUnit - unitSubtract ) / factor )  ;
        [picker selectRow:currentDigit inComponent:i animated:NO];
        unitSubtract += currentDigit * factor;
    }
    
    unitSubtract = 0;
    
    for (int i = self.bigUnitDigits; i < self.bigUnitDigits + self.smallUnitDigits; ++i) {
        NSInteger factor = (int)pow((double)10, (double)(self.bigUnitDigits + self.smallUnitDigits - (i+1)));
        currentDigit = (( self.selectedSmallUnit - unitSubtract ) / factor )  ;
        [picker selectRow:currentDigit inComponent:i animated:NO];
        unitSubtract += currentDigit * factor;
    }
    
    //need to keep a reference to the picker so we can clear the DataSource / Delegate when dismissing
    self.pickerView = picker;
    
    return picker;
}

- (void)notifyTarget:(id)target didSucceedWithAction:(SEL)action origin:(id)origin {
    NSInteger bigUnits = 0;
    NSInteger smallUnits = 0;
    DistancePickerView *picker = (DistancePickerView *)self.pickerView;
    for (int i = 0; i < self.bigUnitDigits; ++i)
        bigUnits += [picker selectedRowInComponent:i] * (int)pow((double)10, (double)(self.bigUnitDigits - (i + 1)));

    for (int i = self.bigUnitDigits; i < self.bigUnitDigits + self.smallUnitDigits; ++i) 
        smallUnits += [picker selectedRowInComponent:i] * (int)pow((double)10, (double)((picker.numberOfComponents - i - 1)));

        //sending three objects, so can't use performSelector:
    if ([target respondsToSelector:action])
        objc_msgSend(target, action, [NSNumber numberWithInt:bigUnits], [NSNumber numberWithInt:smallUnits], origin);
    else
        NSAssert(NO, @"Invalid target/action ( %s / %s ) combination used for ActionSheetPicker", object_getClassName(target), sel_getName(action));
}

#pragma mark -
#pragma mark UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return self.bigUnitDigits + self.smallUnitDigits;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component + 1 <= self.bigUnitDigits) {
        if (component == 0)
            return self.bigUnitMax / (int)pow((double)10, (double)(self.bigUnitDigits - 1)) + 1;
        return 10;
    }
    if (component == self.bigUnitDigits)
        return self.smallUnitMax / (int)pow((double)10, (double)(self.smallUnitDigits - 1)) + 1; 
    return 10;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
     return [NSString stringWithFormat:@"%i", row];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    CGFloat totalWidth = pickerView.frame.size.width - 30;
    CGFloat bigUnitLabelSize = [self.bigUnitString sizeWithFont:[UIFont boldSystemFontOfSize:20]].width;
    CGFloat smallUnitLabelSize = [self.smallUnitString sizeWithFont:[UIFont boldSystemFontOfSize:20]].width;
    CGFloat otherSize = (totalWidth - bigUnitLabelSize - smallUnitLabelSize)/(self.bigUnitDigits + self.smallUnitDigits);
    if (component == self.bigUnitDigits - 1)
        return otherSize + bigUnitLabelSize;
    else if (component == self.bigUnitDigits + self.smallUnitDigits - 1)
        return otherSize + smallUnitLabelSize;
    return otherSize;
}


- (void)customButtonPressed:(id)sender {
    NSLog(@"Not implemented. If you get around to it, please contribute back to the project :)");
}

@end
