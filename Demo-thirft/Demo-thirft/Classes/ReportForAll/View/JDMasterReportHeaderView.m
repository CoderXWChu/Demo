//
//  JDMasterReportHeaderView.m
//  Demo-thirft
//
//  Created by DanaChu on 16/8/29.
//  Copyright © 2016年 DanaChu. All rights reserved.
//

#import "JDMasterReportHeaderView.h"
#import "JDCalendarPickerView.h"

@interface JDMasterReportHeaderView()<JDCalendarPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIButton *dateButton;
@property (nonatomic, strong) JDCalendarPickerView *calendarView; ///< 日历控件

@end

@implementation JDMasterReportHeaderView


- (void)awakeFromNib
{
    [super awakeFromNib];
    self.dateLabel.text = @"今天";
    self.layer.cornerRadius = 5.f;
    self.clipsToBounds = YES;
}

+ (instancetype)headerView
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] firstObject];
}

- (IBAction)clickedAction:(UIButton *)sender {
    
    NSLog(@"弹出日历控件");

    [self.calendarView show];
}

- (void)updateIfNeeded
{
    if (self.calendarView) {
        [self.calendarView removeFromSuperview];
        self.calendarView = nil;
    }
}


- (NSString *)dateStringWithDate:(NSDate *)date
{
    NSString *temp = [[self dateFormatter] stringFromDate:date];
    NSString *today = [[self dateFormatter] stringFromDate:[NSDate date]];
    if ([temp isEqualToString:today]) {
        return @"今天";
    }

    return temp;
}

#pragma mark - JDCalendarPickerViewDelegate

- (void)pickerView:(JDCalendarPickerView *)picker viewWillDisappearWithDate:(NSDate *)date
{
    self.dateLabel.text = [self dateStringWithDate:date];
    self.dateSelected = [[self dateFormatter] dateFromString:self.dateLabel.text];
}


#pragma mark - getter setter

- (NSDateFormatter *)dateFormatter
{
    static NSDateFormatter *dateFormatter;
    if(!dateFormatter){
        dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = @"yyyy.MM.dd";
    }
    
    return dateFormatter;
}

- (JDCalendarPickerView *)calendarView
{
    if (!_calendarView) {
        _calendarView = [JDCalendarPickerView calendarPickerView];
        [_calendarView setFrame:[UIScreen mainScreen].bounds];
        _calendarView.delegate = self;
    }
    return _calendarView;
}


@end
