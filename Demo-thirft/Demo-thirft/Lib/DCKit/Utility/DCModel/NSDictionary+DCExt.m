//
//  NSDictionary+DCExt.m
//
//  Created by cxw on 13/06/17.
//  Copyright © 2013年 cxw. All rights reserved.
//

/*!
 *  用于字典转模型时,格式化输出属性
 */
#import "NSDictionary+DCExt.h"

@implementation NSDictionary (DCExt)

- (void)dc_creatPropertys
{
    NSMutableString *string_Mut = [NSMutableString string];
    
    [self enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        
        NSString *string;
        NSString *type;
        
        if ([obj isKindOfClass:[NSString class]]) {
            type = @"copy) NSString *";
        }else if ([obj isKindOfClass:[NSArray class]]) {
            type = @"strong) NSArray *";
        }else if ([obj isKindOfClass:[NSDictionary class]]) {
            type = @"strong) NSDictionary *";
        }else if ([obj isKindOfClass:NSClassFromString(@"__NSCFBoolean")]) {
            type = @"assign) BOOL ";
        }else if ([obj isKindOfClass:[NSNumber class]]) {
            type = @"assign) NSNumber *";
        }
        
        string = [NSString stringWithFormat:@"@property (nonatomic, %@%@;     ///< <#注释#> \n",type ,key];
        [string_Mut appendString:string];
    }];
    
    NSLog(@"\n\n%@", string_Mut);
}


@end
