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


#import "ActionSheetPicker.h"

@interface ActionSheetPicker()
@property (nonatomic, retain) UIBarButtonItem *barButtonItem;
@property (nonatomic, retain) NSArray *data;
@property (nonatomic, retain) UIView *containerView;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) id delegate;
@property (nonatomic, assign) SEL action;
@property (nonatomic, retain) UIActionSheet *actionSheet;
@property (nonatomic, retain) UIPopoverController *popOverController;
- (ActionSheetPicker *)initWithDelegate:(id)delegate onSuccess:(SEL)action origin:(id)origin;

- (void)presentPickerForView:(UIView *)aView;
- (void)configureAndPresentPopoverForView:(UIView *)aView;
- (void)configureAndPresentActionSheetForView:(UIView *)aView;
- (void)presentActionSheet:(UIActionSheet *)actionSheet;
- (void)presentPopover:(UIPopoverController *)popover;
- (void)dismissPicker;
- (BOOL)isViewPortrait;
- (BOOL)isValidOrigin:(id)origin;
- (id)storedOrigin;
- (UIBarButtonItem *)createToolbarLabelWithTitle:(NSString *)aTitle;
- (UIToolbar *)createPickerToolbarWithTitle:(NSString *)aTitle;
- (UIBarButtonItem *)createButtonWithType:(UIBarButtonSystemItem)type target:(id)target action:(SEL)buttonAction;
@end

@implementation ActionSheetPicker

@synthesize containerView = _containerView;
@synthesize barButtonItem = _barButtonItem;
@synthesize data = _data;
@synthesize selectedIndex = _selectedIndex;
@synthesize title = _title;
@synthesize delegate = _delegate;
@synthesize action = _action;
@synthesize actionSheet = _actionSheet;
@synthesize popOverController = _popOverController;
@synthesize pickerView = _pickerView;
@dynamic viewSize;

#pragma mark -
#pragma mark NSObject


+ (id)showPickerWithTitle:(NSString *)title rows:(NSArray *)data initialSelection:(NSInteger)index delegate:(id)delegate onSuccess:(SEL)action origin:(id)origin {
    ActionSheetPicker *picker = [[[ActionSheetPicker alloc] initWithTitle:title rows:data initialSelection:index delegate:delegate onSuccess:action origin:origin] autorelease];
    [picker showActionPicker];
    return picker;
}

- (ActionSheetPicker *)initWithDelegate:(id)delegate onSuccess:(SEL)action origin:(id)origin  {
    NSParameterAssert( (origin != NULL) && (delegate != NULL) );
    self = [super init];
    if (self) {
        self.delegate = delegate;
        self.action = action;
        if ([origin isKindOfClass:[UIBarButtonItem class]])
            self.barButtonItem = origin;
        else if ([origin isKindOfClass:[UIView class]])
            self.containerView = origin;
    }
    return self;
}

- (id)initWithTitle:(NSString *)title rows:(NSArray *)data initialSelection:(NSInteger)index delegate:(id)delegate onSuccess:(SEL)action origin:(id)origin {
    NSParameterAssert( (origin != NULL) && (delegate != NULL) );
    self = [self initWithDelegate:delegate onSuccess:action origin:origin];
    if (self) {
        self.data = data;
        self.selectedIndex = index;
        self.title = title;
    }
    return self;
}

- (void)dealloc {
    self.actionSheet = nil;
    self.popOverController = nil;
    self.data = nil;
    self.pickerView = nil;
    self.containerView = nil;
    self.barButtonItem = nil;
    self.delegate = nil;
    [super dealloc];
}

#pragma mark -
#pragma mark Implementation

- (UIView *)configuredPickerView {
    if (!self.data)
        return nil;
    CGRect pickerFrame = CGRectMake(0, 40, self.viewSize.width, 216);
    UIPickerView *stringPicker = [[[UIPickerView alloc] initWithFrame:pickerFrame] autorelease];
    stringPicker.delegate = self;
    stringPicker.dataSource = self;
    stringPicker.showsSelectionIndicator = YES;
    [stringPicker selectRow:self.selectedIndex inComponent:0 animated:NO];
    return stringPicker;
}

- (void)showActionPicker {    
    UIView *masterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.viewSize.width, 260)];    
    UIToolbar *pickerToolbar = [self createPickerToolbarWithTitle:self.title];
    [masterView addSubview:pickerToolbar];
    [pickerToolbar release];
    self.pickerView = [self configuredPickerView];
    NSAssert(_pickerView != NULL, @"Picker view failed to instantiate, perhaps you have invalid component data.");
    [masterView addSubview:_pickerView];
    [self presentPickerForView:masterView];
    [masterView release];
}

    // subclasses should override this for custom behavior
- (void)notifyDelegate:(id)delegate didSucceedWithAction:(SEL)action origin:(id)origin {
    if (!self.data)
        return;
    if ([delegate respondsToSelector:action])
        [delegate performSelector:action withObject:[NSNumber numberWithInt:self.selectedIndex] withObject:origin];
}

#pragma mark - String Picker Data Source

- (CGSize)viewSize {
    if (![self isViewPortrait])
        return CGSizeMake(480, 320);
    return CGSizeMake(320, 480);
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.selectedIndex = row;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.data.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [self.data objectAtIndex:row];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return pickerView.frame.size.width - 30;
}

#pragma mark - Popovers and ActionSheets

