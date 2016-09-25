//
//  NSObject+DCExt.m
//
//
//  Created by CoderXWChu on 15/2/10.
//  Copyright © 2015年 CoderXWChu. All rights reserved.
//

#import "NSObject+DCExt.h"

@implementation NSObject (DCExt)

-(id)dc_performSelector:(SEL)aSelector withObjects:(NSArray *)objects
{
    SEL selector = aSelector;
    
    //1.创建一个方法签名
    //不能直接使用methodSignatureForSelector方法来创建
    //1.需要告诉这个方法属于谁 ViewController
    //2.方法 SEL
    //方法的名称|参数个数|返回值的类型|返回值的长度
    NSMethodSignature *methodSignature = [[self class] instanceMethodSignatureForSelector:selector];
    
    NSLog(@"%@",methodSignature);
    if (methodSignature == nil) {
        [NSException raise:@"Error:" format:@"%@方法不存在",NSStringFromSelector(selector)];
    }
    //2.创建NSInvocation
    //要传递方法签名
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
    invocation.target = self;
    invocation.selector = selector;
    
    NSInteger count1 = methodSignature.numberOfArguments - 2;
    NSInteger count2 = objects.count;
    NSInteger count = MIN(count1, count2);
    //获取参数格式
    for (NSInteger i =0; i<count; i++) {
        id obj = objects[i];
        //设置参数
        [invocation setArgument:&obj atIndex:i+2];
    }
    
    //3.调用该方法
    [invocation invoke];
    
    id result = nil;
    if (methodSignature.methodReturnLength >0) {
         [invocation getReturnValue:&result];
    }

    return result;
}


@end
