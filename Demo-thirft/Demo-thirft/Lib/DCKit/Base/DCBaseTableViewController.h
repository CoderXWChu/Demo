//
//  DCBaseTableViewController.h
//  Demo-集成EaseMobUI3.0
//
//  Created by DanaChu on 16/5/4.
//  Copyright © 2016年 DanaChu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIScrollView+EmptyDataSet.h"
#import "MJRefresh.h"

#define KXColor(r, g, b, a) [UIColor colorWithRed:((r)/255.0) green:((g)/255.0) blue:((b)/255.0) alpha:(1.0)];

typedef void(^setupRefreshHeaderBlock)(MJRefreshNormalHeader *header);
typedef void(^setupRefreshFooterBlock)(MJRefreshAutoNormalFooter *footer);



@interface DCBaseTableViewController : UITableViewController

@property (nonatomic, assign) BOOL isHasRefreshHeader; /**< 是否具有下拉刷新 */
@property (nonatomic, assign) BOOL isHasRefreshFooter; /**< 是否具有上拉加载更多 */
@property (nonatomic, assign) BOOL isSupportEmptyDataMode; /**< 是否支持空数据模式 */

// data relation
@property (nonatomic, strong) NSMutableArray *dataArray;

// Property For EmptyData
@property (nonatomic, strong) UIImage *imageForEmptyData; /**< 空数据时显示的图片 */
@property (nonatomic, copy) NSString *titleForEmptyData; /**< 空数据时显示的文字 */
@property (nonatomic, strong) UIColor *backgroundColorForEmptyData; /**< 空数据时的背景颜色 */
@property (nonatomic, assign) CGFloat verticalOffsetForEmptyData; /**< 垂直偏移量 */
@property (nonatomic, assign) BOOL shouldAllowScrollForEmptyData; /**< 是否允许滚动 */



/*!
 *  下拉刷新时调用
 *  Override this method if need to do something , default to do nothing
 */
- (void)pullDownRefreshAction;
/*!
 *  上拉加载更多时调用
 *  Override this method if need to do something , default to do nothing
 */
- (void)pullUpLoadMoreFunction;
/*!
 *  用于设置下拉刷新控件的样式, 需主动调用
 *  @param handle 设置样式的block
 *  Perform this method if need to set the style of refreshHeader . If performing,
 *  default to set the property 'isHasRefreshHeader' to 'YES'.
 */
- (void)setupRefreshHeaderStyleWithHandle:(setupRefreshHeaderBlock)handle;
/*!
 *  用于设置上拉加载更多控件的样式, 需主动调用
 *  @param handle 设置样式的block
 *  Perform this method if need to set the style of refreshFooter. If performing,
 *  default to set the property 'isHasRefreshFooter' to 'YES'.
 */
- (void)setupRefreshFooterStyleWithHandle:(setupRefreshFooterBlock)handle;

/*!
 *  下拉刷新,上拉加载更多时调用
 *  Perform these methods, load Or stop loading data.
 */
- (void)headerBeginRefresh;
- (void)footerBeginRefresh;
- (void)headerEndRefresh;
- (void)footerEndRefresh;

/*!
 *  数据刷新完以后调用,用来刷新列表, 停止刷新
 *  @param isHeader 是否为头部控件
 *  @param reload   是否刷新页面
 */
- (void)tableViewDidFinishRefreshData:(BOOL)isHeader reload:(BOOL)reload;

@end
