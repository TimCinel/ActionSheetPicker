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

#import "AbstractActionSheetPicker.h"
#import "SWActionSheet.h"
#import <objc/message.h>
#import <sys/utsname.h>

BOOL isIPhone4()
{
    struct utsname systemInfo;
    uname(&systemInfo);

    NSString *modelName = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    return ([modelName rangeOfString:@"iPhone3"].location != NSNotFound);
}

#define IS_WIDESCREEN ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

@interface AbstractActionSheetPicker ()

@property(nonatomic, strong) UIBarButtonItem *barButtonItem;
@property(nonatomic, strong) UIBarButtonItem *doneBarButtonItem;
@property(nonatomic, strong) UIBarButtonItem *cancelBarButtonItem;
@property(nonatomic, strong) UIView *containerView;
@property(nonatomic, unsafe_unretained) id target;
@property(nonatomic, assign) SEL successAction;
@property(nonatomic, assign) SEL cancelAction;
@property(nonatomic, strong) SWActionSheet *actionSheet;
@property(nonatomic, strong) UIPopoverController *popOverController;
@property(nonatomic, strong) NSObject *selfReference;

- (void)presentPickerForView:(UIView *)aView;

- (void)configureAndPresentPopoverForView:(UIView *)aView;

- (void)configureAndPresentActionSheetForView:(UIView *)aView;

- (void)presentActionSheet:(SWActionSheet *)actionSheet;

- (void)presentPopover:(UIPopoverController *)popover;

- (void)dismissPicker;

- (BOOL)isViewPortrait;

- (BOOL)isValidOrigin:(id)origin;

- (id)storedOrigin;

- (UIBarButtonItem *)createToolbarLabelWithTitle:(NSString *)aTitle;

- (UIToolbar *)createPickerToolbarWithTitle:(NSString *)aTitle;

- (UIBarButtonItem *)createButtonWithType:(UIBarButtonSystemItem)type target:(id)target action:(SEL)buttonAction;

- (IBAction)actionPickerDone:(id)sender;

- (IBAction)actionPickerCancel:(id)sender;
@end

@implementation AbstractActionSheetPicker

#pragma mark - Abstract Implementation

- (id)initWithTarget:(id)target successAction:(SEL)successAction cancelAction:(SEL)cancelActionOrNil origin:(id)origin
{
    self = [super init];
    if ( self )
    {
        self.target = target;
        self.successAction = successAction;
        self.cancelAction = cancelActionOrNil;
        self.presentFromRect = CGRectZero;

        if ( [origin isKindOfClass:[UIBarButtonItem class]] )
            self.barButtonItem = origin;
        else if ( [origin isKindOfClass:[UIView class]] )
            self.containerView = origin;
        else
            NSAssert(NO, @"Invalid origin provided to ActionSheetPicker ( %@ )", origin);

        // Initialize default bar buttons so they can be overridden before the 'showActionSheetPicker' is called
        UIBarButtonItem *cancelBtn = [self createButtonWithType:UIBarButtonSystemItemCancel target:self
                                                         action:@selector(actionPickerCancel:)];
        [self setCancelBarButtonItem:cancelBtn];
        UIBarButtonItem *doneButton = [self createButtonWithType:UIBarButtonSystemItemDone target:self
                                                          action:@selector(actionPickerDone:)];
        [self setDoneBarButtonItem:doneButton];

        //allows us to use this without needing to store a reference in calling class
        self.selfReference = self;
    }
    return self;
}

