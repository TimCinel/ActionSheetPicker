//
//  ActionSheetPicker.h
//  ActionSheetPicker
//
//  Created by  on 13/03/2012.
//  Copyright (c) 2012 Club 15CC. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "AbstractActionSheetPicker.h"
#import "ActionSheetPickerDelegate.h"

@interface ActionSheetGenericPicker : AbstractActionSheetPicker
{
}

/////////////////////////////////////////////////////////////////////////
#pragma mark - Properties
/////////////////////////////////////////////////////////////////////////
@property (nonatomic, strong) id<ActionSheetPickerDelegate> delegate;


/////////////////////////////////////////////////////////////////////////
#pragma mark - Init Methods
/////////////////////////////////////////////////////////////////////////

/** Designated init */
- (id)initWithTitle:(NSString *)title delegate:(id<ActionSheetPickerDelegate>)delegate doneButtonText:(NSString *)doneButtonText showCancelButton:(BOOL)showCancelButton origin:(id)origin ;

/** Convenience class method for creating an launched */


@end
