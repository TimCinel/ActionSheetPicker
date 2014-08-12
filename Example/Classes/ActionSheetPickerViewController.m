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


#import "ActionSheetPickerViewController.h"
#import "NSDate+TCUtils.h"
#import "ActionSheetPickerCustomPickerDelegate.h"
#import "TestTableViewController.h"

@interface ActionSheetPickerViewController()
- (void)measurementWasSelectedWithBigUnit:(NSNumber *)bigUnit smallUnit:(NSNumber *)smallUnit element:(id)element;
- (void)dateWasSelected:(NSDate *)selectedDate element:(id)element;
- (void)animalWasSelected:(NSNumber *)selectedIndex element:(id)element;
@end

@implementation ActionSheetPickerViewController

@synthesize animalTextField = _animalTextField;
@synthesize dateTextField = _dateTextField;

@synthesize animals = _animals;
@synthesize selectedIndex = _selectedIndex;
@synthesize selectedDate = _selectedDate;
@synthesize selectedBigUnit = _selectedBigUnit;
@synthesize selectedSmallUnit = _selectedSmallUnit;
@synthesize actionSheetPicker = _actionSheetPicker;

- (void)viewDidLoad {
    [super viewDidLoad];

    self.animals = [NSArray arrayWithObjects:@"Aardvark", @"Beaver", @"Cheetah", @"Deer", @"Elephant", @"Frog", @"Gopher", @"Horse", @"Impala", @"...", @"Zebra", nil];
    self.selectedDate = [NSDate date];
    self.selectedTime = [NSDate date];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark - IBActions

- (IBAction)selectABlock:(UIControl *)sender {
    ActionStringDoneBlock done = ^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        if ([sender respondsToSelector:@selector(setText:)]) {
            [sender performSelector:@selector(setText:) withObject:selectedValue];
        }
    };
    ActionStringCancelBlock cancel = ^(ActionSheetStringPicker *picker) {
        NSLog(@"Block Picker Canceled");
    };
    NSArray *colors = [NSArray arrayWithObjects:@"Red", @"Green", @"Blue", @"Orange", nil];
    [ActionSheetStringPicker showPickerWithTitle:@"Select a Block" rows:colors initialSelection:0 doneBlock:done cancelBlock:cancel origin:sender];
}

- (IBAction)selectAnAnimal:(UIControl *)sender {
    [ActionSheetStringPicker showPickerWithTitle:@"Select Animal" rows:self.animals initialSelection:self.selectedIndex target:self successAction:@selector(animalWasSelected:element:) cancelAction:@selector(actionPickerCancelled:) origin:sender];
    
 /* Example ActionSheetPicker using customButtons
    self.actionSheetPicker = [[ActionSheetPicker alloc] initWithTitle@"Select Animal" rows:self.animals initialSelection:self.selectedIndex target:self successAction:@selector(itemWasSelected:element:) cancelAction:@selector(actionPickerCancelled:) origin:sender
 
    [self.actionSheetPicker addCustomButtonWithTitle:@"Special" value:[NSNumber numberWithInt:1]];
    self.actionSheetPicker.hideCancel = YES;
    [self.actionSheetPicker showActionSheetPicker];
 */
}

- (IBAction)selectADate:(UIControl *)sender {
    _actionSheetPicker = [[ActionSheetDatePicker alloc] initWithTitle:@"" datePickerMode:UIDatePickerModeDate selectedDate:self.selectedDate target:self action:@selector(dateWasSelected:element:) origin:sender];
    [self.actionSheetPicker addCustomButtonWithTitle:@"Today" value:[NSDate date]];
    [self.actionSheetPicker addCustomButtonWithTitle:@"Yesterday" value:[[NSDate date] TC_dateByAddingCalendarUnits:NSDayCalendarUnit amount:-1]];
    self.actionSheetPicker.hideCancel = YES;
    [self.actionSheetPicker showActionSheetPicker];
}