- (void)dealloc
{
    //need to clear picker delegates and datasources, otherwise they may call this object after it's gone
    if ( [self.pickerView respondsToSelector:@selector(setDelegate:)] )
        [self.pickerView performSelector:@selector(setDelegate:) withObject:nil];

    if ( [self.pickerView respondsToSelector:@selector(setDataSource:)] )
        [self.pickerView performSelector:@selector(setDataSource:) withObject:nil];

    self.target = nil;

    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (UIView *)configuredPickerView
{
    NSAssert(NO, @"This is an abstract class, you must use a subclass of AbstractActionSheetPicker (like ActionSheetStringPicker)");
    return nil;
}

- (void)notifyTarget:(id)target didSucceedWithAction:(SEL)successAction origin:(id)origin
{
    NSAssert(NO, @"This is an abstract class, you must use a subclass of AbstractActionSheetPicker (like ActionSheetStringPicker)");
}

- (void)notifyTarget:(id)target didCancelWithAction:(SEL)cancelAction origin:(id)origin
{
    if ( target && cancelAction && [target respondsToSelector:cancelAction] )
    {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [target performSelector:cancelAction withObject:origin];
#pragma clang diagnostic pop
    }
}

#pragma mark - Actions

- (void)showActionSheetPicker
{
    UIView *masterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.viewSize.width, 260)];

    // to fix bug, appeared only on iPhone 4 Device: https://github.com/skywinder/ActionSheetPicker-3.0/issues/5
    if ( isIPhone4() )
    {
        masterView.backgroundColor = [UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1.0];
    }
    self.toolbar = [self createPickerToolbarWithTitle:self.title];
    [masterView addSubview:self.toolbar];

    //ios7 picker draws a darkened alpha-only region on the first and last 8 pixels horizontally, but blurs the rest of its background.  To make the whole popup appear to be edge-to-edge, we have to add blurring to the remaining left and right edges.
    if ( NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1 )
    {
        CGRect f = CGRectMake(0, self.toolbar.frame.origin.y, 8, masterView.frame.size.height - self.toolbar.frame.origin.y);
        UIToolbar *leftEdge = [[UIToolbar alloc] initWithFrame:f];
        f.origin.x = masterView.frame.size.width - 8;
        UIToolbar *rightEdge = [[UIToolbar alloc] initWithFrame:f];
#pragma clang diagnostic push
#pragma ide diagnostic ignored "UnavailableInDeploymentTarget"
        leftEdge.barTintColor = rightEdge.barTintColor = self.toolbar.barTintColor;
#pragma clang diagnostic pop
        [masterView insertSubview:leftEdge atIndex:0];
        [masterView insertSubview:rightEdge atIndex:0];
    }

    self.pickerView = [self configuredPickerView];
    NSAssert(_pickerView != NULL, @"Picker view failed to instantiate, perhaps you have invalid component data.");
    [masterView addSubview:_pickerView];
    [self presentPickerForView:masterView];
}

- (IBAction)actionPickerDone:(id)sender
{
    [self notifyTarget:self.target didSucceedWithAction:self.successAction origin:[self storedOrigin]];
    [self dismissPicker];
}

- (IBAction)actionPickerCancel:(id)sender
{
    [self notifyTarget:self.target didCancelWithAction:self.cancelAction origin:[self storedOrigin]];
    [self dismissPicker];
}

- (void)dismissPicker
{
#if __IPHONE_4_1 <= __IPHONE_OS_VERSION_MAX_ALLOWED
    if ( self.actionSheet )
#else
    if (self.actionSheet && [self.actionSheet isVisible])
#endif
        [_actionSheet dismissWithClickedButtonIndex:0 animated:YES];
    else if ( self.popOverController && self.popOverController.popoverVisible )
        [_popOverController dismissPopoverAnimated:YES];
    self.actionSheet = nil;
    self.popOverController = nil;
    self.selfReference = nil;
}

#pragma mark - Custom Buttons

- (void)addCustomButtonWithTitle:(NSString *)title value:(id)value
{
    if ( !self.customButtons )
        _customButtons = [[NSMutableArray alloc] init];
    if ( !title )
        title = @"";
    if ( !value )
        value = @0;
    NSDictionary *buttonDetails = @{
            @"buttonTitle" : title,
            @"buttonValue" : value
    };
    [self.customButtons addObject:buttonDetails];
}

- (IBAction)customButtonPressed:(id)sender
{
    UIBarButtonItem *button = (UIBarButtonItem *) sender;
    NSInteger index = button.tag;
    NSAssert((index >= 0 && index < self.customButtons.count), @"Bad custom button tag: %d, custom button count: %d", index, self.customButtons.count);
    NSAssert([self.pickerView respondsToSelector:@
            selector(selectRow:inComponent:animated:)], @"customButtonPressed not overridden, cannot interact with subclassed pickerView");
    NSDictionary *buttonDetails = (self.customButtons)[(NSUInteger) index];
    NSAssert(buttonDetails != NULL, @"Custom button dictionary is invalid");
    NSInteger buttonValue = [buttonDetails[@"buttonValue"] intValue];
    UIPickerView *picker = (UIPickerView *) self.pickerView;
    NSAssert(picker != NULL, @"PickerView is invalid");
    [picker selectRow:buttonValue inComponent:0 animated:YES];
    if ( [self respondsToSelector:@selector(pickerView:didSelectRow:inComponent:)] )
    {
        void (*objc_msgSendTyped)(id target, SEL _cmd, id pickerView, NSInteger row, NSInteger component) = (void *) objc_msgSend; // sending Integers as params
        objc_msgSendTyped(self, @selector(pickerView:didSelectRow:inComponent:), picker, buttonValue, 0);
    }
}

