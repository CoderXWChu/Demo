//
//  NSObject+DCExt.h
//
//
//  Created by CoderXWChu on 15/2/10.
//  Copyright © 2015年 CoderXWChu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (DCExt)
/**
 *  支持多个参数的方法调用(支持2个以上的参数)
 *
 *  @param aSelector 要调用的那个方法
 *  @param objects   要调用的那个方法需要的参数数组
 *
 *  @return 调用的那个方法的返回值
 */
-(id)dc_performSelector:(SEL)aSelector withObjects:(NSArray *)objects;
@end
