//
//  ActionSheetCustomPickerTestCase.m
//  ActionSheetPicker
//
//  Created by Petr Korolev on 19/07/14.
//
//

#import <XCTest/XCTest.h>
#import "ActionSheetCustomPicker.h"

@interface ActionSheetCustomPickerTestCase : XCTestCase

@property(nonatomic, strong) ActionSheetCustomPicker *actionSheetCustomPicker;
@end

@implementation ActionSheetCustomPickerTestCase

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testAddCustomButton {
    self.actionSheetCustomPicker = [[ActionSheetCustomPicker alloc] initWithTarget:self successAction:nil
                                                                      cancelAction:nil
                                                                            origin:[[UIView alloc] init]];
    [self.actionSheetCustomPicker addCustomButtonWithTitle:@"Test titile" value:@0];
    XCTAssertNotNil(self.actionSheetCustomPicker);
}

@end
