//
//  ActionSheetPicker.m
//  ActionSheetPicker
//
//  Created by  on 13/03/2012.
//  Copyright (c) 2012 Club 15CC. All rights reserved.
//

#import "ActionSheetCustomPicker.h"

@interface ActionSheetCustomPicker ()
@property(nonatomic, strong) NSArray *initialSelections;
@end

@implementation ActionSheetCustomPicker

/////////////////////////////////////////////////////////////////////////
#pragma mark - Init
/////////////////////////////////////////////////////////////////////////

- (id)initWithTitle:(NSString *)title delegate:(id <ActionSheetCustomPickerDelegate>)delegate showCancelButton:(BOOL)showCancelButton origin:(id)origin
{
    if ( self = [self initWithTarget:nil successAction:nil cancelAction:nil origin:origin] )
    {;

        self.title = title;
        self.hideCancel = !showCancelButton;
        _delegate = delegate;
    }

    return self;
}

+ (id)showPickerWithTitle:(NSString *)title delegate:(id <ActionSheetCustomPickerDelegate>)delegate showCancelButton:(BOOL)showCancelButton origin:(id)origin
{
    return [self showPickerWithTitle:title origin:origin delegate:delegate showCancelButton:showCancelButton
                   initialSelections:nil ];
}

- (id)initWithTitle:(NSString *)title origin:(id)origin delegate:(id <ActionSheetCustomPickerDelegate>)delegate showCancelButton:(BOOL)showCancelButton initialSelections:(NSArray *)initialSelections
{
    if ( self = [self initWithTitle:title delegate:delegate
                   showCancelButton:showCancelButton origin:origin] )
    {;
        self.initialSelections = [[NSArray alloc] initWithArray:initialSelections];
    }
    return self;
}

/////////////////////////////////////////////////////////////////////////

+ (id)showPickerWithTitle:(NSString *)title origin:(id)origin delegate:(id <ActionSheetCustomPickerDelegate>)delegate showCancelButton:(BOOL)showCancelButton initialSelections:(NSArray *)initialSelections
{
    ActionSheetCustomPicker *picker = [[ActionSheetCustomPicker alloc] initWithTitle:title origin:origin
                                                                            delegate:delegate
                                                                    showCancelButton:showCancelButton
                                                                   initialSelections:initialSelections];
    [picker showActionSheetPicker];
    return picker;
}

/////////////////////////////////////////////////////////////////////////
#pragma mark - AbstractActionSheetPicker fulfilment
/////////////////////////////////////////////////////////////////////////

- (UIView *)configuredPickerView
{
    CGRect pickerFrame = CGRectMake(0, 40, self.viewSize.width, 216);
    UIPickerView *pv = [[UIPickerView alloc] initWithFrame:pickerFrame];

    // Default to our delegate being the picker's delegate and datasource
    pv.delegate = _delegate;
    pv.dataSource = _delegate;
    pv.showsSelectionIndicator = YES;

    if ( self.initialSelections )
    {
        NSAssert(pv.numberOfComponents == self.initialSelections.count, @"Number of sections not match");
        for (NSUInteger i = 0; i < [self.initialSelections count]; i++)
        {

            NSInteger row = [(NSNumber *) self.initialSelections[i] integerValue];
            NSAssert([pv numberOfRowsInComponent:i] > row, @"Number of sections not match");
            [pv selectRow:row inComponent:i animated:NO];
        }

    }

    // Allow the delegate to override and set additional configs
    //to backward compatibility:
    if ( [_delegate respondsToSelector:@selector(actionSheetPicker:configurePickerView:)] )
    {
        [_delegate actionSheetPicker:self configurePickerView:pv];
    }
    self.pickerView = pv;
    return pv;
}


/////////////////////////////////////////////////////////////////////////

- (void)notifyTarget:(id)target didSucceedWithAction:(SEL)successAction origin:(id)origin
{
    // Ignore parent args and just notify the delegate
    if ( [_delegate respondsToSelector:@selector(actionSheetPickerDidSucceed:origin:)] )
    {
        [_delegate actionSheetPickerDidSucceed:self origin:origin];
    }
}

/////////////////////////////////////////////////////////////////////////

- (void)notifyTarget:(id)target didCancelWithAction:(SEL)cancelAction origin:(id)origin
{
    // Ignore parent args and just notify the delegate
    if ( [_delegate respondsToSelector:@selector(actionSheetPickerDidCancel:origin:)] )
    {
        [_delegate actionSheetPickerDidCancel:self origin:origin];
    }
}


@end