- (void)presentPickerForView:(UIView *)aView {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        [self configureAndPresentPopoverForView:aView];
    else
        [self configureAndPresentActionSheetForView:aView];
}

- (void)configureAndPresentActionSheetForView:(UIView *)aView {
    NSString *paddedSheetTitle = nil;
    if ([self isViewPortrait])
        paddedSheetTitle = @"\n\n\n"; // looks hacky to me
    _actionSheet = [[UIActionSheet alloc] initWithTitle:paddedSheetTitle delegate:nil cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    [_actionSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
    [_actionSheet addSubview:aView];
    [self presentActionSheet:_actionSheet];
    _actionSheet.bounds = CGRectMake(0, 0, self.viewSize.width, self.viewSize.height+5);
}

- (void)presentActionSheet:(UIActionSheet *)actionSheet {
    NSParameterAssert(actionSheet != NULL);
    if (self.barButtonItem)
        [actionSheet showFromBarButtonItem:_barButtonItem animated:YES];
    else if (self.containerView)
        [actionSheet showInView:_containerView];
}

- (void)configureAndPresentPopoverForView:(UIView *)aView {
    UIViewController *viewController = [[UIViewController alloc] initWithNibName:nil bundle:nil];
    viewController.view = aView;
    viewController.contentSizeForViewInPopover = viewController.view.frame.size;
    _popOverController = [[UIPopoverController alloc] initWithContentViewController:viewController];
    [self presentPopover:_popOverController];
    [viewController release];
}

- (void)presentPopover:(UIPopoverController *)popover {
    NSParameterAssert(popover != NULL);
    if (self.barButtonItem)
        [popover presentPopoverFromBarButtonItem:_barButtonItem permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    else if (self.containerView) {
        #warning  This operation looks wrong ... I'm thinking there should be a view or superview between the "?" and the ":" ??? 
        UIView *popoverContents = (_containerView.superview ? : _containerView);
        [popover presentPopoverFromRect:_containerView.frame inView:popoverContents permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
}

#pragma mark - Convenient Utilities

- (void)actionPickerDone:(id)sender {
    NSAssert(self.delegate != NULL, @"Cannot perform an action on a null target");
    NSAssert(self.action != NULL, @"Cannot perform a null action");
    [self notifyDelegate:self.delegate didSucceedWithAction:self.action origin:[self storedOrigin]];
    [self dismissPicker];
}

- (void)actionPickerCancel:(id)sender {
    [self dismissPicker];
}

- (void)dismissPicker {
    if (self.actionSheet)
        [_actionSheet dismissWithClickedButtonIndex:0 animated:YES];
    else if (self.popOverController)
        [_popOverController dismissPopoverAnimated:YES];
}

- (UIToolbar *)createPickerToolbarWithTitle:(NSString *)title  {
    CGRect frame = CGRectMake(0, 0, self.viewSize.width, 44);
    UIToolbar *pickerToolbar = [[UIToolbar alloc] initWithFrame:frame];
    pickerToolbar.barStyle = UIBarStyleBlackOpaque;
    NSMutableArray *barItems = [[NSMutableArray alloc] init];
    
    UIBarButtonItem *cancelBtn = [self createButtonWithType:UIBarButtonSystemItemCancel target:self action:@selector(actionPickerCancel:)];
    [barItems addObject:cancelBtn];
    [cancelBtn release];
    UIBarButtonItem *flexSpace = [self createButtonWithType:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [barItems addObject:flexSpace];
    
    if (title){
        UIBarButtonItem *labelButton = [self createToolbarLabelWithTitle:title];
        [barItems addObject:labelButton];    
        [labelButton release];    
        [barItems addObject:flexSpace];
    }
    
    UIBarButtonItem *doneButton = [self createButtonWithType:UIBarButtonSystemItemDone target:self action:@selector(actionPickerDone:)];
    [barItems addObject:doneButton];
    [doneButton release];
    [flexSpace release];
    
    [pickerToolbar setItems:barItems animated:YES];
    [barItems release];
    return pickerToolbar;
}

- (UIBarButtonItem *)createToolbarLabelWithTitle:(NSString *)aTitle {
    UILabel *toolBarItemlabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 180,30)];
    [toolBarItemlabel setTextAlignment:UITextAlignmentCenter];    
    [toolBarItemlabel setTextColor:[UIColor whiteColor]];    
    [toolBarItemlabel setFont:[UIFont boldSystemFontOfSize:16]];    
    [toolBarItemlabel setBackgroundColor:[UIColor clearColor]];    
    toolBarItemlabel.text = aTitle;    
    UIBarButtonItem *buttonLabel =[[UIBarButtonItem alloc]initWithCustomView:toolBarItemlabel];
    [toolBarItemlabel release];    
    return buttonLabel;
}

- (UIBarButtonItem *)createButtonWithType:(UIBarButtonSystemItem)type target:(id)target action:(SEL)buttonAction {
    return [[UIBarButtonItem alloc] initWithBarButtonSystemItem:type target:target action:buttonAction];
}

- (BOOL)isViewPortrait {
    return UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation);
}

- (BOOL)isValidOrigin:(id)origin {
    if (!origin)
        return NO;
    BOOL isButton = [origin isKindOfClass:[UIBarButtonItem class]];
    BOOL isView = [origin isKindOfClass:[UIView class]];
    return (isButton || isView);
}

- (id)storedOrigin {
    if (self.barButtonItem)
        return self.barButtonItem;
    return self.containerView;
}

@end

