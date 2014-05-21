//
//  ActionSheetPickerCustomPickerDelegate.m
//  ActionSheetPicker
//
//  Created by  on 13/03/2012.
//  Copyright (c) 2012 Club 15CC. All rights reserved.
//

#import "ActionSheetPickerCustomPickerDelegate.h"

@implementation ActionSheetPickerCustomPickerDelegate

@synthesize selectedKey, selectedScale;

- (id)init 
{
    if (self = [super init]) {
        notesToDisplayForKey = [NSArray arrayWithObjects: @"C", @"Db", @"D", @"Eb", @"E", @"F", @"Gb", @"G", @"Ab", @"A", @"Bb", @"B", nil];
        scaleNames = [NSArray arrayWithObjects: @"Major", @"Minor", @"Dorian", @"Spanish Gypsy", nil]; 
    }
    return self;
}

/////////////////////////////////////////////////////////////////////////
#pragma mark - ActionSheetCustomPickerDelegate Optional's 
/////////////////////////////////////////////////////////////////////////
- (void)configurePickerView:(UIPickerView *)pickerView
{
    // Override default and hide selection indicator
    pickerView.showsSelectionIndicator = NO;
}

- (void)actionSheetPickerDidSucceed:(AbstractActionSheetPicker *)actionSheetPicker origin:(id)origin
{
    NSString *resultMessage = [NSString stringWithFormat:@"%@ %@ selected.", self.selectedKey, self.selectedScale, nil];
    
    [[[UIAlertView alloc] initWithTitle:@"Success!" message:resultMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
}

/////////////////////////////////////////////////////////////////////////
#pragma mark - UIPickerViewDataSource Implementation
/////////////////////////////////////////////////////////////////////////

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView 
{ 
    return 2; 
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{ 
    // Returns
    switch (component) {
        case 0: return [notesToDisplayForKey count];
        case 1: return [scaleNames count];
    }
    return 0;
}

/////////////////////////////////////////////////////////////////////////
#pragma mark UIPickerViewDelegate Implementation
/////////////////////////////////////////////////////////////////////////

// returns width of column and height of row for each component. 
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    switch (component) {
        case 0: return 60.0f;
        case 1: return 260.0f;
    }
    
    return 0;
}
/*- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component 
 {
 return 
 }
 */
// these methods return either a plain UIString, or a view (e.g UILabel) to display the row for the component.
// for the view versions, we cache any hidden and thus unused views and pass them back for reuse. 
// If you return back a different object, the old one will be released. the view will be centered in the row rect  
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    switch (component) {
        case 0: return [notesToDisplayForKey objectAtIndex:row];
        case 1: return [scaleNames objectAtIndex:row];
    }
    return nil;
}

/////////////////////////////////////////////////////////////////////////

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSLog(@"Row %i selected in component %i", row, component);
    switch (component) {
        case 0:
            selectedKey = [notesToDisplayForKey objectAtIndex:row];
            return;
            
        case 1:
            selectedScale = [scaleNames objectAtIndex:row];
            return;
    }
}

@end
