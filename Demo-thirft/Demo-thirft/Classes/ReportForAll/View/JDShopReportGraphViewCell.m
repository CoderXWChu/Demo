//
//  JDShopReportGraphViewCell.m
//  Demo-thirft
//
//  Created by DanaChu on 16/9/9.
//  Copyright © 2016年 DanaChu. All rights reserved.
//

#import "JDShopReportGraphViewCell.h"
#import "PNChart.h"
#import "JDSalesAlertView.h"

@interface JDShopReportGraphViewCell()<PNChartDelegate>
@property (nonatomic, weak) UIView *topContentView; ///< <#注释#>
@property (nonatomic, weak) UIView *centerContentView; ///< <#注释#>
@property (nonatomic, weak) UIView *bottomContentView; ///< <#注释#>
@property (nonatomic, weak) UISegmentedControl *seg; ///< <#注释#>
@property (nonatomic, weak) UILabel *topLabel; ///< <#注释#>
@property (nonatomic) PNLineChart * lineChart;
@property (nonatomic) UIView *legend;
@property (nonatomic, assign) NSUInteger selectedIndex; ///< <#注释#>

@end

@implementation JDShopReportGraphViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
        [self addSubviews];
        [self initialBinding];
        self.seg.selectedSegmentIndex = 0;
    }
    return self;
}

- (void)setupUI
{
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)addSubviews
{
    UIView *topContentView = [UIView new];
    [self.contentView addSubview:topContentView];
    self.topContentView = topContentView;
    self.topContentView.backgroundColor = [UIColor clearColor];
    
    
    UILabel *label = [UILabel new];
    label.text = @"折线图";
    label.textAlignment = NSTextAlignmentRight;
    [topContentView addSubview:label];
    self.topLabel = label;
    self.topLabel.textColor = [JDTheme lightGrayForWord];
    self.topLabel.backgroundColor = [UIColor clearColor];
    
    
    UIView *centerContentView = [UIView new];
    [self.contentView addSubview:centerContentView];
    self.centerContentView = centerContentView;
    [self addSubview];
    
    
    UIView *bottomContentView = [UIView new];
    [self.contentView addSubview:bottomContentView];
    self.bottomContentView = bottomContentView;
    self.bottomContentView.backgroundColor = [UIColor clearColor];
    
    
    UISegmentedControl *seg = [[UISegmentedControl alloc] initWithItems:@[@"今天",@"星期"]];
    [bottomContentView addSubview:seg];
    seg.tintColor = PNGreen;
    self.seg = seg;
    
    [self addConstraints];
}

- (void)addConstraints
{
    [self.topContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView);
        make.top.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
        make.height.offset(44.f);
    }];
    
    [self.centerContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
        make.top.equalTo(self.topContentView.mas_bottom).offset(0);
        make.bottom.equalTo(self.bottomContentView.mas_top).offset(0);
    }];
    
    [self.bottomContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
        make.height.offset(44.f);
    }];
    
    [self.topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.topContentView).offset(-15);
        make.top.equalTo(self.topContentView);
        make.bottom.equalTo(self.topContentView);
        make.width.offset(150);
    }];
    
    [self.seg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bottomContentView);
        make.centerY.equalTo(self.bottomContentView);
    }];
}

- (void)addSubview
{
    self.lineChart = [[PNLineChart alloc] initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, 200.0)];
    self.lineChart.backgroundColor = [UIColor clearColor];
    self.lineChart.showLabel = YES;
    [self.lineChart setXLabels:[self getXLabel]];
    self.lineChart.showCoordinateAxis = YES;
    
    self.lineChart.yGridLinesColor = [UIColor orangeColor];
    self.lineChart.showYGridLines = NO;
    
    NSArray *arr = [self getYLabel];
    self.lineChart.yFixedValueMin = 0.0;
    self.lineChart.yFixedValueMax = ((NSString *)arr.lastObject).doubleValue;
    [self.lineChart setYLabels:arr];
    self.lineChart.yUnit = @"元";
    self.lineChart.yLabelColor = PNLightGrey;
    self.lineChart.xLabelColor = PNLightGrey;
    
    // Line Chart #1
    if (self.chartDatasForDay || self.chartDatasForWeek) {
        
        NSArray * data01Array = self.selectedIndex ? [self getWeekData] :  [self getDayData];
        PNLineChartData *data01 = [PNLineChartData new];
        data01.dataTitle = @"销售额";
        data01.color = PNDeepGreen;
        data01.alpha = 0.8f;
        data01.itemCount = data01Array.count;
        data01.inflexionPointColor = PNRed;
        data01.inflexionPointStyle = PNLineChartPointStyleTriangle;
        data01.getData = ^(NSUInteger index) {
            CGFloat yValue = [data01Array[index] floatValue];
            return [PNLineChartDataItem dataItemWithY:yValue];
        };
        self.lineChart.chartData = @[data01];
    }
    
    [self.lineChart strokeChart];
    self.lineChart.delegate = self;
    
    [self.centerContentView addSubview:self.lineChart];
    
    self.lineChart.legendStyle = PNLegendItemStyleSerial;
    self.lineChart.legendFont = [UIFont boldSystemFontOfSize:12.0f];
    self.lineChart.legendFontColor = [UIColor redColor];
    
    self.legend = [self.lineChart getLegendWithMaxWidth:320];
    [self.legend setFrame:CGRectMake(0, 100, self.legend.frame.size.width, self.legend.frame.size.width)];
    [self.centerContentView addSubview:self.legend];
    
    [self.lineChart mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.centerContentView);
        make.left.equalTo(self.centerContentView).offset(10);
        make.right.equalTo(self.centerContentView);
        make.bottom.equalTo(self.centerContentView.mas_bottom).offset(-30);
    }];
    
    [self.legend mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineChart.mas_bottom);
        make.left.equalTo(self.centerContentView);
        make.right.equalTo(self.centerContentView);
        make.bottom.equalTo(self.centerContentView.mas_bottom);
    }];
    
    [self.lineChart.xChartLabels enumerateObjectsUsingBlock:^(UILabel*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.textAlignment = NSTextAlignmentLeft;
    }];
    
}


