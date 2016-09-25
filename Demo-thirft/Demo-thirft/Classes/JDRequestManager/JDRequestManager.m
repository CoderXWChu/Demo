//
//  JDRequestManager.m
//
//  Created by DanaChu on 16/9/5.
//  Copyright © 2016年 DanaChu. All rights reserved.
//

#import "JDRequestManager.h"


@interface JDRequestManager ()

@end


@implementation JDRequestManager

SingleM(RequestManager);

- (instancetype)init
{
    if (self = [super init]) {
        transport = [[TSocketClient alloc] initWithHostname:@"123.206.17.40" port:2016];
        protocol = [[TBinaryProtocol alloc]initWithTransport:transport strictRead:YES strictWrite:YES];
        service = [[TTGTTGServiceClient alloc]initWithProtocol:protocol];
        queue = dispatch_queue_create("com.thift.queue", DISPATCH_QUEUE_SERIAL);
    }
    return self;
}



@end
