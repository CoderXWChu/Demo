//
//  ViewController.m
//  Demo-thirft
//
//  Created by DanaChu on 16/8/28.
//  Copyright © 2016年 DanaChu. All rights reserved.
//

#import "ViewController.h"
#import "cxw.h"
#import <Thrift/TSocketClient.h>
#import <Thrift/TBinaryProtocol.h>
#import "JDMasterReportViewController.h"
#import "JDCalendarPickerView.h"

@interface ViewController ()
{
    TSocketClient *transport;
    TBinaryProtocol* protocol;
    TTGTTGServiceClient* service;
}
@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    transport = [[TSocketClient alloc] initWithHostname:@"123.206.17.40" port:2016];
//    protocol = [[TBinaryProtocol alloc]initWithTransport:transport strictRead:YES strictWrite:YES];
//    service = [[TTGTTGServiceClient alloc]initWithProtocol:protocol];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)GetIn{
    
     JDMasterReportViewController *VC = [JDMasterReportViewController new];
    
    [self.navigationController pushViewController:VC animated:YES];
    
}



/*
 TTGdailyReportRequest_C
 TTGdailyRankRequest_C
 TTGdailyReportForShopRequest_C
 
 */

- (IBAction)TTGdailyReportForShopRequest_C:(id)sender {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy-mm-dd";
    NSTimeInterval time = [[formatter dateFromString:@"2016-08-28"] timeIntervalSince1970];
    
    TTGdailyReportForShopRequest_C* request = [[TTGdailyReportForShopRequest_C alloc] initWithDate:time sid:@"1"];
    TTGdailyReportForShopRequest_S* response = [service dailyReportForShopRequest:request];
    NSLog(@"response.state = %d", response.state);
    NSLog(@"response.description = %@", response.message);
    NSLog(@"response.takeAwayInfoList = %@", response.dailyReportForShop.takeAwayInfoList);
    NSLog(@"response.saleInDayTime = %@", response.dailyReportForShop.saleInDayTime);
    NSLog(@"response.saleInWeekTime = %@", response.dailyReportForShop.saleInWeekTime);
    NSLog(@"response.__takeAwayInfoListInDayTime = %@", response.dailyReportForShop.takeAwayInfoListInDayTime);
    NSLog(@"response.__takeAwayInfoListInWeekTime = %@", response.dailyReportForShop.takeAwayInfoListInWeekTime);
    
    /*
     NSMutableArray * __takeAwayInfoList;
     NSMutableArray * __saleInDayTime;
     NSMutableArray * __saleInWeekTime;
     NSMutableArray * __takeAwayInfoListInDayTime;
     NSMutableArray * __takeAwayInfoListInWeekTime;
     */
}


- (IBAction)TTGdailyRankRequest_C:(id)sender {
    
    TTGdailyRankRequest_C* request = [[TTGdailyRankRequest_C alloc] initWithDate:@"2016.08.28" sid:@"1" num:@"10"];
    TTGdailyRankRequest_S* response = [service dailyRankRequest:request];
    NSLog(@"response.state = %d", response.state);
    NSLog(@"response.description = %@", response.message);
    
    NSLog(@"response.dailyRankForSaleGoodList = %@", response.dailyRank.dailyRankForSaleGoodList);
    NSLog(@"response.dailyRankForPriceList = %@", response.dailyRank.dailyRankForPriceList);
    NSLog(@"response.dailyRankForSaleTerribleList = %@", response.dailyRank.dailyRankForSaleTerribleList);
    
}


- (IBAction)TTGdailyReportRequest_C:(id)sender {
    
        TTGdailyReportRequest_C* request = [[TTGdailyReportRequest_C alloc] initWithDate:@"2016.08.28"];
        TTGdailyReportRequest_S* response = [service dailyReportRequest:request];
        NSLog(@"response.state = %d", response.state);
        NSLog(@"response.description = %@", response.message);
        NSLog(@"response.dailyDataForCompany = %@", response.dailyDataForCompany);
        NSLog(@"response.dailyDataForShopList = %@", response.dailyDataForShopList);
    
    
}





- (IBAction)rili:(id)sender {
    JDCalendarPickerView *view = [JDCalendarPickerView calendarPickerView];
    [view setFrame:[UIScreen mainScreen].bounds];
    [view show];
}


@end
