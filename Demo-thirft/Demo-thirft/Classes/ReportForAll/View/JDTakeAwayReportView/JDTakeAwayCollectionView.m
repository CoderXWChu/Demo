//
//  JDTakeAwayCollectionView.m
//  Demo-thirft
//
//  Created by DanaChu on 2016/9/22.
//  Copyright © 2016年 DanaChu. All rights reserved.
//

#import "JDTakeAwayCollectionView.h"

@interface JDTakeAwayCollectionView()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation JDTakeAwayCollectionView


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
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    CGFloat width = [UIScreen mainScreen].bounds.size.width - 10;
    CGFloat lwidth = ceil((width - (JDTakeAwayCellCountForRow + 1)*JDTakeAwayCellCountForRow ) / JDTakeAwayCellCountForRow);
    layout.itemSize = CGSizeMake(lwidth, JDTakeAwayCellHeight);
    layout.minimumInteritemSpacing = JDTakeAwayCellMargin * 0.5;
    layout.minimumLineSpacing = JDTakeAwayCellMargin;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _collectionView.scrollEnabled = NO;
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    [self addSubview:_collectionView];
    
    _collectionView.layer.cornerRadius = 5;
    _collectionView.layer.borderWidth = 1;
    _collectionView.layer.borderColor = [JDTheme borderColor].CGColor;
    _collectionView.clipsToBounds = YES;
    
    [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsMake(5, 5, 0, 5));
    }];
    
    [self.collectionView registerClass:[JDTakeWayCollectionViewCell class] forCellWithReuseIdentifier:[JDTakeWayCollectionViewCell identifierForSubCell]];
}

- (void)initialBinding
{
    @weakify(self)
    [RACObserve(self, datasource) subscribeNext:^(NSArray * x) {
        @strongify(self);
        [self.collectionView reloadData];
    }];
}


#pragma mark - UICollectionViewDelegate , UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.datasource.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JDTakeWayCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[JDTakeWayCollectionViewCell identifierForSubCell] forIndexPath:indexPath];
    cell.info = self.datasource[indexPath.row];
    if ((indexPath.item + 1) % JDTakeAwayCellCountForRow == 0) {
        cell.VerticalMarginView.hidden = YES;
    }else{
        cell.VerticalMarginView.hidden = NO;
    }
    return cell;
}

//- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
//    if (_delegate) {
//        [_delegate executiveCommandWithComInfo:(MDSbcom *)self.sbcoms[indexPath.item]];
//    }
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end


@interface JDTakeWayCollectionViewCell()

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *countLabel;
@property (nonatomic, strong) UIView *HorizontalMarginView;

@end

@implementation JDTakeWayCollectionViewCell


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
        [self initialBinding];
    }
    return self;
}

- (void)setupUI
{
    self.contentView.backgroundColor = [UIColor clearColor];
    self.backgroundColor = [UIColor clearColor];
    
//    self.layer.cornerRadius = 2;
//    self.layer.borderWidth = 1;
//    self.layer.borderColor = [JDTheme borderColor].CGColor;
//    self.clipsToBounds = YES;
    
    _nameLabel = [UILabel new];
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    _nameLabel.backgroundColor = [UIColor clearColor];
    _nameLabel.textColor = [JDTheme wordColor];
    [self addSubview:_nameLabel];
    
    _HorizontalMarginView = [UIView new];
    _HorizontalMarginView.backgroundColor = [JDTheme borderColor];
    [self addSubview:_HorizontalMarginView];
    
    _countLabel = [UILabel new];
    _countLabel.textAlignment = NSTextAlignmentCenter;
    _countLabel.backgroundColor = [UIColor clearColor];
    _countLabel.textColor = [JDTheme wordColor];
    [self addSubview:_countLabel];
    
    
    _VerticalMarginView = [UIView new];
    _VerticalMarginView.backgroundColor = [JDTheme borderColor];
    [self addSubview:_VerticalMarginView];
    
    [self addSubviewConstraints];
}

- (void)initialBinding
{
    @weakify(self)
    [RACObserve(self, info) subscribeNext:^(TTGTakeAwayInfo * x) {
        @strongify(self)
        self.nameLabel.text = [self getNameWithInfo:x];
        self.countLabel.text = [NSString stringWithFormat:@"%d 单", x.countT];
    }];
}

- (void)addSubviewConstraints
{
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.leftMargin.offset(0);
        make.rightMargin.offset(0);
        make.height.equalTo(self.mas_height).multipliedBy(0.5).offset(-1);
    }];
    
    [self.HorizontalMarginView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).offset(0);
        make.leftMargin.offset(15);
        make.rightMargin.offset(-15);
        make.height.offset(1);
    }];
    
    [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.HorizontalMarginView.mas_bottom).offset(0);
        make.leftMargin.offset(0);
        make.rightMargin.offset(0);
        make.bottomMargin.offset(0);
    }];
    
    [self.VerticalMarginView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.topMargin.offset(10);
        make.bottomMargin.offset(-10);
        make.rightMargin.offset(0);
        make.width.offset(1);
    }];
    
}

- (NSString *)getNameWithInfo:(TTGTakeAwayInfo *)x
{
    /*
     TakeAwayType_TakeAwayTypePhone = 0,
     TakeAwayType_TakeAwayTypeBaidu = 1,
     TakeAwayType_TakeAwayTypeEleme = 2,
     TakeAwayType_TakeAwayTypeKoubei = 3,
     TakeAwayType_TakeAwayTypeMeituan = 4
     */
    NSString *name = @"";
    switch (x.type) {
        case TakeAwayType_TakeAwayTypePhone:
            name = @"电话";
            break;
        case TakeAwayType_TakeAwayTypeBaidu:
            name = @"百度";
            break;
        case TakeAwayType_TakeAwayTypeEleme:
            name = @"饿了么";
            break;
        case TakeAwayType_TakeAwayTypeKoubei:
            name = @"口碑";
            break;
        case TakeAwayType_TakeAwayTypeMeituan:
            name = @"美团";
            break;
    }
    return name;
}

+ (NSString *)identifierForSubCell
{
    return @"JDTakeWayCollectionViewCellidentifierForSubCell";
}

@end