- (void)initialBinding
{
    @weakify(self);
    [RACObserve(self, selectedIndex) subscribeNext:^(NSNumber *x) {
        @strongify(self);
        [self.lineChart removeFromSuperview];
        [self.legend removeFromSuperview];
        self.legend = nil;
        self.lineChart = nil;
        [self addSubview];
    }];
    
    [[RACObserve(self, chartDatasForDay) filter:^BOOL(id value) {
        return value ? YES : NO;
    }]
     subscribeNext:^(NSArray *x) {
         @strongify(self);
        if (self.selectedIndex == 1) return;
         [self.lineChart removeFromSuperview];
         [self.legend removeFromSuperview];
         self.legend = nil;
        self.lineChart = nil;
        [self addSubview];
    }];
    
    [[RACObserve(self, chartDatasForWeek) filter:^BOOL(id value) {
        return value ? YES : NO;
    }]
     subscribeNext:^(NSArray *x) {
         @strongify(self);
         if (self.selectedIndex == 0) return;
         [self.lineChart removeFromSuperview];
         [self.legend removeFromSuperview];
         self.legend = nil;
         self.lineChart = nil;
         [self addSubview];
     }];
    
    [RACObserve(self.seg, selectedSegmentIndex) subscribeNext:^(NSNumber * x) {
        self.selectedIndex = x.integerValue;
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

- (NSArray *)getYLabel
{

    double x = 0.f;
    NSArray *temp = self.selectedIndex ? [self getWeekData] : [self getDayData];
    if(!self.chartDatasForWeek && !self.chartDatasForDay)
        temp = @[@(3000)];
    
    for (NSNumber *n in temp) {
        x = MAX(x, n.doubleValue);
    }
//    NSLog(@"arr.maxValue = %0.f", x);
    double y = x;
    int i = 0;
    while (y > 10) {
        y /= 10;
        i++;
    }
    y = ceil(y * 10 / 8);
    NSMutableArray *arr = [[NSMutableArray alloc]initWithCapacity:0];
    for (int j = 0; j <= y ; j++) {
        [arr addObject:[NSString stringWithFormat:@"%0.f", j* pow(10, i)]];
    }
//    NSLog(@"arr.lastObject = %@", arr.lastObject);
    return arr;
}


- (NSArray *)getDayData
{
    if (!_chartDatasForDay) return @[];
    
    NSMutableArray *temp = [@[] mutableCopy];
    [_chartDatasForDay enumerateObjectsUsingBlock:^(NSArray* obj, NSUInteger idx, BOOL * _Nonnull stop) {
       __block double total = 0;
       [obj enumerateObjectsUsingBlock:^(TTGDailyDataForSale * obj, NSUInteger idx, BOOL * _Nonnull stop) {
           total += obj.sales;
       }];
        [temp addObject:@(total)];
    }];
    return [temp copy];
}

- (NSArray *)getWeekData
{
    if (!_chartDatasForWeek) return @[];
    
    NSMutableArray *temp = [@[] mutableCopy];
    [_chartDatasForWeek enumerateObjectsUsingBlock:^(NSArray* obj, NSUInteger idx, BOOL * _Nonnull stop) {
        __block double total = 0;
        [obj enumerateObjectsUsingBlock:^(TTGDailyDataForSale * obj, NSUInteger idx, BOOL * _Nonnull stop) {
            total += obj.sales;
        }];
        [temp addObject:@(total)];
    }];
    return [temp copy];
}


+ (NSString *)cellIdentifier
{
    return @"JDShopReportGraphViewCellIdentifier";
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

#pragma mark - PNChartDelegate

- (void)userClickedOnLineKeyPoint:(CGPoint)point lineIndex:(NSInteger)lineIndex pointIndex:(NSInteger)pointIndex{
    NSLog(@"Click Key on line %f, %f line index is %d and point index is %d",point.x, point.y,(int)lineIndex, (int)pointIndex);
    
    NSArray *temp = self.selectedIndex ? self.chartDatasForWeek : self.chartDatasForDay;
     [JDSalesAlertView showSalesAlertWithData:temp[pointIndex]];
    
}

- (void)userClickedOnLinePoint:(CGPoint)point lineIndex:(NSInteger)lineIndex{
    NSLog(@"Click on line %f, %f, line index is %d",point.x, point.y, (int)lineIndex);

    
}

@end
