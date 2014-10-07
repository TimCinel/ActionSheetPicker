//
//  ActionSheetCustomPickerTestCase.m
//  ActionSheetPicker
//
//  Created by Petr Korolev on 19/07/14.
//
//

#import <XCTest/XCTest.h>
#import <CoreActionSheetPicker/CoreActionSheetPicker.h>

static const int expectedNumberOfComponents = 2;

static const int expectedNumberOfRows = 3;

static UIView *origin;

@interface ActionSheetCustomPickerTestCase : XCTestCase <ActionSheetCustomPickerDelegate>

@property(nonatomic, strong) ActionSheetCustomPicker *actionSheetCustomPicker;
@property(nonatomic) int numberOfComponents;
@property(nonatomic) int numberOfRowInComponent;
@property(nonatomic, strong) NSArray *expectedSelections;
@end

@implementation ActionSheetCustomPickerTestCase
{

}

+(void)setUp{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    UIView *topView = window.rootViewController.view;
    origin = topView;
}

- (void)setUp
{
    [super setUp];

    self.numberOfComponents = expectedNumberOfComponents;
    self.numberOfRowInComponent = expectedNumberOfRows;

    self.expectedSelections = [self getArrayWithComponents:expectedNumberOfComponents
                                                      rows:expectedNumberOfRows-1];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    _actionSheetCustomPicker = nil;
    [super tearDown];
}


- (NSArray *)getArrayWithComponents:(NSUInteger)integer rows:(NSUInteger)number
{
    NSMutableArray *selections = [NSMutableArray arrayWithCapacity:integer];
    for (NSInteger i = 0; i < integer; i++)
    {
        [selections addObject:@(number)];
    }
    return selections;
}

- (void)testPickerWithInit1
{

    _actionSheetCustomPicker = [[ActionSheetCustomPicker alloc] initWithTarget:self
                                                                 successAction:nil
                                                                  cancelAction:nil
                                                                        origin:origin];
    XCTAssertNotNil(_actionSheetCustomPicker);
}

- (void)testPickerWithInit2
{

    _actionSheetCustomPicker = [ActionSheetCustomPicker showPickerWithTitle:@""
                                                                     delegate:self
                                                             showCancelButton:YES
                                                                       origin:origin];
            XCTAssertNotNil(_actionSheetCustomPicker);
}
- (void)testPickerWithInit3
{

    _actionSheetCustomPicker = [ActionSheetCustomPicker showPickerWithTitle:@""
                                                                     delegate:self
                                                             showCancelButton:YES
                                                                       origin:origin
                                                                       initialSelections:self.expectedSelections];
    XCTAssertNotNil(_actionSheetCustomPicker);
}

- (void)testAssertWhenOriginNil{


    XCTAssertThrows([ActionSheetCustomPicker showPickerWithTitle:@""
                                                                     delegate:self
                                                             showCancelButton:YES
                                                                       origin:nil]);

}

- (void)testShow1
{

    XCTAssertTrue(_actionSheetCustomPicker = [ActionSheetCustomPicker showPickerWithTitle:@"title"
                                                      delegate:self
                                              showCancelButton:YES origin:origin]);
}

- (void)testShow2
{
    XCTAssertTrue(_actionSheetCustomPicker = [ActionSheetCustomPicker showPickerWithTitle:@"" delegate:self
                                              showCancelButton:YES
                                                        origin:origin
                                             initialSelections:self.expectedSelections]);
}


- (void)testPickerWithNilInitialSections
{

    _actionSheetCustomPicker = [ActionSheetCustomPicker showPickerWithTitle:@"title" delegate:self showCancelButton:NO
                                                                       origin:origin initialSelections:nil ];
    XCTAssertNotNil(_actionSheetCustomPicker);
}

- (void)testPickerWithExpectedInitialSectionsNumberOfSections
{

    NSArray *selections = [self getArrayWithComponents:expectedNumberOfComponents rows:0];
    _actionSheetCustomPicker = [ActionSheetCustomPicker showPickerWithTitle:@"title" delegate:self showCancelButton:NO
                                                                       origin:origin initialSelections:selections];
    XCTAssertNotNil(_actionSheetCustomPicker);
}

- (void)testPickerWithInitialSectionsMoreThanNumberOfSectionsFail{

    NSArray *selections= [self getArrayWithComponents:expectedNumberOfComponents + 1 rows:expectedNumberOfRows];
    XCTAssertThrows([ActionSheetCustomPicker showPickerWithTitle:@""
                                                          delegate:self
                                                  showCancelButton:YES origin:origin
                                                 initialSelections:selections]);
    }

- (void)testPickerWithInitialSectionsLessThanNumberOfSectionsFail{

    NSArray *selections= [self getArrayWithComponents:expectedNumberOfComponents - 1 rows:expectedNumberOfRows];
    XCTAssertThrows([ActionSheetCustomPicker showPickerWithTitle:@""
                                                          delegate:self
                                                  showCancelButton:YES origin:origin
                                                 initialSelections:selections]);
    }

- (void)testPickerWithInitialSectionsGreaterRowThanExpectedFail {

    NSArray *selections= [self getArrayWithComponents:expectedNumberOfComponents rows:expectedNumberOfRows + 1];
    XCTAssertThrows([ActionSheetCustomPicker showPickerWithTitle:@""
                                                          delegate:self
                                                  showCancelButton:YES origin:origin
                                                 initialSelections:selections]);
    }

- (void)testAssertWhenDelegateNil{

    XCTAssertThrows([ActionSheetCustomPicker showPickerWithTitle:@""
                                                    delegate:nil
                                            showCancelButton:YES origin:origin]);
}


- (void)testAddCustomButton
{

    self.actionSheetCustomPicker = [[ActionSheetCustomPicker alloc] initWithTarget:self successAction:nil
                                                                      cancelAction:nil
                                                                            origin:origin];
    [self.actionSheetCustomPicker addCustomButtonWithTitle:@"Test titile" value:@0];
    XCTAssertNotNil(self.actionSheetCustomPicker);
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return self.numberOfComponents;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.numberOfRowInComponent;
}


@end
