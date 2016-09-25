//
//  JDTakeAwayReportView.m
//  Demo-thirft
//
//  Created by DanaChu on 16/9/13.
//  Copyright © 2016年 DanaChu. All rights reserved.
//

#import "JDTakeAwayReportView.h"
#import "JDTakeAwayCollectionView.h"
#import "PNChart.h"
#import "JDTakeAwayAlertView.h"

@interface JDTakeAwayReportView()<PNChartDelegate>

@property (nonatomic, strong) JDTakeAwayCollectionView *displayView;
@property (nonatomic, weak) UIView * midView;
@property (nonatomic, weak) PNBarChart * barChart;
@property (nonatomic, weak) UISegmentedControl *seg; ///< <#注释#>
@property (nonatomic, assign) NSUInteger selectedIndex; ///< <#注释#>

@end

@implementation JDTakeAwayReportView

- (instancetype)init
{
    if (self = [super init]) {
        [self setupUI];
        [self initialBinding];
    }
    return self;
}

- (void)setupUI
{
    _displayView = [JDTakeAwayCollectionView new];
    [self addSubview:_displayView];
    
    UIView *midView = [UIView new];
    midView.backgroundColor = [UIColor clearColor];
    [self addSubview:midView];
    _midView = midView;
    
    UISegmentedControl *seg = [[UISegmentedControl alloc] initWithItems:@[@"今天",@"星期"]];
    [self addSubview:seg];
    seg.tintColor = PNGreen;
    _seg = seg;
    _seg.selectedSegmentIndex = 0;
    
    [self.displayView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.topMargin.offset(JDTakeAwayCellMargin);
        make.leftMargin.offset(JDTakeAwayCellMargin);
        make.rightMargin.offset(-JDTakeAwayCellMargin);
        make.height.offset(JDTakeAwayDisplayHeight);
    }];
    
    [self.midView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.displayView.mas_bottom).offset(10);
        make.leftMargin.offset(0);
        make.rightMargin.offset(0);
        make.height.offset(200);
    }];
    
    [self.seg mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.midView.mas_bottom).offset(10);
        make.bottomMargin.offset(-20);
        make.centerX.offset(0);
    }];
}

