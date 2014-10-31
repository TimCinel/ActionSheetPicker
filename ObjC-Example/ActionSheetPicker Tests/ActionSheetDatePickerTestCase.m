//
//  ActionSheetDatePickerTestCase.m
//  ActionSheetPicker
//
//  Created by Vladislava Kirichenko on 10/22/14.
//
//

#import <XCTest/XCTest.h>
#import <CoreActionSheetPicker/CoreActionSheetPicker.h>
#import "AbstractActionSheetPicker+CustomButton.h"
UIView *origin;

@interface ActionSheetDatePickerTestCase : XCTestCase
@property(nonatomic, strong) ActionSheetDatePicker *actionSheetDatePicker;
@end

@implementation ActionSheetDatePickerTestCase
{
    NSString *_title;
}

+(void)setUp{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    UIView *topView = window.rootViewController.view;
    origin = topView;    
}

- (void)setUp {
    [super setUp];
    _title = @"Title";
    _actionSheetDatePicker = [[ActionSheetDatePicker alloc] initWithTitle:@"Test title" datePickerMode:UIDatePickerModeDate selectedDate:[NSDate date] target:nil action:nil origin:origin cancelAction:nil];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testPickerWithCustomActionBlockOnButton
{
    NSString *custom_title = @"Custom label:";
    
    [_actionSheetDatePicker addCustomButtonWithTitle:custom_title actionBlock:^{
        NSLog(@"Test block invoked");
    }];
    [_actionSheetDatePicker showActionSheetPicker];
    
    [_actionSheetDatePicker pressFirstCustomButton];
    
    XCTAssertNotNil(_actionSheetDatePicker);
}

- (void)testPickerWithCustomActionBlockOnButtonAndNilString
{
    [_actionSheetDatePicker addCustomButtonWithTitle:nil actionBlock:^{
        NSLog(@"Test block invoked");
    }];
    [_actionSheetDatePicker showActionSheetPicker];
    
    [_actionSheetDatePicker pressFirstCustomButton];

    XCTAssertNotNil(_actionSheetDatePicker);
}

- (void)testPickerWithNilCustomActionBlockOnButton
{
    [_actionSheetDatePicker addCustomButtonWithTitle:_title actionBlock:nil];
    [_actionSheetDatePicker showActionSheetPicker];
    
    [_actionSheetDatePicker pressFirstCustomButton];
    
    XCTAssertNotNil(_actionSheetDatePicker);
}

- (void)testPickerWithNilCustomActionBlockOnButtonAndNilString
{
    [_actionSheetDatePicker addCustomButtonWithTitle:nil actionBlock:nil];
    [_actionSheetDatePicker showActionSheetPicker];
    
    [_actionSheetDatePicker pressFirstCustomButton];
    
    XCTAssertNotNil(_actionSheetDatePicker);
}

- (void)testPickerWithCustomActionSelectorOnButton
{
    [_actionSheetDatePicker addCustomButtonWithTitle:_title target:self selector:@selector(exampleSelector)];
    [_actionSheetDatePicker showActionSheetPicker];

    [_actionSheetDatePicker pressFirstCustomButton];

    XCTAssertNotNil(_actionSheetDatePicker);
}

- (void)testPickerWithCustomActionSelectorOnButtonAndNilString
{
    [_actionSheetDatePicker addCustomButtonWithTitle:nil target:self selector:@selector(exampleSelector)];
    [_actionSheetDatePicker showActionSheetPicker];
    
    [_actionSheetDatePicker pressFirstCustomButton];
    
    XCTAssertNotNil(_actionSheetDatePicker);
}

- (void)testPickerWithNilCustomActionSelectorOnButton
{
    [_actionSheetDatePicker addCustomButtonWithTitle:_title target:self selector:nil];
    [_actionSheetDatePicker showActionSheetPicker];
    
    [_actionSheetDatePicker pressFirstCustomButton];
    
    XCTAssertNotNil(_actionSheetDatePicker);
}

- (void)testPickerWithCustomActionSelectorOnButtonAndNilTarget
{
    [_actionSheetDatePicker addCustomButtonWithTitle:_title target:nil selector:@selector(exampleSelector)];
    [_actionSheetDatePicker showActionSheetPicker];
    
    [_actionSheetDatePicker pressFirstCustomButton];
    
    XCTAssertNotNil(_actionSheetDatePicker);
}

- (void)testPickerWithNilCustomActionSelectorOnButtonNilTargetAndNilString
{
    [_actionSheetDatePicker addCustomButtonWithTitle:nil target:nil selector:nil];
    [_actionSheetDatePicker showActionSheetPicker];
    
    [_actionSheetDatePicker pressFirstCustomButton];
    
    XCTAssertNotNil(_actionSheetDatePicker);
}

- (void)exampleSelector
{
    NSLog(@"Test selector invoked");
}

@end
