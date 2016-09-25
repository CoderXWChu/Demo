//
//  DCBaseNavigationController.m
//  S-Binds
//
//  Created by DanaChu on 16/9/3.
//  Copyright © 2016年 DanaChu. All rights reserved.
//

#import "DCBaseNavigationController.h"
#import "DCKit.h"

@interface DCBaseNavigationController ()

@end

@implementation DCBaseNavigationController


+ (void)load
{
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated"
    UINavigationBar *navigationBar = [UINavigationBar appearanceWhenContainedIn:self, nil];
#pragma clang diagnostic pop
    
    NSMutableDictionary *titleAttur = [NSMutableDictionary dictionary];
    titleAttur[NSForegroundColorAttributeName] = RGB(38, 38, 38);
    titleAttur[NSFontAttributeName] = [UIFont boldSystemFontOfSize:17];
    [navigationBar setTitleTextAttributes:[titleAttur copy]];
    
    navigationBar.tintColor = RGB(28, 38, 38);
    navigationBar.barTintColor = RGB(247, 247, 247);
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
