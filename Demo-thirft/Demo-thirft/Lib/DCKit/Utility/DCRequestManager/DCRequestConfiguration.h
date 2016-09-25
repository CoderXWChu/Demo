//
//  DCRequestConfiguration.h
//
//  Created by DanaChu on 16/7/8.
//  Copyright © 2016年 DanaChu. All rights reserved.
//

#import <Foundation/Foundation.h>

//============================================================
// DCRequestConfiguration_API
// 网络请求常用 API
//============================================================

#define BaseURL      @"https://www.baidu.com"





//============================================================
// DCRequestConfiguration_Mecro
// 常用宏
//============================================================


#ifndef dispatch_main_sync_safe
#define dispatch_main_sync_safe(block)\
if ([NSThread isMainThread]) {\
block();\
} else {\
dispatch_sync(dispatch_get_main_queue(), block);\
}
#endif

#ifndef dispatch_main_async_safe
#define dispatch_main_async_safe(block)\
if ([NSThread isMainThread]) {\
block();\
} else {\
dispatch_async(dispatch_get_main_queue(), block);\
}
#endif

#ifndef dispatch_async_main_safe
#define dispatch_async_main_safe(block)\
dispatch_async(dispatch_get_main_queue(), block);\
}
#endif

