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

#import <Foundation/Foundation.h>

@interface ActionSheetPicker : NSObject <UIPickerViewDelegate, UIPickerViewDataSource>


@property (nonatomic, retain) UIView *pickerView;
@property (nonatomic, readonly) CGSize viewSize;
@property (nonatomic, retain) NSMutableArray *customButtons; // ((NSString *title, id value),(NSString *title, id value), ... )
@property (nonatomic, assign) BOOL hideCancel;

/* Create and display an action sheet picker. The returned picker is autoreleased. 
    "origin" must not be empty.  It can be either an originating container view or a UIBarButtonItem to use with a popover arrow.
    "target" must not be empty.  It should respond to "onSuccess" actions.
    "rows" is an array of strings to use for the picker's available selection choices. 
    "initialSelection" is used to establish the initially selected row;
 */
+ (id)showPickerWithTitle:(NSString *)title rows:(NSArray *)data initialSelection:(NSInteger)index target:(id)target action:(SEL)action origin:(id)origin;

    // Create an action sheet picker, but don't display until a subsequent call to "showActionPicker".  Receiver must release the picker when ready. */
- (id)initWithTitle:(NSString *)title rows:(NSArray *)data initialSelection:(NSInteger)index target:(id)target action:(SEL)action origin:(id)origin;


    // Adds custom buttons to the left of the UIToolbar that select specified values
- (void)addCustomButtonWithTitle:(NSString *)title value:(id)value;

    // Present the ActionSheetPicker
- (void)showActionSheetPicker;

    // For subclasses.  This is used to send a message to the target upon a successful selection and dismissal of the picker (i.e. not canceled).
- (void)notifyTarget:(id)target didSucceedWithAction:(SEL)action origin:(id)origin;

    // For subclasses.  This returns a configured picker view.  Subclasses should autorelease.
- (UIPickerView *)configuredPickerView;

- (void)actionPickerDone:(id)sender;
- (void)actionPickerCancel:(id)sender;

    //For subclasses. This responds to a custom button being pressed.
- (void)customButtonPressed:(id)sender;

@end
