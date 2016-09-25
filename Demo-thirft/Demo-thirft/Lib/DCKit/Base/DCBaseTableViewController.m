//
//  DCBaseTableViewController.m
//  Demo-集成EaseMobUI3.0
//
//  Created by DanaChu on 16/5/4.
//  Copyright © 2016年 DanaChu. All rights reserved.
//

#import "DCBaseTableViewController.h"

@interface DCBaseTableViewController ()<DZNEmptyDataSetDelegate,DZNEmptyDataSetSource>

@property (nonatomic, strong) MJRefreshNormalHeader *header;
@property (nonatomic, strong) MJRefreshAutoNormalFooter *footer;

@end

@implementation DCBaseTableViewController

#pragma mark - getter setter

- (MJRefreshNormalHeader *)header
{
    if (!_header) {
        __weak typeof(self) weakSelf = self;
        _header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf pullDownRefreshAction];
        }];
        [self setupRefreshHeaderStyleWithHandle:^(MJRefreshNormalHeader *header) {
            header.lastUpdatedTimeLabel.hidden = YES; // 默认隐藏
            header.stateLabel.hidden = YES; // 默认隐藏
        }];
    }
    return _header;
}

- (MJRefreshAutoNormalFooter *)footer
{
    if (!_footer) {
        __weak typeof(self) weakSelf = self;
        _footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [weakSelf pullUpLoadMoreFunction];
        }];
        [self setupRefreshFooterStyleWithHandle:^(MJRefreshAutoNormalFooter *footer) {
            footer.stateLabel.hidden = YES; //默认
        }];
    }
    return _footer;
}

- (void)setIsSupportEmptyDataMode:(BOOL)isSupportEmptyDataMode
{
    _isSupportEmptyDataMode = isSupportEmptyDataMode;
    if (_isSupportEmptyDataMode) {
        self.tableView.emptyDataSetDelegate = self;
        self.tableView.emptyDataSetSource = self;
    }else{
        self.tableView.emptyDataSetSource = nil;
        self.tableView.emptyDataSetDelegate = nil;
    }
}

- (void)setIsHasRefreshHeader:(BOOL)isHasRefreshHeader
{
    _isHasRefreshHeader = isHasRefreshHeader;
    if (isHasRefreshHeader) {
       
        self.tableView.mj_header = self.header;
    }else{
        
        self.tableView.mj_header = nil;
    }
    
}
- (void)setIsHasRefreshFooter:(BOOL)isHasRefreshFooter
{
    _isHasRefreshFooter = isHasRefreshFooter;
    
    if (_isHasRefreshFooter) {
        
        self.tableView.mj_footer = self.footer;
    }else{
        
        self.tableView.mj_footer = nil;
    }
}


#pragma mark - Public Action

- (void)pullDownRefreshAction
{
}

- (void)pullUpLoadMoreFunction
{
}

- (void)setupRefreshHeaderStyleWithHandle:(setupRefreshHeaderBlock)handle
{
    if(handle){
        _isHasRefreshHeader = YES;
        self.tableView.mj_header = self.header;
        handle(_header);
    }
}

- (void)setupRefreshFooterStyleWithHandle:(setupRefreshFooterBlock)handle
{
    if (handle) {
        _isHasRefreshFooter = YES;
        self.tableView.mj_footer = self.footer;
        handle(_footer);
    }
}

- (void)headerBeginRefresh
{
    if (_isHasRefreshHeader) {
        [self.tableView.mj_header beginRefreshing];
    }
}

- (void)footerBeginRefresh
{
    if (_isHasRefreshFooter) {
        [self.tableView.mj_footer beginRefreshing];
    }
}

- (void)headerEndRefresh
{
    if (_isHasRefreshHeader) {
        [self.tableView.mj_header endRefreshing];
    }
}

- (void)footerEndRefresh
{
    if (_isHasRefreshFooter) {
        [self.tableView.mj_footer endRefreshing];
    }
}

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc]initWithCapacity:0];
    }
    return _dataArray;
}

- (void)tableViewDidFinishRefreshData:(BOOL)isHeader reload:(BOOL)reload
{
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (reload) {
            [weakSelf.tableView reloadData];
        }
        
        if (isHeader) {
            [self headerEndRefresh];
        }
        else{
            [self footerEndRefresh];
        }
    });
}


#pragma mark - Life Circle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _shouldAllowScrollForEmptyData = YES;
    _verticalOffsetForEmptyData = -100;
    _backgroundColorForEmptyData = [UIColor clearColor];
    _imageForEmptyData = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier" forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([self.tableView respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
}

#pragma mark - Empty data set

#pragma mark - Empty data set

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    
    NSString *text = _titleForEmptyData;
    
    [UIFont familyNames];
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont fontWithName:@"Kailasa" size:15.f],
                                 NSForegroundColorAttributeName:[UIColor colorWithRed:((87.0) / 255.0) green:((87.0) / 255.0) blue:((87.0) / 255.0) alpha:1.0]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return _imageForEmptyData;
}

- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView
{
    return _backgroundColorForEmptyData;
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView
{
    return _verticalOffsetForEmptyData;
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView
{
    return _shouldAllowScrollForEmptyData;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/




@end
