//
//  ActionSheetLocalePickerTestCase.m
//  ActionSheetPicker
//
//  Created by Petr Korolev on 13/08/14.
//
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <CoreActionSheetPicker/CoreActionSheetPicker.h>
UIView *origin;

@interface ActionSheetLocalePickerTestCase : XCTestCase
@property(nonatomic, strong) ActionSheetLocalePicker *actionSheetLocalePicker;

@end

@implementation ActionSheetLocalePickerTestCase


+(void)setUp{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    UIView *topView = window.rootViewController.view;
    origin = topView;

}

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testPickerWithInitWithDefaultLocale
{
    _actionSheetLocalePicker = [[ActionSheetLocalePicker alloc] initWithTitle:@"Test title" initialSelection:nil doneBlock:nil cancelBlock:nil origin:origin];
    XCTAssertNotNil(_actionSheetLocalePicker);
}

- (void)testPickerWithInitWithLocale
{
    _actionSheetLocalePicker = [[ActionSheetLocalePicker alloc] initWithTitle:@"Test title" initialSelection:[NSTimeZone localTimeZone] doneBlock:nil cancelBlock:nil origin:origin];
    XCTAssertNotNil(_actionSheetLocalePicker);
}


@end
