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
#import "ActionSheetPicker.h"
#import "ActionSheetDistancePicker.h"
#import "ActionSheetDatePicker.h"

@implementation ActionSheetPickerViewController

@synthesize animals = _animals;

@synthesize selectedIndex = _selectedIndex;
@synthesize selectedDate = _selectedDate;
@synthesize selectedBigUnit = _selectedBigUnit;
@synthesize selectedSmallUnit = _selectedSmallUnit;
@synthesize actionSheetPicker = _actionSheetPicker;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.animals = [NSArray arrayWithObjects:@"Aardvark", @"Beaver", @"Cheetah", @"Deer", @"Elephant", @"Frog", @"Gopher", @"Horse", @"Impala", @"...", @"Zebra", nil];
}

- (void)viewDidUnload {
    self.actionSheetPicker = nil;
    [super viewDidUnload];
}

#pragma mark -
#pragma mark IBActions

- (IBAction)selectAnItem:(UIControl *)sender {
    self.actionSheetPicker = [ActionSheetPicker showPickerWithTitle:@"Select Animal" 
                                      rows:self.animals initialSelection:self.selectedIndex 
                                  delegate:self onSuccess:@selector(itemWasSelected::) origin:sender];
}

- (IBAction)selectADate:(UIControl *)sender {
    self.actionSheetPicker = [ActionSheetDatePicker showPickerWithTitle:@"Select Date" 
                datePickerMode:UIDatePickerModeDate selectedDate:self.selectedDate?:[NSDate date]                                                                             
                      delegate:self onSuccess:@selector(dateWasSelected::) origin:sender];
}

- (IBAction)animalButtonTapped:(UIBarButtonItem *)sender {
    if (nil != self.actionSheetPicker) {
        [self.actionSheetPicker actionPickerCancel:sender];
    }
    [self selectAnItem:sender];
}

- (IBAction)dateButtonTapped:(UIBarButtonItem *)sender {
    if (nil != self.actionSheetPicker) {
        [self.actionSheetPicker actionPickerCancel:sender];
    }
    [self selectADate:sender];
}

- (IBAction)selectAMeasurement:(UIControl *)sender {
    self.actionSheetPicker = [ActionSheetDistancePicker showPickerWithTitle:@"Select Length" 
                                                              bigUnitString:@"m" bigUnitMax:330 selectedBigUnit:self.selectedBigUnit
                                                            smallUnitString:@"cm" smallUnitMax:99 selectedSmallUnit:self.selectedSmallUnit
                                                                   delegate:self onSuccess:@selector(measurementWasSelected:::) origin:sender];                                                        
}

#pragma mark -
#pragma mark Implementation

- (void)itemWasSelected:(NSNumber *)selectedIndex:(id)element {
    self.selectedIndex = [selectedIndex intValue];
    if ([element respondsToSelector:@selector(setText:)]) {
        [element setText:[self.animals objectAtIndex:self.selectedIndex]];
    }
}

- (void)dateWasSelected:(NSDate *)selectedDate:(id)element {
    self.selectedDate = selectedDate;
    if ([element respondsToSelector:@selector(setText:)]) {
        [element setText:[self.selectedDate description]];
    }
}

- (void)measurementWasSelected:(NSNumber *)bigUnit:(NSNumber *)smallUnit:(id)element {
    self.selectedBigUnit = [bigUnit intValue];
    self.selectedSmallUnit = [smallUnit intValue];
    [element setText:[NSString stringWithFormat:@"%i m and %i cm", [bigUnit intValue], [smallUnit intValue]]];
}

#pragma mark -
#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return NO;
}

#pragma mark -
#pragma mark Memory Management

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}


- (void)dealloc {
    self.animals = nil;
    self.selectedDate = nil;
    self.actionSheetPicker = nil;
    [super dealloc];
}

@end