// Allow the user to specify a custom cancel button
- (void)setCancelButton:(UIBarButtonItem *)button
{
    if ( [button.customView isKindOfClass:[UIButton class]] )
    {
        UIButton *uiButton = (UIButton *) button.customView;
        [uiButton addTarget:self action:@selector(actionPickerCancel:) forControlEvents:UIControlEventTouchUpInside];
    }
    else
    {
        [button setTarget:self];
        [button setAction:@selector(actionPickerCancel:)];
    }
    self.cancelBarButtonItem = button;
}

// Allow the user to specify a custom done button
- (void)setDoneButton:(UIBarButtonItem *)button
{
    if ( [button.customView isKindOfClass:[UIButton class]] )
    {
        UIButton *uiButton = (UIButton *) button.customView;
        [uiButton addTarget:self action:@selector(actionPickerDone:) forControlEvents:UIControlEventTouchUpInside];
    }
    else
    {
        [button setTarget:self];
        [button setAction:@selector(actionPickerDone:)];
    }
    [button setTarget:self];
    [button setAction:@selector(actionPickerDone:)];
    self.doneBarButtonItem = button;
}


- (UIToolbar *)createPickerToolbarWithTitle:(NSString *)title
{
    CGRect frame = CGRectMake(0, 0, self.viewSize.width, 44);
    UIToolbar *pickerToolbar = [[UIToolbar alloc] initWithFrame:frame];
    pickerToolbar.barStyle = (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1) ? UIBarStyleDefault : UIBarStyleBlackTranslucent;

    NSMutableArray *barItems = [[NSMutableArray alloc] init];

    if ( !self.hideCancel )
    {
        [barItems addObject:self.cancelBarButtonItem];
    }

    NSInteger index = 0;
    for (NSDictionary *buttonDetails in self.customButtons)
    {
        NSString *buttonTitle = buttonDetails[@"buttonTitle"];
        //NSInteger buttonValue = [[buttonDetails objectForKey:@"buttonValue"] intValue];
        UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithTitle:buttonTitle style:UIBarButtonItemStyleBordered
                                                                  target:self action:@selector(customButtonPressed:)];
        button.tag = index;
        [barItems addObject:button];
        index++;
    }

    UIBarButtonItem *flexSpace = [self createButtonWithType:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [barItems addObject:flexSpace];
    if ( title )
    {
        UIBarButtonItem *labelButton = [self createToolbarLabelWithTitle:title];
        [barItems addObject:labelButton];
        [barItems addObject:flexSpace];
    }
    [barItems addObject:self.doneBarButtonItem];

    [pickerToolbar setItems:barItems animated:YES];
    return pickerToolbar;
}

- (UIBarButtonItem *)createToolbarLabelWithTitle:(NSString *)aTitle
{
    UILabel *toolBarItemlabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 180, 30)];
    [toolBarItemlabel setTextAlignment:NSTextAlignmentCenter];
    [toolBarItemlabel setTextColor:(NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1) ? [UIColor blackColor] : [UIColor whiteColor]];
    [toolBarItemlabel setFont:[UIFont boldSystemFontOfSize:16]];
    [toolBarItemlabel setBackgroundColor:[UIColor clearColor]];
    toolBarItemlabel.text = aTitle;

    CGFloat strikeWidth;
    CGSize textSize;
    if ( NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1 )
    {
#pragma clang diagnostic push
#pragma ide diagnostic ignored "UnavailableInDeploymentTarget"
        textSize = [[toolBarItemlabel text] sizeWithAttributes:@{NSFontAttributeName : [toolBarItemlabel font]}];
#pragma clang diagnostic pop
    } else
    {
        textSize = [[toolBarItemlabel text] sizeWithFont:[toolBarItemlabel font]];

    }

    strikeWidth = textSize.width;

    if ( strikeWidth < 180 )
    {
        [toolBarItemlabel sizeToFit];
    }

    UIBarButtonItem *buttonLabel = [[UIBarButtonItem alloc] initWithCustomView:toolBarItemlabel];
    return buttonLabel;
}

