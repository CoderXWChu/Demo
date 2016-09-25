//
//  JDCalendarPickerView.h
//  Demo-thirft
//
//  Created by DanaChu on 16/8/29.
//  Copyright © 2016年 DanaChu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JTCalendar.h"

@protocol JDCalendarPickerViewDelegate;

@interface JDCalendarPickerView : UIView
+ (instancetype)new UNAVAILABLE_ATTRIBUTE;
- (instancetype)init UNAVAILABLE_ATTRIBUTE;

+ (instancetype)calendarPickerView;

@property (weak, nonatomic) IBOutlet JTCalendarMenuView *calendarMenuView;
@property (weak, nonatomic) IBOutlet JTCalendarWeekDayView *weekDayView;
@property (weak, nonatomic) IBOutlet JTVerticalCalendarView *calendarContentView;
@property (strong, nonatomic) JTCalendarManager *calendarManager;

@property (nonatomic, weak) id<JDCalendarPickerViewDelegate> delegate;


- (NSDate *)selectedDate;
- (void)show;
- (void)hide;

@end

@protocol JDCalendarPickerViewDelegate <NSObject>

@optional

- (void)pickerView:(JDCalendarPickerView *)picker viewWillDisappearWithDate:(NSDate *)date;

@end
