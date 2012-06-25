// ActionSheetWeightPicker.m
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

#import "ActionSheetWeightPicker.h"
#import "DistancePickerView.h"

@interface ActionSheetWeightPicker()
@property (nonatomic,retain) NSArray *wholeUnitData;
@property (nonatomic,retain) NSArray *halfUnitData;
@end

@implementation ActionSheetWeightPicker

@synthesize wholeUnitData = _wholeUnitData;
@synthesize halfUnitData = _halfUnitData;
@synthesize selectedWholeUnitIndex = _selectedWholeUnitIndex;
@synthesize selectedHalfUnitIndex = _selectedHalfUnitIndex;
@synthesize onActionWeightSheetDone = _onActionWeightSheetDone;
@synthesize onActionWeightSheetCancel = _onActionWeightSheetCancel;

+ (id)showPickerWithTitle:(NSString *)title initialWholeUnitSelection:(NSInteger)wholeSelectionIndex initialHalfUnitSelection:(NSInteger)halfSelectionIndex doneBlock:(ActionWeightDoneBlock)doneBlock cancelBlock:(ActionWeightCancelBlock)cancelBlockOrNil origin:(id)origin {
    
    ActionSheetWeightPicker *picker = [[ActionSheetWeightPicker alloc] initWithTitle:title initialWholeUnitSelection:wholeSelectionIndex initialHalfUnitSelection:halfSelectionIndex doneBlock:doneBlock cancelBlock:cancelBlockOrNil origin:origin];
    
    [picker showActionSheetPicker];
    return [picker autorelease];
}

- (id)initWithTitle:(NSString *)title initialWholeUnitSelection:(NSInteger)wholeSelectionIndex initialHalfUnitSelection:(NSInteger)halfSelectionIndex doneBlock:(ActionWeightDoneBlock)doneBlock cancelBlock:(ActionWeightCancelBlock)cancelBlockOrNil origin:(id)origin {
    self = [self initWithTitle:title initialWholeUnitSelection:wholeSelectionIndex initialHalfUnitSelection:halfSelectionIndex target:nil successAction:nil cancelAction:nil origin:origin];
    if (self) {
        self.onActionWeightSheetDone    = doneBlock;
        self.onActionWeightSheetCancel  = cancelBlockOrNil;
    }
    return self;
}

- (id)initWithTitle:(NSString *)title initialWholeUnitSelection:(NSInteger)wholeSelectionIndex initialHalfUnitSelection:(NSInteger)halfSelectionIndex target:(id)target successAction:(SEL)successAction cancelAction:(SEL)cancelActionOrNil origin:(id)origin {
    self = [self initWithTarget:target successAction:successAction cancelAction:cancelActionOrNil origin:origin];
    if (self) {
        
        NSMutableArray *weightArr = [NSMutableArray new];
        
        for (int i = 22; i <= 400; i++) {
            [weightArr addObject:[NSString stringWithFormat:@"%d", i]];
        }
        
        self.wholeUnitData = [NSArray arrayWithArray:weightArr];
        self.halfUnitData = [NSArray arrayWithObjects:@".0", @".5", nil];
        self.title = title;
        
        _selectedWholeUnitIndex = wholeSelectionIndex;
        _selectedHalfUnitIndex = halfSelectionIndex;
    }
    return self;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

- (void)notifyTarget:(id)target didSucceedWithAction:(SEL)successAction origin:(id)origin {    
    if (self.onActionWeightSheetDone) {
        
        _selectedWholeUnitIndex = [(UIPickerView*)self.pickerView selectedRowInComponent:0];
        _selectedHalfUnitIndex  = [(UIPickerView*)self.pickerView selectedRowInComponent:1];
        
        int smallestFootVal = [[self.wholeUnitData objectAtIndex:0] intValue];
        int selectedWholeUnit = _selectedWholeUnitIndex + smallestFootVal;
        int selectedHalfUnit = _selectedHalfUnitIndex;
        _onActionWeightSheetDone(self, selectedWholeUnit, selectedHalfUnit);
        return;
    }
    else if (target && [target respondsToSelector:successAction]) {
        [target performSelector:successAction withObject:[NSNumber numberWithInt:self.selectedWholeUnitIndex] withObject:origin];
        return;
    }
    NSLog(@"Invalid target/action ( %s / %s ) combination used for ActionSheetPicker", object_getClassName(target), (char *)successAction);
}

- (void)notifyTarget:(id)target didCancelWithAction:(SEL)cancelAction origin:(id)origin {
    if (self.onActionWeightSheetCancel) {
        _onActionWeightSheetCancel(self);
        return;
    }
    else if (target && cancelAction && [target respondsToSelector:cancelAction])
        [target performSelector:cancelAction withObject:origin];
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return self.wholeUnitData.count;
    } else {
        return self.halfUnitData.count;
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 70, 44)];
    label.opaque = NO;
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor blackColor];
    UIFont *font = [UIFont boldSystemFontOfSize:20];
    label.font = font;
    if(component == 0) {
        label.text = [[self.wholeUnitData objectAtIndex:row] stringByAppendingString:@" "];
        label.textAlignment = UITextAlignmentRight;
    } else if(component == 1) {
        label.text = [@"  " stringByAppendingString: [self.halfUnitData objectAtIndex:row]];
    }
    return [label autorelease];
}

- (UIView *)configuredPickerView {
    CGRect pickerFrame = CGRectMake(0, 40, self.viewSize.width, 216);
    DistancePickerView *stringPicker = [[[DistancePickerView alloc] initWithFrame:pickerFrame] autorelease];
    stringPicker.delegate = self;
    stringPicker.dataSource = self;
    stringPicker.showsSelectionIndicator = YES;
    [stringPicker addLabel:@"lbs" forComponent:1 forLongestString:nil];
    
    [stringPicker selectRow:self.selectedWholeUnitIndex inComponent:0 animated:NO];
    [stringPicker selectRow:self.selectedHalfUnitIndex inComponent:1 animated:NO];
    
    //need to keep a reference to the picker so we can clear the DataSource / Delegate when dismissing
    self.pickerView = stringPicker;
    
    return stringPicker;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return 70.0f;
}

-(void)dealloc
{
    Block_release(_onActionWeightSheetDone);
    Block_release(_onActionWeightSheetCancel);
    
    [super dealloc];
}


@end