- (UIBarButtonItem *)createButtonWithType:(UIBarButtonSystemItem)type target:(id)target action:(SEL)buttonAction
{

    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:type target:target
                                                                               action:buttonAction];


#pragma clang diagnostic push
#pragma ide diagnostic ignored "UnavailableInDeploymentTarget"
    if ( NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1 )
        [barButton setTintColor:[[UIApplication sharedApplication] keyWindow].tintColor];
#pragma clang diagnostic pop

    return barButton;
}

#pragma mark - Utilities and Accessors

- (CGSize)viewSize
{
    if ( ![self isViewPortrait] )
        return CGSizeMake(IS_WIDESCREEN ? 568 : 480, 320);
    return CGSizeMake(320 , IS_WIDESCREEN ? 568 : 480);
}

- (BOOL)isViewPortrait
{
    return UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation);
}

- (BOOL)isValidOrigin:(id)origin
{
    if ( !origin )
        return NO;
    BOOL isButton = [origin isKindOfClass:[UIBarButtonItem class]];
    BOOL isView = [origin isKindOfClass:[UIView class]];
    return (isButton || isView);
}

- (id)storedOrigin
{
    if ( self.barButtonItem )
        return self.barButtonItem;
    return self.containerView;
}

#pragma mark - Popovers and ActionSheets

- (void)presentPickerForView:(UIView *)aView
{
    self.presentFromRect = aView.frame;

    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        [self configureAndPresentPopoverForView:aView];
    else
        [self configureAndPresentActionSheetForView:aView];
}

- (void)configureAndPresentActionSheetForView:(UIView *)aView
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didRotate:) name:UIDeviceOrientationDidChangeNotification object:nil];

    _actionSheet = [[SWActionSheet alloc] initWithView:aView];

    [self presentActionSheet:_actionSheet];

    // Use beginAnimations for a smoother popup animation, otherwise the UIActionSheet pops into view
    [UIView beginAnimations:nil context:nil];
//    _actionSheet.bounds = CGRectMake(0, 0, self.viewSize.width, sheetHeight);
    [UIView commitAnimations];
}


- (void) didRotate:(NSNotification *)notification
{
    [self dismissPicker];
}

- (void)presentActionSheet:(SWActionSheet *)actionSheet
{
    NSParameterAssert(actionSheet != NULL);
    if ( self.barButtonItem )
        [actionSheet showFromBarButtonItem:_barButtonItem animated:YES];
        [actionSheet showInContainerView];
}

- (void)configureAndPresentPopoverForView:(UIView *)aView
{
    UIViewController *viewController = [[UIViewController alloc] initWithNibName:nil bundle:nil];
    viewController.view = aView;
    viewController.contentSizeForViewInPopover = viewController.view.frame.size;
    _popOverController = [[UIPopoverController alloc] initWithContentViewController:viewController];
    [self presentPopover:_popOverController];
}

- (void)presentPopover:(UIPopoverController *)popover
{
    NSParameterAssert(popover != NULL);
    if ( self.barButtonItem )
    {
        [popover presentPopoverFromBarButtonItem:_barButtonItem permittedArrowDirections:UIPopoverArrowDirectionAny
                                        animated:YES];
        return;
    }
    else if ( (self.containerView) )
    {
        [popover presentPopoverFromRect:_containerView.bounds inView:_containerView
               permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        return;
    }
    // Unfortunately, things go to hell whenever you try to present a popover from a table view cell.  These are failsafes.
    UIView *origin = nil;
    CGRect presentRect = CGRectZero;
    @try
    {
        origin = (_containerView.superview ? _containerView.superview : _containerView);
        presentRect = origin.bounds;
        [popover presentPopoverFromRect:presentRect inView:origin permittedArrowDirections:UIPopoverArrowDirectionAny
                               animated:YES];
    }
    @catch (NSException *exception)
    {
        origin = [[[[UIApplication sharedApplication] keyWindow] rootViewController] view];
        presentRect = CGRectMake(origin.center.x, origin.center.y, 1, 1);
        [popover presentPopoverFromRect:presentRect inView:origin permittedArrowDirections:UIPopoverArrowDirectionAny
                               animated:YES];
    }
}


@end

