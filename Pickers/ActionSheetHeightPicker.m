// ActionSheetHeightPicker.m
//
// Copyright (c) 2012 Mike Bobiney (http://www.mikebobiney.com/)
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "ActionSheetHeightPicker.h"
#import "DistancePickerView.h"

@interface ActionSheetHeightPicker()
@property (nonatomic,retain) NSArray *feetData;
@property (nonatomic,retain) NSArray *inchData;
@end

@implementation ActionSheetHeightPicker

@synthesize feetData = _feetData;
@synthesize inchData = _inchData;
@synthesize selectedFootIndex = _selectedFootIndex;
@synthesize selectedInchIndex = _selectedInchIndex;
@synthesize onActionHeightSheetDone = _onActionHeightSheetDone;
@synthesize onActionHeightSheetCancel = _onActionHeightSheetCancel;

+ (id)showPickerWithTitle:(NSString *)title initialFootSelection:(NSInteger)footSelectionIndex initialInchSelection:(NSInteger)inchSelectionIndex doneBlock:(ActionHeightDoneBlock)doneBlock cancelBlock:(ActionHeightCancelBlock)cancelBlockOrNil origin:(id)origin {
    ActionSheetHeightPicker *picker = [[ActionSheetHeightPicker alloc] initWithTitle:title initialFootSelection:footSelectionIndex initialInchSelection:inchSelectionIndex doneBlock:doneBlock cancelBlock:cancelBlockOrNil origin:origin];
    [picker showActionSheetPicker];
    return [picker autorelease];
}

- (id)initWithTitle:(NSString *)title initialFootSelection:(NSInteger)footIndex initialInchSelection:(NSInteger)inchIndex doneBlock:(ActionHeightDoneBlock)doneBlock cancelBlock:(ActionHeightCancelBlock)cancelBlockOrNil origin:(id)origin {
    self = [self initWithTitle:title initialFootSelection:footIndex initialInchSelection:inchIndex target:nil successAction:nil cancelAction:nil origin:origin];
    if (self) {
        self.onActionHeightSheetDone    = doneBlock;
        self.onActionHeightSheetCancel  = cancelBlockOrNil;
    }
    return self;
}

- (id)initWithTitle:(NSString *)title initialFootSelection:(NSInteger)footSelectionIndex initialInchSelection:(NSInteger)inchSelectionIndex target:(id)target successAction:(SEL)successAction cancelAction:(SEL)cancelActionOrNil origin:(id)origin {
    self = [self initWithTarget:target successAction:successAction cancelAction:cancelActionOrNil origin:origin];
    if (self) {
        self.feetData = [NSArray arrayWithObjects:@"3", @"4", @"5", @"6", @"7", @"8", nil];
        self.inchData = [NSArray arrayWithObjects:@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"11", nil];
        _selectedFootIndex = footSelectionIndex;
        _selectedInchIndex = inchSelectionIndex;
        self.title = title;
    }
    return self;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if(component == 0) {
        return [self.feetData objectAtIndex:row];
    } else {
        return [self.inchData objectAtIndex:row];
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

- (void)notifyTarget:(id)target didSucceedWithAction:(SEL)successAction origin:(id)origin {    
    if (self.onActionHeightSheetDone) {
        
        _selectedFootIndex = [(UIPickerView*)self.pickerView selectedRowInComponent:0];
        _selectedInchIndex = [(UIPickerView*)self.pickerView selectedRowInComponent:1];
        
        int smallestFootVal = [[self.feetData objectAtIndex:0] intValue];
        int selectedFeet = _selectedFootIndex + smallestFootVal;
        int selectedInches = _selectedInchIndex;
        _onActionHeightSheetDone(self, selectedFeet, selectedInches);
        return;
    }
    else if (target && [target respondsToSelector:successAction]) {
        [target performSelector:successAction withObject:[NSNumber numberWithInt:self.selectedFootIndex] withObject:origin];
        return;
    }
    NSLog(@"Invalid target/action ( %s / %s ) combination used for ActionSheetPicker", object_getClassName(target), (char *)successAction);
}

- (void)notifyTarget:(id)target didCancelWithAction:(SEL)cancelAction origin:(id)origin {
    if (self.onActionHeightSheetCancel) {
        _onActionHeightSheetCancel(self);
        return;
    }
    else if (target && cancelAction && [target respondsToSelector:cancelAction])
        [target performSelector:cancelAction withObject:origin];
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return self.feetData.count;
    } else {
        return self.inchData.count;
    }
}

- (UIView *)configuredPickerView {
    CGRect pickerFrame = CGRectMake(0, 40, self.viewSize.width, 216);
    DistancePickerView *stringPicker = [[[DistancePickerView alloc] initWithFrame:pickerFrame] autorelease];
    stringPicker.delegate = self;
    stringPicker.dataSource = self;
    stringPicker.showsSelectionIndicator = YES;

    [stringPicker addLabel:@"ft " forComponent:0 forLongestString:nil];
    [stringPicker selectRow:self.selectedFootIndex inComponent:0 animated:NO];

    [stringPicker addLabel:@"in" forComponent:1 forLongestString:nil];
    [stringPicker selectRow:self.selectedInchIndex inComponent:1 animated:NO];
    
    //need to keep a reference to the picker so we can clear the DataSource / Delegate when dismissing
    self.pickerView = stringPicker;
    
    return stringPicker;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return 60.0f;
}

-(void)dealloc
{
    Block_release(_onActionHeightSheetDone);
    Block_release(_onActionHeightSheetCancel);
    
    [super dealloc];
}

@end
