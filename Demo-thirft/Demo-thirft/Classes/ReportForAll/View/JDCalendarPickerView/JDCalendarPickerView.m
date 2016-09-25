//
//  JDCalendarPickerView.m
//  Demo-thirft
//
//  Created by DanaChu on 16/8/29.
//  Copyright © 2016年 DanaChu. All rights reserved.
//

#import "JDCalendarPickerView.h"

@interface JDCalendarPickerView()<JTCalendarDelegate>
{
    NSMutableDictionary *_eventsByDate;
    
    NSDate *_dateSelected;
}
@end

@implementation JDCalendarPickerView

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    
    _calendarManager = [JTCalendarManager new];
    _calendarManager.delegate = self;
    
    _calendarManager.settings.pageViewHaveWeekDaysView = NO;
    _calendarManager.settings.pageViewNumberOfWeeks = 0; // Automatic
    
    _weekDayView.manager = _calendarManager;
    [_weekDayView reload];
    
    // Generate random events sort by date using a dateformatter for the demonstration
//    [self createRandomEvents];
    
    [_calendarManager setMenuView:_calendarMenuView];
    [_calendarManager setContentView:_calendarContentView];
    [_calendarManager setDate:[NSDate date]];
    
    _calendarMenuView.scrollView.scrollEnabled = NO; // Scroll not supported with JTVerticalCalendarView
}

#pragma mark - Public

+ (instancetype)calendarPickerView
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] firstObject];
}


- (void)show
{
    CGAffineTransform transform = self.transform;
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    self.transform = CGAffineTransformTranslate(transform, 0, [UIScreen mainScreen].bounds.size.height);
    self.transform = CGAffineTransformScale(self.transform, 0.01, 0.01);
    [UIView animateWithDuration:.5 animations:^{
        self.transform = CGAffineTransformIdentity;
    }];
}

- (void)hide
{
    
    if (_delegate && [_delegate respondsToSelector:@selector(pickerView:viewWillDisappearWithDate:)]) {
        [_delegate pickerView:self viewWillDisappearWithDate:_dateSelected];
    }
    
    CGAffineTransform transform = self.transform;
    [UIView animateWithDuration:0.5 animations:^{
        self.transform = CGAffineTransformTranslate(transform, 0, [UIScreen mainScreen].bounds.size.height);
        self.transform = CGAffineTransformScale(self.transform, 0.01, 0.01);
    } completion:^(BOOL finished) {
        self.transform = CGAffineTransformIdentity;
        [self removeFromSuperview];
    }];
}



- (IBAction)calendarViewTaped:(UITapGestureRecognizer *)sender {
    [self hide];
    
}
- (IBAction)done:(UIButton *)sender {
    [self hide];
}

- (NSDate *)selectedDate
{
    return _dateSelected;
}

#pragma mark - CalendarManager delegate

// Exemple of implementation of prepareDayView method
// Used to customize the appearance of dayView
- (void)calendar:(JTCalendarManager *)calendar prepareDayView:(JTCalendarDayView *)dayView
{
    dayView.hidden = NO;
    
    // Hide if from another month
    if([dayView isFromAnotherMonth]){
        dayView.hidden = YES;
    }
    // Today
    else if([_calendarManager.dateHelper date:[NSDate date] isTheSameDayThan:dayView.date]){
        dayView.circleView.hidden = NO;
        dayView.circleView.backgroundColor = [UIColor blueColor];
        dayView.dotView.backgroundColor = [UIColor whiteColor];
        dayView.textLabel.textColor = [UIColor whiteColor];
    }
    // Selected date
    else if(_dateSelected && [_calendarManager.dateHelper date:_dateSelected isTheSameDayThan:dayView.date]){
        dayView.circleView.hidden = NO;
        dayView.circleView.backgroundColor = [UIColor redColor];
        dayView.dotView.backgroundColor = [UIColor whiteColor];
        dayView.textLabel.textColor = [UIColor whiteColor];
    }
    // Other month
    else if(![_calendarManager.dateHelper date:_calendarContentView.date isTheSameMonthThan:dayView.date]){
        dayView.circleView.hidden = YES;
        dayView.dotView.backgroundColor = [UIColor redColor];
        dayView.textLabel.textColor = [UIColor lightGrayColor];
    }
    // Another day of the current month
    else{
        dayView.circleView.hidden = YES;
        dayView.dotView.backgroundColor = [UIColor redColor];
        dayView.textLabel.textColor = [UIColor blackColor];
    }
    
//    if([self haveEventForDay:dayView.date]){
//        dayView.dotView.hidden = NO;
//    }
//    else{
//        dayView.dotView.hidden = YES;
//    }
}

- (void)calendar:(JTCalendarManager *)calendar didTouchDayView:(JTCalendarDayView *)dayView
{
    
    // 不能超过今天
    NSString *temp = [[self dateFormatter] stringFromDate:dayView.date];
    NSString *today = [[self dateFormatter] stringFromDate:[NSDate date]];
    if ([temp compare:today] == NSOrderedDescending) {
        
    }else{
        _dateSelected = dayView.date;
    }
    
    
    // Animation for the circleView
    dayView.circleView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.1, 0.1);
    [UIView transitionWithView:dayView
                      duration:.3
                       options:0
                    animations:^{
                        dayView.circleView.transform = CGAffineTransformIdentity;
                        [_calendarManager reload];
                    } completion:nil];
    
    
    // Don't change page in week mode because block the selection of days in first and last weeks of the month
    if(_calendarManager.settings.weekModeEnabled){
        return;
    }
    
    // Load the previous or next page if touch a day from another month
    
    if(![_calendarManager.dateHelper date:_calendarContentView.date isTheSameMonthThan:dayView.date]){
        if([_calendarContentView.date compare:dayView.date] == NSOrderedAscending){
            [_calendarContentView loadNextPageWithAnimation];
        }
        else{
            [_calendarContentView loadPreviousPageWithAnimation];
        }
    }
}


- (NSDateFormatter *)dateFormatter
{
    static NSDateFormatter *dateFormatter;
    if(!dateFormatter){
        dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = @"yyyy.MM.dd";
    }
    
    return dateFormatter;
}



@end
