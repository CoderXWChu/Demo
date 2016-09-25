//
//  DCCommonDefine.h
//
//  Created by DanaChu on 16/6/16.
//  Copyright © 2016年 DanaChu. All rights reserved.
//

#ifndef _DCCOMMONDEFINE_
#define _DCCOMMONDEFINE_

#import <Foundation/Foundation.h>

#ifdef __OBJC__
#import <UIKit/UIKit.h>
#import <objc/runtime.h>
//#import <FBRetainCycleDetector/FBRetainCycleDetector.h>

//============================================================
// GCD Macro
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



//============================================================
// Common macro
//============================================================


/*
 * 用来查看 mecro 的最终表达式
 */
#define __toString(x) __toString_0(x)
#define __toString_0(x) #x
#define LOG_MACRO(x) NSLog(@"%s=\n%s", #x, __toString(x))




/*
 * a better NSLog
 */
#ifdef DEBUG
#define NSLog(format, ...) do {                                             \
fprintf(stderr, "<%s : %d> %s\n",                                           \
[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String],  \
__LINE__, __func__);                                                        \
NSLog((format), ##__VA_ARGS__);                                           \
fprintf(stderr, "-------\n");                                               \
} while (0)
#else
#define NSLog(format, ...)
#endif

/*
 * print CGRect / CGSize / CGPoint
 */
#define NSLogRect(rect) do{ NSLog(@"%@", NSStringFromCGRect(rect)); }while(0)
#define NSLogSize(size) do{ NSLog(@"%@", NSStringFromCGSize(size)); }while(0)
#define NSLogPoint(point) do{ NSLog(@"%@", NSStringFromCGPoint(point)); }while(0)
#define NSLogDealloc do{ NSLog(@"-- 销毁 "); }while(0)

/*
 * force_inline
 */
#ifndef force_inline
#define force_inline __inline__ __attribute__((always_inline))
#endif

#define DCAssertMainThread() NSAssert([NSThread isMainThread], @"This method must be called on the main thread")
#define DCCAssertMainThread() NSCAssert([NSThread isMainThread], @"This method must be called on the main thread")




#ifndef DC_CLAMP // return the clamped value
#define DC_CLAMP(_x_, _low_, _high_)  (((_x_) > (_high_)) ? (_high_) : (((_x_) < (_low_)) ? (_low_) : (_x_)))
#endif

#ifndef DC_SWAP // swap two value
#define DC_SWAP(_a_, _b_)  do { __typeof__(_a_) _tmp_ = (_a_); (_a_) = (_b_); (_b_) = _tmp_; } while (0)
#endif



/**
 Add this macro before each category implementation, so we don't have to use
 -all_load or -force_load to load object files from static libraries that only
 contain categories and no classes.
 More info: http://developer.apple.com/library/mac/#qa/qa2006/qa1490.html .
 *******************************************************************************
 Example:
 YYSYNTH_DUMMY_CLASS(NSString_YYAdd)
 */
#ifndef DCSYNTH_DUMMY_CLASS
#define DCSYNTH_DUMMY_CLASS(_name_) \
@interface DCSYNTH_DUMMY_CLASS_ ## _name_ : NSObject @end \
@implementation DCSYNTH_DUMMY_CLASS_ ## _name_ @end
#endif



/**
 Synthsize a dynamic object property in @implementation scope.
 It allows us to add custom properties to existing classes in categories.
 
 @param association  ASSIGN / RETAIN / COPY / RETAIN_NONATOMIC / COPY_NONATOMIC
 @warning #import <objc/runtime.h>
 *******************************************************************************
 Example:
 @interface NSObject (MyAdd)
 @property (nonatomic, retain) UIColor *myColor;
 @end
 
 #import <objc/runtime.h>
 @implementation NSObject (MyAdd)
 DCSYNTH_DYNAMIC_PROPERTY_OBJECT(myColor, setMyColor, RETAIN, UIColor *)
 @end
 */
