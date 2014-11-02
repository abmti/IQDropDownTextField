//
//  IQDropDownTextField.m
//
//  Created by Iftekhar on 19/10/13.
//  Copyright (c) 2013 Iftekhar. All rights reserved.
//

#import "IQDropDownTextField.h"

@interface IQDropDownTextField ()<UITextFieldDelegate,UIPickerViewDelegate, UIPickerViewDataSource>

@end

@implementation IQDropDownTextField
{
    UIPickerView *pickerView;
    UIDatePicker *datePicker;
    UIDatePicker *timePicker;
    NSDateFormatter *dropDownDateFormatter;
    NSDateFormatter *dropDownTimeFormatter;
}

- (CGRect)caretRectForPosition:(UITextPosition *)position {
    return CGRectZero;
}

-(void)initialize
{
    [self setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [self setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    [self setBorderStyle:UITextBorderStyleRoundedRect];
    [self setDelegate:self];
    
    dropDownDateFormatter = [[NSDateFormatter alloc] init];
    [dropDownDateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dropDownDateFormatter setTimeStyle:NSDateFormatterNoStyle];
    
    dropDownTimeFormatter = [[NSDateFormatter alloc] init];
    [dropDownTimeFormatter setDateStyle:NSDateFormatterNoStyle];
    [dropDownTimeFormatter setTimeStyle:NSDateFormatterShortStyle];
    
    pickerView = [[UIPickerView alloc] init];
    [pickerView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight)];
    [pickerView setShowsSelectionIndicator:YES];
    [pickerView setDelegate:self];
    [pickerView setDataSource:self];
    
    datePicker = [[UIDatePicker alloc] init];
    [datePicker setAutoresizingMask:(UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight)];
    [datePicker setDatePickerMode:UIDatePickerModeDate];
    [datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
    
    timePicker = [[UIDatePicker alloc] init];
    [timePicker setAutoresizingMask:(UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight)];
    [timePicker setDatePickerMode:UIDatePickerModeTime];
    [timePicker addTarget:self action:@selector(timeChanged:) forControlEvents:UIControlEventValueChanged];
    
    [self setDropDownMode:IQDropDownModeTextPicker];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initialize];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self initialize];
    }
    return self;
}

-(void)setDropDownMode:(IQDropDownMode)dropDownMode
{
    _dropDownMode = dropDownMode;
    
    switch (_dropDownMode)
    {
        case IQDropDownModeTextPicker:
            self.inputView = pickerView;
            break;
            
        case IQDropDownModeDatePicker:
            self.inputView = datePicker;
            break;
        case IQDropDownModeTimePicker:
            self.inputView = timePicker;
            break;
            
        default:
            break;
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _itemList.count;
}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *labelText = [[UILabel alloc] init];
    labelText.font = [UIFont boldSystemFontOfSize:20.0];
    labelText.backgroundColor = [UIColor clearColor];
    [labelText setTextAlignment:NSTextAlignmentCenter];
    id obj = [_itemList objectAtIndex:row];
    if ([obj isKindOfClass:[NSDictionary class]]) {
        [labelText setText:[(NSDictionary*)obj objectForKey:self.optsLabel]];
    } else {
        [labelText setText:obj];
    }
    return labelText;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [self setSelectedItem:[_itemList objectAtIndex:row]];
}

-(void)dateChanged:(UIDatePicker*)dPicker
{
    [self setSelectedItem:[dropDownDateFormatter stringFromDate:dPicker.date]];
}
-(void)timeChanged:(UIDatePicker*)tPicker{
    
    [self setSelectedItem:[dropDownTimeFormatter stringFromDate:tPicker.date]];
}

-(void)setItemList:(NSArray *)itemList
{
    _itemList = [itemList mutableCopy];
    
    if ([self.text length] == 0 && [_itemList count] > 0)
    {
        //        [self setText:[_itemList objectAtIndex:0]];
    }
    
    [pickerView reloadAllComponents];
}

// Custom
-(void)setItemListDictionary:(NSArray *)itemList optsKey:(NSString*)optsKey optsLabel:(NSString*)optsLabel optsSelecione:(BOOL)optsSelecione
{
    [self setDropDownMode:IQDropDownModeDictionaryPicker];
    if(optsSelecione) {
        _itemList = [[NSMutableArray alloc] init];
        [_itemList addObject:@{optsKey:@"", optsLabel:@""}];
        [_itemList addObjectsFromArray:itemList];
    } else {
        _itemList = [itemList mutableCopy];
    }
    _optsKey = optsKey;
    _optsLabel = optsLabel;
    
    if ([self.text length] == 0 && [_itemList count] > 0)
    {
        //        [self setText:[_itemList objectAtIndex:0]];
    }
    
    [pickerView reloadAllComponents];
}

