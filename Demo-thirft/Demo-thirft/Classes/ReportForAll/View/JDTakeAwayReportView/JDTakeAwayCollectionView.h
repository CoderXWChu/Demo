//
//  JDTakeAwayCollectionView.h
//  Demo-thirft
//
//  Created by DanaChu on 2016/9/22.
//  Copyright © 2016年 DanaChu. All rights reserved.
//

#import <UIKit/UIKit.h>

#define JDTakeAwayDisplayHeight 100
#define JDTakeAwayCellCountForRow  3
#define JDTakeAwayCellHeight  (ceil(SCREEN_HEIGHT * 50 / 375))
#define JDTakeAwayCellMargin  5.f


@interface JDTakeAwayCollectionView : UIView

@property (nonatomic, strong) NSArray *datasource; ///< <#注释#>

@end

@interface JDTakeWayCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) TTGTakeAwayInfo *info; ///< <#注释#>

@property (nonatomic, strong) UIView *VerticalMarginView;

+ (NSString *)identifierForSubCell;

@end