-(IBAction)selectATime:(id)sender {
    
   
    
    NSInteger minuteInterval = 5;
    //clamp date
    NSInteger referenceTimeInterval = (NSInteger)[self.selectedTime timeIntervalSinceReferenceDate];
    NSInteger remainingSeconds = referenceTimeInterval % (minuteInterval *60);
    NSInteger timeRoundedTo5Minutes = referenceTimeInterval - remainingSeconds;
    if(remainingSeconds>((minuteInterval*60)/2)) {/// round up
        timeRoundedTo5Minutes = referenceTimeInterval +((minuteInterval*60)-remainingSeconds);
    }
    
    self.selectedTime = [NSDate dateWithTimeIntervalSinceReferenceDate:(NSTimeInterval)timeRoundedTo5Minutes];
    
    ActionSheetDatePicker *datePicker = [[ActionSheetDatePicker alloc] initWithTitle:@"Select a time" datePickerMode:UIDatePickerModeTime selectedDate:self.selectedTime target:self action:@selector(timeWasSelected:element:) origin:sender];
    
    
    datePicker.minuteInterval = minuteInterval;
    
    [datePicker showActionSheetPicker];
}


- (IBAction)selectAMeasurement:(UIControl *)sender {
    [ActionSheetDistancePicker showPickerWithTitle:@"Select Length" bigUnitString:@"m" bigUnitMax:330 selectedBigUnit:self.selectedBigUnit smallUnitString:@"cm" smallUnitMax:99 selectedSmallUnit:self.selectedSmallUnit target:self action:@selector(measurementWasSelectedWithBigUnit:smallUnit:element:) origin:sender];
}

- (IBAction)selectAMusicalScale:(UIControl *)sender {
    
    ActionSheetPickerCustomPickerDelegate *delg = [[ActionSheetPickerCustomPickerDelegate alloc] init];
    
    NSNumber *yass1 = [NSNumber numberWithInt:1];
    NSNumber *yass2 = [NSNumber numberWithInt:2];
    
    NSArray *initialSelections = [[NSArray alloc] initWithObjects:yass1, yass2, nil];
    
    [ActionSheetCustomPicker showPickerWithTitle:@"Select Key & Scale" delegate:delg showCancelButton:NO origin:sender
                               initialSelections:initialSelections];
}

- (IBAction)selectLocation:(UITextField *)sender {

}

- (IBAction)showTableView:(id)sender {
    TestTableViewController *tableViewController = [[UIStoryboard storyboardWithName:@"Storyboard"
                                                                              bundle:nil] instantiateViewControllerWithIdentifier:@"TestTableViewController"];
    [self.navigationController pushViewController:tableViewController animated:YES];
}

- (IBAction)dismiss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Implementation

- (void)animalWasSelected:(NSNumber *)selectedIndex element:(id)element {
    self.selectedIndex = [selectedIndex intValue];
    
    //may have originated from textField or barButtonItem, use an IBOutlet instead of element
    self.animalTextField.text = [self.animals objectAtIndex:(NSUInteger) self.selectedIndex];
}

- (void)dateWasSelected:(NSDate *)selectedDate element:(id)element {
    self.selectedDate = selectedDate;
    
    //may have originated from textField or barButtonItem, use an IBOutlet instead of element
    self.dateTextField.text = [self.selectedDate description];
}

-(void)timeWasSelected:(NSDate *)selectedTime element:(id)element {
    self.selectedTime = selectedTime;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"h:mm a"];
    self.timeTextField.text = [dateFormatter stringFromDate:selectedTime];
}

- (void)measurementWasSelectedWithBigUnit:(NSNumber *)bigUnit smallUnit:(NSNumber *)smallUnit element:(id)element {
    self.selectedBigUnit = [bigUnit intValue];
    self.selectedSmallUnit = [smallUnit intValue];
    [element setText:[NSString stringWithFormat:@"%i m and %i cm", [bigUnit intValue], [smallUnit intValue]]];
}

- (void)actionPickerCancelled:(id)sender {
    NSLog(@"Delegate has been informed that ActionSheetPicker was cancelled");
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return NO;
}

@end
