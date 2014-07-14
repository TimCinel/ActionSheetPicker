//
// Created by Petr Korolev on 14/07/14.
//

#import "ActionSheetLocationPicker.h"


@implementation ActionSheetLocationPicker
{

}

- (id)initWithTitle:(NSString *)title delegate:(id <ActionSheetCustomPickerDelegate>)delegate showCancelButton:(BOOL)showCancelButton origin:(id)origin
{
    self = [super initWithTitle:title delegate:delegate showCancelButton:showCancelButton origin:origin];
    if ( self )
    {
        [self fillContinentsAndCities];
        [self setSelectedRows];
    }

    return self;
}

- (void)setSelectedRows
{
    NSString *string = [fxAppState sharedInstance].eventsSettings.currentTimeZone;

    if (!string)
        string = [[NSTimeZone localTimeZone] name];

    NSArray *array = [string componentsSeparatedByString:@"/"];

    selectedContinent = array[0];
    selectedCity = array[1];
}

-(void)fillContinentsAndCities
{
    NSArray *timeZones = [NSTimeZone knownTimeZoneNames];

    NSMutableDictionary *continentsDict = [[NSMutableDictionary alloc] init];

    _continents= [[NSMutableArray alloc] init];

    [timeZones enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
    {
        if ( [obj isKindOfClass:[NSString class]] )
        {
            NSString *string = (NSString *) obj;
            NSArray *array = [string componentsSeparatedByString:@"/"];

            if ( [array count] == 2)
            {
                if ( [continentsDict objectForKey:array[0]]) //if continent exists
                {
                    NSMutableArray *citys = [continentsDict objectForKey:array[0]];
                    [citys addObject:array[1]];
                }
                else //it's new continent
                {
                    NSMutableArray *mutableArray = [[NSMutableArray alloc] initWithObjects: array[1],nil];
                    [continentsDict setObject:mutableArray forKey:array[0]];
                    [_continents addObject:array[0]];
                }
            }
        }

    }];

    self.continentsAndCityDictionary = continentsDict;
};

-(NSMutableArray *)getCitiesByContinent:(NSString *)continent
{
    NSMutableArray *citiesIncontinent = [_continentsAndCityDictionary objectForKey:continent];
    return citiesIncontinent;
};

/////////////////////////////////////////////////////////////////////////
#pragma mark - ActionSheetCustomPickerDelegate Optional's
/////////////////////////////////////////////////////////////////////////
- (void)configurePickerView:(UIPickerView *)pickerView
{
    // Override default and hide selection indicator
    pickerView.showsSelectionIndicator = YES;

    NSUInteger rowContinent = [_continents indexOfObject:selectedContinent];
    NSUInteger rowCity = [[self getCitiesByContinent:selectedContinent] indexOfObject:selectedCity];

    if ((rowContinent != NSNotFound) && (rowCity != NSNotFound)) // to fix some crashes from prev versions http://crashes.to/s/ecb0f15ce49
    {
        [pickerView selectRow:rowContinent inComponent:0 animated:YES];
        [pickerView selectRow:rowCity inComponent:1 animated:YES];
    }
    else
    {
        [pickerView selectRow:0 inComponent:0 animated:YES];
        [pickerView selectRow:0 inComponent:1 animated:YES];
        AGAssert(NO, @"NO == NO or nil");
    }


}

- (instancetype)initWithParent:(id <ActionSheetPickerLocaleDelegate>)parent
{
    self = [super init];
    if ( self )
    {
        self.parent = parent;

        [self fillContinentsAndCities];
        [self setSelectedRows];

    }

    return self;
}

+ (instancetype)controllerWithParent:(id <ActionSheetPickerLocaleDelegate>)parent
{
    return [[self alloc] initWithParent:parent];
}

- (void)actionSheetPickerDidSucceed:(AbstractActionSheetPicker *)actionSheetPicker origin:(id)origin
{
    NSString *timeZoneId = [NSString stringWithFormat:@"%@/%@", selectedContinent, selectedCity];
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:timeZoneId];

    [_parent localeDidSelectedWithTimeZone:timeZone];
    [FXTrackingController sendTrackingForAction:kActionSetTimeZone label:[timeZone name]];
}

/////////////////////////////////////////////////////////////////////////
#pragma mark - UIPickerViewDataSource Implementation
/////////////////////////////////////////////////////////////////////////

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    // Returns
    switch (component) {
        case 0: return [_continents count];
        case 1: return [[self getCitiesByContinent:selectedContinent] count];
        default:break;
    }
    return 0;
}

/////////////////////////////////////////////////////////////////////////
#pragma mark UIPickerViewDelegate Implementation
/////////////////////////////////////////////////////////////////////////

// returns width of column and height of row for each component.
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{

    switch (component) {

        case 0: return firstColumnWidth;
        case 1: return secondColumnWidth;
        default:break;
    }

    return 0;
}
/*- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
 {
 return
 }
 */
// these methods return either a plain UIString, or a view (e.g UILabel) to display the row for the component.
// for the view versions, we cache any hidden and thus unused views and pass them back for reuse.
// If you return back a different object, the old one will be released. the view will be centered in the row rect
//- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
//{
//    switch (component) {
//        case 0: return [self.continents objectAtIndex:row];
//        case 1: return [[self getCitiesByContinent:selectedContinent] objectAtIndex:row];
//        default:break;
//    }
//    return nil;
//}

- (UIView *)pickerView:(UIPickerView *)pickerView
            viewForRow:(NSInteger)row
          forComponent:(NSInteger)component
           reusingView:(UIView *)view {

    UILabel *pickerLabel = (UILabel *)view;

    if (pickerLabel == nil) {
        CGRect frame = CGRectZero;


        switch (component) {
            case 0: frame = CGRectMake(0.0, 0.0, firstColumnWidth, 32);
                break;
            case 1:
                frame = CGRectMake(0.0, 0.0, secondColumnWidth, 32);
                break;
            default:
                assert(NO);
                break;
        }

        pickerLabel = [[UILabel alloc] initWithFrame:frame];
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setMinimumScaleFactor:0.5];
        [pickerLabel setAdjustsFontSizeToFitWidth:YES];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont systemFontOfSize:20]];
    }

    NSString *text;
    switch (component) {
        case 0: text = [self.continents objectAtIndex:row];
            break;
        case 1:
        {
            NSString *cityTitle = [[self getCitiesByContinent:selectedContinent] objectAtIndex:row];
            NSString *timeZoneId = [NSString stringWithFormat:@"%@/%@", selectedContinent, cityTitle];
            NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:timeZoneId];

            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setTimeZone:timeZone];
            [dateFormatter setDateFormat:@"z"];
            text = [cityTitle stringByAppendingString:[NSString stringWithFormat: @" (%@)", [dateFormatter stringFromDate:[NSDate date]]]];

            break;
        }
        default:break;
    }

    [pickerLabel setText:text];

    return pickerLabel;

}

/////////////////////////////////////////////////////////////////////////

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSLog(@"Row %i selected in component %i", row, component);
    switch (component) {
        case 0:
        {
            selectedContinent = [self.continents objectAtIndex:row];
            [pickerView reloadComponent:1];
            selectedCity = [[self getCitiesByContinent:selectedContinent]
                                  objectAtIndex:(NSUInteger) [pickerView selectedRowInComponent:1]];
            return;
        }

        case 1:
            selectedCity = [[self getCitiesByContinent:selectedContinent] objectAtIndex:row];
            return;
        default:break;
    }
}

@end