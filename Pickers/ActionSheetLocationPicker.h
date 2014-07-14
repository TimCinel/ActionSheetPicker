//
// Created by Petr Korolev on 14/07/14.
//

#import <Foundation/Foundation.h>
#import "ActionSheetCustomPicker.h"


static const float firstColumnWidth = 100.0f;

static const float secondColumnWidth = 160.0f;


@interface ActionSheetLocationPicker : ActionSheetCustomPicker

@property (nonatomic, strong) NSString *selectedContinent;
@property (nonatomic, strong) NSString *selectedCity;

@property(nonatomic, strong) NSMutableDictionary *continentsAndCityDictionary;
@property(nonatomic, strong) NSMutableArray *continents;

@end