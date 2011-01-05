//
//  ActionSheetPicker.h
//	https://github.com/sickanimations/ActionSheetPicker
//  
//  Improvements more than welcome.
//
//  Created by Tim Cinel
//  http://www.timcinel.com/
//
//	Easily present an ActionSheet with a PickerView, allowing user to select from a number of immutible options.
//	Based on the HTML drop-down alternative found in mobilesafari.
//
//	Some code derived from marcio's post on Stack Overflow [ http://stackoverflow.com/questions/1262574/add-uipickerview-a-button-in-action-sheet-how ]  

#import <Foundation/Foundation.h>


@interface ActionSheetPicker : NSObject <UIPickerViewDelegate, UIPickerViewDataSource> {
	UIView *_view;
	NSArray *_data;
	NSInteger _selectedIndex;
	id _target;
	SEL _action;
	
	UIActionSheet *_actionSheet;
	UIPickerView *_pickerView;
	NSInteger _pickerPosition;
	BOOL _convenientObject;

}

@property (nonatomic, retain) UIView *view;
@property (nonatomic, retain) NSArray *data;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, retain) id target;
@property (nonatomic, assign) SEL action;

@property (nonatomic, retain) UIActionSheet *actionSheet;
@property (nonatomic, retain) UIPickerView *pickerView;
@property (nonatomic, assign) NSInteger pickerPosition;
@property (nonatomic, assign) BOOL convenientObject;

//display action picker in View loaded with data, with item selectedIndex selected. On dismissal, [target action:(NSNumber *)selectedIndex] is called
//no memory management required
+ (void)displayActionPickerWithView:(UIView *)aView data:(NSArray *)data selectedIndex:(NSInteger)selectedIndex target:(id)target action:(SEL)action;

- (id)initWithContainingView:(UIView *)aView data:(NSArray *)someData selectedIndex:(NSInteger)index target:(id)target action:(SEL)action;

- (void)showActionPicker;

- (void)actionPickerDone;

@end
