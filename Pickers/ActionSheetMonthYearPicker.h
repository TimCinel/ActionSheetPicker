//
//Copyright (c) 2012, pyanfield@gmail.com
//Extend Tim Cinel's ActionSheetPicker
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

/*
 This class inherit the base class AbstractActionSheetPicker which created by Tim Cinel.
 You can use this class to create a action picker that just display month and years. and you need to set the begin date and end date.
 Then it will display data.
 */

#import "AbstractActionSheetPicker.h"

@interface ActionSheetMonthYearPicker : AbstractActionSheetPicker<UIPickerViewDelegate,UIPickerViewDataSource>

// the "start" is the start date that you want to display the begin data. you can set it like this : 2012.07 or 2012-07
// the "end" is the end date that you want to display the begin data. you can set it like this : 2012.07 or 2012-07
+ (id)showPickerWithTitle:(NSString*)title start:(NSString*)start end:(NSString*)end tartget:(id)target successAction:(SEL)successAction cancelAction:(SEL)cancelAction origin:(id)origin;

- (id)initWithTitle:(NSString*)title start:(NSString*)start end:(NSString*)end tartget:(id)target successAction:(SEL)successAction cancelAction:(SEL)cancelAction origin:(id)origin;

@property (nonatomic, strong) NSString *selectedData;
@property (nonatomic, strong) NSString *selectedMonth;
@property (nonatomic, strong) NSString *selectedYear;

@end