- (void)addBarChartViewWithData:(NSArray<NSArray <TTGTakeAwayInfo *>*> *)originData
{
    if (_barChart != nil) {
        [_barChart removeFromSuperview];
        _barChart = nil;
    }
    
    if (originData == nil) return;
    
    PNBarChart *barChart = [[PNBarChart alloc] initWithFrame:CGRectMake(0, 135.0, SCREEN_WIDTH, 200.0)];
    _barChart = barChart;
    [self.midView addSubview:barChart];
    
    [self.barChart mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    self.barChart.showLabel = YES;
    self.barChart.backgroundColor = [UIColor clearColor];

    self.barChart.yLabelFormatter = ^(CGFloat yValue){
        return [NSString stringWithFormat:@"%0.f", yValue];
    };
    self.barChart.labelTextColor = PNLightGrey;
    self.barChart.yChartLabelWidth = 20.0;
    self.barChart.chartMarginLeft = 30.0;
    self.barChart.chartMarginRight = 10.0;
    self.barChart.chartMarginTop = 5.0;
    self.barChart.chartMarginBottom = 10.0;
    self.barChart.labelMarginTop = 5.0;
    self.barChart.showChartBorder = YES;
    
    
//    NSMutableArray *arrOne = [[NSMutableArray alloc]initWithCapacity:0];
//    NSMutableArray *arrTwo = [[NSMutableArray alloc]initWithCapacity:0];
//    int maxCount = 0;
//    int minCount = data[0].countT;
//    for (TTGTakeAwayInfo *info in data) {
//        [arrOne addObject:[NSString stringWithFormat:@"%d", info.countT]];
//        [arrTwo addObject:[self getNameWithInfo:info]];
//        MAX(maxCount, info.countT);
//        MIN(minCount, info.countT);
//    }
    // 尝试调整条形图的Y轴最大最小值，是条形图在图形的中间位置
    //self.barChart.yMaxValue = ceil(maxCount * 1.0 / 0.9);
    //self.barChart.yMinValue = ceil(minCount * 0.5);
    [self.barChart setXLabels:[self getXLabel]];
    [self.barChart setYValues:[self getFinalDataWithData:originData]];
    
    [self.barChart setStrokeColors:@[PNGreen,PNGreen,PNGreen,PNGreen,PNGreen,PNGreen,PNGreen,PNGreen]];
    self.barChart.isGradientShow = YES;
    self.barChart.isShowNumbers = NO;
    [self.barChart strokeChart];
    self.barChart.delegate = self;
    
}

- (void)initialBinding
{
    @weakify(self)
    [RACObserve(self.seg, selectedSegmentIndex) subscribeNext:^(NSNumber * x) {
        @strongify(self)
        self.selectedIndex = x.integerValue;
        NSArray *y = self.selectedIndex ? self.takeAwayInfoListInWeekTime : self.takeAwayInfoListInDayTime;
        [self addBarChartViewWithData:y];
        [self setNeedsLayout];
    }];
    
    [RACObserve(self, takeAwayInfoList) subscribeNext:^(NSArray * x) {
        @strongify(self);
        self.displayView.datasource = x;
        CGFloat height = ((x.count - 1) / JDTakeAwayCellCountForRow + 1 ) * (JDTakeAwayCellHeight + JDTakeAwayCellMargin) - JDTakeAwayCellMargin;
        [self.displayView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.topMargin.offset(0);
            make.leftMargin.offset(0);
            make.rightMargin.offset(0);
            make.height.offset(height);
        }];
    }];
    
    [[[RACObserve(self, takeAwayInfoListInDayTime) combineLatestWith:RACObserve(self, takeAwayInfoListInWeekTime)] skip:1] subscribeNext:^(id x) {
        @strongify(self)
        NSArray *y = self.selectedIndex ? self.takeAwayInfoListInWeekTime : self.takeAwayInfoListInDayTime;
        [self addBarChartViewWithData:y];
        [self setNeedsLayout];
    }];
}


- (NSArray *)getXLabel
{
    if (self.selectedIndex == 0) {
        return @[@"早上",@"中午",@"下午",@"晚上"];
    }else{
        return @[@"MON",@"TUE",@"WED",@"THU",@"FRI",@"SAT",@"SUN"];
    }
}

- (NSArray *)getFinalDataWithData:(NSArray<NSArray <TTGTakeAwayInfo *>*> *)data
{
    if (!data) return @[];
    NSMutableArray *temp = [@[] mutableCopy];
    [data enumerateObjectsUsingBlock:^(NSArray<TTGTakeAwayInfo *> * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop){
        __block int total = 0;
        [obj enumerateObjectsUsingBlock:^(TTGTakeAwayInfo * obj, NSUInteger idx, BOOL * _Nonnull stop) {
            total += obj.countT;
        }];
        [temp addObject:[NSString stringWithFormat:@"%d", total]];
    }];
    return [temp copy];
}



#pragma mark - <PNChartDelegate>

- (void)userClickedOnBarAtIndex:(NSInteger)barIndex
{

    PNBar * bar = [self.barChart.bars objectAtIndex:barIndex];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    
    animation.fromValue = @1.0;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.toValue = @1.1;
    animation.duration = 0.2;
    animation.repeatCount = 0;
    animation.autoreverses = YES;
    animation.removedOnCompletion = YES;
    animation.fillMode = kCAFillModeForwards;
    
    [bar.layer addAnimation:animation forKey:@"Float"];
    
    NSArray *y = self.selectedIndex ? self.takeAwayInfoListInWeekTime : self.takeAwayInfoListInDayTime;
    
    [JDTakeAwayAlertView showTakeAwayAlertWithData:y[barIndex]];
    
}

@end