#ifndef DCSYNTH_DYNAMIC_PROPERTY_OBJECT
#define DCSYNTH_DYNAMIC_PROPERTY_OBJECT(_getter_, _setter_, _association_, _type_) \
- (void)_setter_ : (_type_)object { \
[self willChangeValueForKey:@#_getter_]; \
objc_setAssociatedObject(self, _cmd, object, OBJC_ASSOCIATION_ ## _association_); \
[self didChangeValueForKey:@#_getter_]; \
} \
- (_type_)_getter_ { \
return objc_getAssociatedObject(self, @selector(_setter_:)); \
}
#endif


//============================================================
// weak strong Pointer Macro
//============================================================

/**
 Synthsize a weak or strong reference.
 
 Example:
 @weakify(self)
 [self doSomething^{
 @strongify(self)
 if (!self) return;
 ...
 }];
 
 */
#ifndef weakify
#if DEBUG
#if __has_feature(objc_arc)
#define weakify(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) autoreleasepool{} __block __typeof__(object) block##_##object = object;
#endif
#else
#if __has_feature(objc_arc)
#define weakify(object) try{} @finally{} {} __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) try{} @finally{} {} __block __typeof__(object) block##_##object = object;
#endif
#endif
#endif

#ifndef strongify
#if DEBUG
#if __has_feature(objc_arc)
#define strongify(object) autoreleasepool{} __typeof__(object) object = weak##_##object;
#else
#define strongify(object) autoreleasepool{} __typeof__(object) object = block##_##object;
#endif
#else
#if __has_feature(objc_arc)
#define strongify(object) try{} @finally{} __typeof__(object) object = weak##_##object;
#else
#define strongify(object) try{} @finally{} __typeof__(object) object = block##_##object;
#endif
#endif
#endif



//============================================================
// 错误信息信息收集
// the ‘error’ of DCErrorLog(error) must be the kind of class :『 NSError 』
//============================================================
#ifndef DCErrorLog
#define DCErrorLog(error)  do{                                  \
if (error) { NSAssert([error isKindOfClass:NSError.class],      \
@" the ‘error’ of DCErrorLog(error) must be the kind of class :『 NSError 』!"); \
NSLog(@"%@ (%d) ERROR: %@", \
[[NSString stringWithUTF8String:__FILE__] lastPathComponent],   \
__LINE__, [error localizedDescription]); }                      \
} while(0);
#endif


//============================================================
// single Macro
//============================================================
#ifndef SingleH
#define SingleH(name)  + (instancetype)share##name;
#endif

#ifndef SingleM
#if __has_feature(objc_arc)
#define SingleM(name) static id _instance;\
+ (instancetype)allocWithZone:(struct _NSZone *)zone {\
static dispatch_once_t pridecate;\
dispatch_once(&pridecate, ^{\
_instance = [super allocWithZone:zone];\
});\
return _instance;\
}\
+ (instancetype)share##name{\
if (_instance == nil) { \
_instance = [[self alloc] init];\
}\
return _instance;\
}\
- (id)copyWithZone:(NSZone *)zone {\
return _instance;\
}\
- (id)mutableCopyWithZone:(NSZone *)zone {\
return _instance;\
}

#else

#define SingleM(name) static id _instance;\
+ (instancetype)allocWithZone:(struct _NSZone *)zone {\
static dispatch_once_t onceToken;\
dispatch_once(&onceToken, ^{\
_instance = [super allocWithZone:zone];\
});\
return _instance;\
}\
+ (instancetype)share##name{\
if (_instance == nil) { \
_instance = [[self alloc] init];\
}\
return _instance;\
}\
- (id)copyWithZone:(NSZone *)zone {\
return _instance;\
}\
- (id)mutableCopyWithZone:(NSZone *)zone {\
return _instance;\
}\
- (instancetype)retain{\
return _instance;\
}\
- (oneway void)release{\
}\
- (NSUInteger)retainCount{\
return MAXFLOAT;\
}
#endif
#endif



// 判断系统版本
#ifndef IOS_Version
#define IOS_Version(Version) [[[UIDevice currentDevice] systemVersion]floatValue] >= Version
#endif

// 当前应用版本号
#ifndef AppVersion
#define AppVersion [[NSBundle mainBundle] infoDictionary][@"CFBundleVersion"]
#endif


// color
#ifndef RGBA
#define RGBA(R,G,B,A) [UIColor colorWithRed:((R)/255.0) green:((G)/255.0) blue:((B)/255.0) alpha:(A)]
#endif
#ifndef RGB
#define RGB(R,G,B) [UIColor colorWithRed:((R)/255.0) green:((G)/255.0) blue:((B)/255.0) alpha:1.0]
#endif
#ifndef DCColorWithHexValue
#define DCColorWithHexValue(hexvalue) [UIColor colorWithRed:((float)((hexvalue & 0xFF0000) >> 16))/255.0 green:((float)((hexvalue & 0xFF00) >> 8))/255.0 blue:((float)(hexvalue & 0xFF))/255.0 alpha:1.0]
#endif

#ifndef RandomColor
#define RandomColor [UIColor colorWithRed:((float)arc4random_uniform(256) / 255.0) green:((float)arc4random_uniform(256) / 255.0) blue:((float)arc4random_uniform(256) / 255.0) alpha:1.0]
#endif

// 屏幕尺寸
#ifndef SCREEN_WIDTH
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#endif
#ifndef SCREEN_HEIGHT
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#endif


// 文件目录
#ifndef DocumentPath
#define DocumentPath NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES)[0]
#endif
#ifndef CachesPach
#define CachesPach NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0]
#endif
#ifndef TempPath
#define TempPath NSTemporaryDirectory()
#endif

// 常用单例
#define SharedUserDefault [NSUserDefaults standardUserDefaults]
#define SharedNotificationCenter [NSNotificationCenter defaultCenter]
#define SharedFileManager [NSFileManager defaultManager]
#define SharedApplicationDelegate [[UIApplication sharedApplication] delegate]

// 是否模拟器
#ifdef TARGET_IPHONE_SIMULATOR
#define isSimulator TARGET_IPHONE_SIMULATOR
#endif

#ifndef IS_IPHONE
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#endif

#ifndef IS_IPOD
#define IS_IPOD ([[[UIDevice currentDevice] model] isEqualToString:@"iPod touch"])
#endif

#ifndef IS_IPAD
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#endif


static force_inline void swizzleMethod(Class class, SEL originalSelector, SEL swizzledSelector)
{
    ({
        // the method might not exist in the class, but in its superclass
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        
        // class_addMethod will fail if original method already exists
        BOOL didAddMethod = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
        
        // the method doesn’t exist and we just added one
        if (didAddMethod) {
            class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
        }
        else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}



//============================================================
//  消除-performSelector方法造成的警告
/*
 You can use the macro like this:
 
     SuppressPerformSelectorLeakWarning(
        [_target performSelector:_action withObject:self]
     );
 
 */
//============================================================
#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)



//============================================================
// The Macro to detecte retain_cycle
//============================================================
#ifdef DEBUG
#define DC_CYCLE_DETECTOR  do{                                  \
FBRetainCycleDetector *detector = [FBRetainCycleDetector new];  \
[detector addCandidate:self];                                   \
NSSet *retainCycles = [detector findRetainCycles];              \
if (retainCycles.count > 0){                                    \
NSLog(@"循环引用检测结果：%@", retainCycles);                      \
}                                                               \
} while(0);
#else
#define DC_CYCLE_DETECTOR
#endif



#endif
#endif
