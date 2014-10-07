//
//  AbstractActionSheetPickerTestCase.m
//  Example
//
//  Created by Petr Korolev on 07/10/14.
//
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <CoreActionSheetPicker/ActionSheetStringPicker.h>
static UIView *origin;

@interface AbstractActionSheetPickerTestCase : XCTestCase
@property(nonatomic, strong) ActionSheetStringPicker *sheetStringPicker;
@property(nonatomic, strong) UIView *origin;

@end

@implementation AbstractActionSheetPickerTestCase

+(void)setUp{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    UIView *topView = window.rootViewController.view;
    origin = topView;
}

- (void)setUp
{
    [super setUp];

    _sheetStringPicker = [[ActionSheetStringPicker alloc] initWithTitle:@"Title" rows:@[@"1",@"2", @"3"] initialSelection:0 doneBlock:nil cancelBlock:nil origin:origin];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    _sheetStringPicker = nil;
    [super tearDown];
}

- (void)testCustomFontNameWithTextAttributes
{
    _sheetStringPicker.titleTextAttributes = @{NSFontAttributeName : [UIFont fontWithName:@"Palatino-BoldItalic" size:16.f]};
    [_sheetStringPicker showActionSheetPicker];
    XCTAssertNotNil(_sheetStringPicker);
}


- (void)testCustomFontNameWithAttributedText
{
    NSString *string = @"Custom label:";
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:string];
    NSRange range = [attString.string rangeOfString:string];
    [attString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Palatino-BoldItalic" size:16.f] range:range];

    _sheetStringPicker.attributedTitle = attString;
    [_sheetStringPicker showActionSheetPicker];
    XCTAssertNotNil(_sheetStringPicker);
}

- (void)testCustomFontNameWithAttributedTextAndTextAttributes
{
    NSString *string = @"Custom label:";
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:string];
    NSRange range = [attString.string rangeOfString:string];
    [attString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Palatino-BoldItalic" size:16.f] range:range];

    _sheetStringPicker.attributedTitle = attString;
    _sheetStringPicker.titleTextAttributes = @{NSFontAttributeName : [UIFont fontWithName:@"Palatino-BoldItalic" size:16.f]};
    
    [_sheetStringPicker showActionSheetPicker];
    XCTAssertNotNil(_sheetStringPicker);
}


@end
