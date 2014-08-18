//
//  IQDropDownTextField.h
//
//  Created by Iftekhar on 19/10/13.
//  Copyright (c) 2013 Iftekhar. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum IQDropDownMode
{
    IQDropDownModeTextPicker,
    IQDropDownModeTimePicker,
    IQDropDownModeDatePicker,
    IQDropDownModeDictionaryPicker,
}IQDropDownMode;

/*Do not modify it's delegate*/
@interface IQDropDownTextField : UITextField

@property(nonatomic, assign) IQDropDownMode dropDownMode;

//For IQdropDownModePickerView
//@property(nonatomic, strong) NSArray *itemList;
@property(nonatomic, strong) NSMutableArray *itemList; // Custom
@property(nonatomic, strong) NSString *optsKey; // Custom
@property(nonatomic, strong) NSString *optsLabel; // Custom

//For IQdropDownModeDatePicker
- (void)setDate:(NSDate *)date animated:(BOOL)animated;
- (void)setDateFormatter:(NSDateFormatter *)userDateFormatter;
@property(nonatomic) UIDatePickerMode datePickerMode;             // default is UIDatePickerModeDate

//@property(nonatomic, strong) NSString *selectedItem;
@property(nonatomic, strong) NSObject *selectedItem; // Custom
-(void)setItemListDictionary:(NSArray *)itemList optsKey:(NSString*)optsKey optsLabel:(NSString*)optsLabel optsSelecione:(BOOL)optsSelecione; // Custom


- (void)setDatePickerMaximumDate:(NSDate*)date;

- (NSString*)textKey; // Custom
- (void)setSelectedItemDictionary:(NSString *)selectedItemStr; // Custom

@end
