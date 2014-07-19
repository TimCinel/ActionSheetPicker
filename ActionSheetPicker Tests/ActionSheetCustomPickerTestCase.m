//
//  ActionSheetCustomPickerTestCase.m
//  ActionSheetPicker
//
//  Created by Petr Korolev on 19/07/14.
//
//

#import <XCTest/XCTest.h>
#import "ActionSheetCustomPicker.h"

static const int expectedNumberOfComponents = 2;

static const int expectedNumberOfRows = 3;

@interface ActionSheetCustomPickerTestCase : XCTestCase <ActionSheetCustomPickerDelegate>

@property(nonatomic, strong) ActionSheetCustomPicker *actionSheetCustomPicker;
@property(nonatomic, strong) UIView *origin;
@property(nonatomic) int numberOfComponents;
@property(nonatomic) int numberOfRowInCOmponent;
@end

@implementation ActionSheetCustomPickerTestCase
{
    UIView *_origin;
}

- (void)setUp {
    [super setUp];
    _origin = [[UIView alloc] init];

    self.numberOfComponents = expectedNumberOfComponents;
    self.numberOfRowInCOmponent = expectedNumberOfRows;
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    _actionSheetCustomPicker = nil;
    [super tearDown];
}

- (void)testAddCustomButton {

    self.actionSheetCustomPicker = [[ActionSheetCustomPicker alloc] initWithTarget:self successAction:nil
                                                                      cancelAction:nil
                                                                            origin:_origin];
    [self.actionSheetCustomPicker addCustomButtonWithTitle:@"Test titile" value:@0];
    XCTAssertNotNil(self.actionSheetCustomPicker);
}
/// Initializes:
- (void)testPickerWithNilInitialSections{

    _actionSheetCustomPicker = [[ActionSheetCustomPicker alloc] initWithTitle:@"title" origin:_origin
                                                                            delegate:self
                                                                    showCancelButton:NO
                                                                   initialSelections:nil];
    XCTAssertNotNil(_actionSheetCustomPicker);
}

- (void)testPickerWithExpectedInitialSectionsNumberOfSections{

    NSArray *selections= [self getArrayWithNumbersTimes:expectedNumberOfComponents number:@0];
    _actionSheetCustomPicker = [[ActionSheetCustomPicker alloc] initWithTitle:@"title" origin:_origin
                                                                     delegate:self
                                                             showCancelButton:NO
                                                            initialSelections:selections];
    XCTAssertNotNil(_actionSheetCustomPicker);
}
//
//- (void)testPickerWithInitialSectionsMoreThanNumberOfSectionsFail{
//
//    NSArray *selections= [self getArrayWithNumbersTimes:(expectedNumberOfComponents + 4) number:@0];
//    XCTAssertThrows([[ActionSheetCustomPicker alloc] initWithTitle:@"title" origin:_origin
//                                                          delegate:self
//                                                  showCancelButton:NO
//                                                 initialSelections:selections]);
//}

- (NSArray *)getArrayWithNumbersTimes:(NSUInteger)integer number:(NSNumber *)number
{
    NSMutableArray * selections = [NSMutableArray arrayWithCapacity:integer];
    for (NSInteger i = 0; i < integer; i++)
    {
        [selections addObject:number];
    }
    return selections;
}

- (void)testPickerWithInit1{

    _actionSheetCustomPicker = [[ActionSheetCustomPicker alloc] initWithTarget:self
                                                                 successAction:nil
                                                                  cancelAction:nil
                                                                        origin:_origin];
    XCTAssertNotNil(_actionSheetCustomPicker);
}

- (void)testAssertWhenOriginNil{

    XCTAssertThrows([ActionSheetCustomPicker showPickerWithTitle:@"title"
                                                        delegate:self
                                                showCancelButton:YES origin:nil]);
}

- (void)testAssertWhenDelegateNil{

    XCTAssert([ActionSheetCustomPicker showPickerWithTitle:@"title"
                                                        delegate:nil
                                                showCancelButton:YES origin:_origin]);
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return self.numberOfComponents;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.numberOfRowInCOmponent;
}


@end