- (void)setDate:(NSDate *)date animated:(BOOL)animated
{
    [self setSelectedItem:[dropDownDateFormatter stringFromDate:date]];
}
- (void)setDateFormatter:(NSDateFormatter *)userDateFormatter {
    dropDownDateFormatter = userDateFormatter;
    [datePicker setLocale:dropDownDateFormatter.locale];
}

// Custom
-(void)setSelectedItemDictionary:(NSString *)selectedItemStr
{
    for (NSDictionary *dict in _itemList) {
        NSString *keyStr = [NSString stringWithFormat:@"%@", [dict objectForKey:_optsKey]];
        if([keyStr isEqualToString:selectedItemStr]) {
            _selectedItem = dict;
            self.text = [dict objectForKey:_optsLabel];
            [self insertText:[dict objectForKey:_optsLabel]];
            [pickerView selectRow:[_itemList indexOfObject:dict] inComponent:0 animated:YES];
        }
    }
}


-(void)setSelectedItem:(NSObject *)selectedItemId
{
    switch (_dropDownMode)
    {
        // Custom
        case IQDropDownModeDictionaryPicker:
        {
            NSString *selectedItem = [(NSDictionary*)selectedItemId objectForKey:self.optsLabel];
            if ([_itemList containsObject:selectedItemId])
            {
                _selectedItem = selectedItemId;
                self.text = @"";
                [self insertText:selectedItem];
                [pickerView selectRow:[_itemList indexOfObject:selectedItemId] inComponent:0 animated:YES];
            }
            break;
        }
        case IQDropDownModeTextPicker:
        {
            NSString *selectedItem = [NSString stringWithFormat:@"%@", selectedItemId];
            if ([_itemList containsObject:selectedItem])
            {
                _selectedItem = selectedItem;
                self.text = @"";
                [self insertText:selectedItem];
                [pickerView selectRow:[_itemList indexOfObject:selectedItem] inComponent:0 animated:YES];
            }
            break;
        }
        case IQDropDownModeDatePicker:
        {
            NSString *selectedItem = [NSString stringWithFormat:@"%@", selectedItemId];
            NSDate *date = [dropDownDateFormatter dateFromString:selectedItem];
            if (date)
            {
                _selectedItem = selectedItem;
                self.text = @"";
                [self insertText:selectedItem];
                [datePicker setDate:date animated:YES];
            }
            else
            {
                NSLog(@"Invalid date or date format:%@",selectedItem);
            }
            break;
        }
        case IQDropDownModeTimePicker:
        {
            NSString *selectedItem = [NSString stringWithFormat:@"%@", selectedItemId];
            NSDate *date = [dropDownTimeFormatter dateFromString:selectedItem];
            if (date)
            {
                _selectedItem = selectedItem;
                self.text = @"";
                [self insertText:selectedItem];
                [datePicker setDate:date animated:YES];
            }
            else
            {
                NSLog(@"Invalid time or time format:%@",selectedItem);
            }
            break;
        }
    }
}

-(void)setDatePickerMode:(UIDatePickerMode)datePickerMode
{
    if (_dropDownMode == IQDropDownModeDatePicker)
    {
        _datePickerMode = datePickerMode;
        [datePicker setDatePickerMode:datePickerMode];
        
        switch (datePickerMode) {
            case UIDatePickerModeCountDownTimer:
                [dropDownDateFormatter setDateStyle:NSDateFormatterNoStyle];
                [dropDownDateFormatter setTimeStyle:NSDateFormatterNoStyle];
                break;
            case UIDatePickerModeDate:
                [dropDownDateFormatter setDateStyle:NSDateFormatterShortStyle];
                [dropDownDateFormatter setTimeStyle:NSDateFormatterNoStyle];
                break;
            case UIDatePickerModeTime:
                [dropDownDateFormatter setDateStyle:NSDateFormatterNoStyle];
                [dropDownDateFormatter setTimeStyle:NSDateFormatterShortStyle];
                break;
            case UIDatePickerModeDateAndTime:
                [dropDownDateFormatter setDateStyle:NSDateFormatterShortStyle];
                [dropDownDateFormatter setTimeStyle:NSDateFormatterShortStyle];
                break;
        }
    }
}

- (void)setDatePickerMaximumDate:(NSDate*)date
{
    if (_dropDownMode == IQDropDownModeDatePicker)
        datePicker.maximumDate = date;
}

// Custom
- (NSString*)textKey
{
    if (_selectedItem == nil) {
        return @"";
    }
    return [(NSDictionary*)_selectedItem objectForKey:self.optsKey];
}

@end
