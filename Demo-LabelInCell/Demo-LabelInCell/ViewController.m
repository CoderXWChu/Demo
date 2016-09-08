//
//  ViewController.m
//  Demo-LabelInCell
//
//  Created by DanaChu on 14/9/6.
//  Copyright © 2014年 DanaChu. All rights reserved.
//

#import "ViewController.h"
#import "DCChatViewCell.h"
#import "FLRightChatTVCell.h"
#import <CoreText/CoreText.h>

@interface ViewController ()
@property (nonatomic, strong) NSArray *datasource;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.title = @"Demo";
    _datasource = @[@"阿鲁纳恰尔邦asdf公民社『』会称，☺️😍😏有藏族人伪装成商人进入该地区并长期定居，很难将他们与当地的门巴人、夏尔asdfasdfasda🤓😶😶😒😡😠😛巴人或者舍sdfas度苯人区别开来，因为他们在宗教和种族上都很相似。该组织还要sdfasdf求政府立刻成立一个专家委🤑🤓员asdfa会来研究“西藏难民”问题😀😬😁😅😄😃☺️🙃😇☺️😘😜🤓😎|",
                    @"阿鲁纳恰尔asdf邦公民社会称，☺️😍😏有藏族asdf人伪装成商人进入该地区并长期定居，很难将他们与当地的门巴人、夏尔🤓😶😶😒😡😠😛巴人|",
                    @"☺️😍😏🤓😶sdfsd😡😠😛巴人|",
                    @"☺️😍😏asdfa🤓😶😶asa😒😡😠😛|",
                     @"☺️😛asdf西jkwe8研究asdf西藏🤓😶难西怎么样了阿藏阿萨sdnf|",
                    @"会来研🤓😶究西jkwe8怎研究asdf西藏🤓😶难西研究asdf西藏🤓😶难西么样了阿藏难adadfsfa|",
                    @"一个专家asdf来研究asdf西藏🤓😶难研究asdf西藏🤓😶难西研究asdf西藏🤓😶难西研究asdf西藏🤓😶难西西藏难asdfasf|",
                    @"一个专asdf员🤓😶会来研asdsdfa藏研究asdf西藏🤓😶难西研究asdf西藏🤓😶难西研究asdf西藏🤓😶难西研究asdf西藏🤓😶难西难研究西藏难asfasdf|",
                    @"一个专家委员会🤓sfas😶来研as研究asdf西藏🤓😶难西研究asdf西藏🤓😶难西研究asdf西藏🤓😶难西研究asdf西藏🤓😶难西研究asdf西藏🤓😶难西df究难研究西藏难研难asfasf|",
                    @"一个专家委asdfasdf员dfasd会研究asdf西藏🤓😶难西研究asdf西藏🤓😶难西研究asdf西藏🤓😶难西研究asdf西藏🤓😶难西研究asdf西藏🤓😶难西研究asdf西藏🤓😶难西西sdfalkasn西藏难西藏西难asdfad|",
                    @"一个专家员会asdf来研asd研究asdf西藏🤓😶难西研究asdf西藏🤓😶难西研究asdf西藏🤓😶难西研究asdf西藏🤓😶难西研究asdf西藏🤓😶难西研究asdf西藏🤓😶难西f究西藏难西藏西🤓😶藏西藏西西藏难asdfasdf|",
                    @"一个员会来研究dfasd研究asdf西藏🤓😶难西研究asdf西藏🤓😶难西研究asdf西藏🤓😶难西研究asdf西藏🤓😶难西研究asdf西藏🤓😶难西研究asdf西藏🤓😶难西研究asdf西藏🤓😶难西f西藏难西藏🤓😶西asdf藏藏西jlknkl藏西藏难adfafaf|",
                    @"一个专fasdf员会来研究asdf西藏🤓😶难西研究asdf西藏🤓😶难西研究asdf西藏🤓😶难西研究asdf西藏🤓😶难西研究asdf西藏🤓😶难西研究asdf西藏🤓😶难西研究asdf西藏🤓😶难西研究asdf西藏🤓😶难西研究asdf西藏🤓😶难西研🤓asdfas😶究西藏西sdfgsdasd西藏西藏西藏西藏难afadfaf|",
                    @"一个专家会来研究西asdf藏难西藏🤓😶西藏asdf西藏西藏asdadfas 西藏西藏难adfasdf|",
                    @"一个专员会🤓😶来研究西藏难s研究asdf西藏🤓😶难西研究asdf西藏🤓😶难西研究asdf西藏🤓😶难西研究asdf西藏🤓😶难西研究asdf西藏🤓😶难西研究asdf西藏🤓😶难西研究asdf西藏🤓😶难西研究asdf西藏🤓😶难西研究asdf西藏🤓😶难西研究asdf西藏🤓😶难西df西藏西藏西藏西藏asdfa西藏西藏西sdfg藏西藏西藏难adsasdf|",
                    ];
    //自动估算
//    self.tableView.rowHeight = UITableViewAutomaticDimension;
//    self.tableView.estimatedRowHeight = 100;、
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([DCChatViewCell class]) bundle:nil] forCellReuseIdentifier:DCChatSenderCellID];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([FLRightChatTVCell class]) bundle:nil] forCellReuseIdentifier:@"Cell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _datasource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DCChatViewCell *cell = [tableView dequeueReusableCellWithIdentifier:DCChatSenderCellID];
        cell.message = _datasource[indexPath.row];
    
//    FLRightChatTVCell *cell = [FLRightChatTVCell cellWithTableView:tableView];
//    cell.msgContent = _datasource[indexPath.row];
    
    return cell;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *text = _datasource[indexPath.row];

    // 方法1：
    // 段落设置与实际显示的 Label 属性一致 采用 NSMutableParagraphStyle 设置Nib 中 Label 的相关属性传入到 NSAttributeString 中计算；
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.lineBreakMode = NSLineBreakByWordWrapping;
    style.alignment = NSTextAlignmentLeft;

    NSAttributedString *string = [[NSAttributedString alloc]initWithString:text attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16], NSParagraphStyleAttributeName:style}];
    
    CGSize size =  [string boundingRectWithSize:CGSizeMake(200.f, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
    NSLog(@" size =  %@", NSStringFromCGSize(size));
    
    // 并不是高度计算不对，我估计是计算出来的数据是 小数，在应用到布局的时候稍微差一点点就不能保证按照计算时那样排列，所以为了确保布局按照我们计算的数据来，就在原来计算的基础上 取ceil值，再加1，测试 OK；
    CGFloat height = ceil(size.height) + 1;
    
    
    // 方法2：
    UILabel *label = [[UILabel alloc]init];
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.textAlignment = NSTextAlignmentLeft;
    label.text = text;
    label.font = [UIFont systemFontOfSize:16];
    CGSize labelSize = [label sizeThatFits:CGSizeMake(200.f, MAXFLOAT)];
    height = ceil(labelSize.height) + 1;
    
    return height + 8+8+18+8;
}


@end
