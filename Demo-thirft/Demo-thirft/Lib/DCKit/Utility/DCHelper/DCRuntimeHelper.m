//
//  DCRuntimeHelper.m
//
//  Created by CoderXWChu on 15/1/12.
//  Copyright © 2015年 CoderXWChu. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "DCRuntimeHelper.h"
#import <objc/message.h>

static NSCache *s_PropertysCache;
static NSCache *s_IvarsCache;

NSCache *DCClassPropertyCache()
{
    if (!s_PropertysCache) {
        s_PropertysCache = [[NSCache alloc] init];
    }
    return s_PropertysCache;
}

NSCache *DCClassIvarCache()
{
    if (!s_IvarsCache) {
        s_IvarsCache = [[NSCache alloc] init];
    }
    return s_IvarsCache;
}

NSDictionary *DCClassTypeTranslationDictionary()
{
    return  @{@"f":@"float",
              @"i":@"int",
              @"d":@"double",
              @"l":@"long",
              @"q":@"long long",
              @"c":@"char",
              @"B":@"BOOL",
              @"s":@"short",
              @"Q":@"unsigned long long",
              @"I":@"unsigned int",
              @"S":@"unsigned short",
//              @"T":@"",
              @"C":@"unsigned char",
              @"v":@"void",
              @"@":@"id",
              @"*":@"char *",
              @"#":@"Class",
              @":":@"SEL"};
}

NSArray *dc_ClassPropertyList(Class aClass)
{
    if (!aClass) return nil;
    
    NSArray *list = [DCClassPropertyCache() objectForKey:NSStringFromClass(aClass)];
    if (list) return list;

    unsigned int outCount = 0;
    objc_property_t *propertys = class_copyPropertyList(aClass, &outCount);
    NSMutableArray *tempArray = [[NSMutableArray alloc]initWithCapacity:0];
    for (int i = 0; i < outCount; ++i) {
        objc_property_t p = propertys[i];
        NSString *name = [NSString stringWithCString:property_getName(p) encoding:NSUTF8StringEncoding];
        [tempArray addObject:name];
    }
    free(propertys);
    [DCClassPropertyCache() setObject:[tempArray copy] forKey:NSStringFromClass(aClass)];
    return [tempArray copy];
}

NSArray *dc_ClassIvarList(Class aClass)
{
    if (!aClass) return nil;
    
    NSArray *list = [DCClassIvarCache() objectForKey:NSStringFromClass(aClass)];
    if (list) return list;
    
    NSMutableArray *tempArray = [[NSMutableArray alloc]initWithCapacity:0];
    unsigned int count = 0;
    Ivar *ivars = class_copyIvarList(aClass, &count);
    for (int i = 0; i < count; i++) {
        Ivar ivar = ivars[i];
        NSString *name = [NSString stringWithCString:ivar_getName(ivar) encoding:NSUTF8StringEncoding];
        [tempArray addObject:name];
    }
    free(ivars);
    [DCClassIvarCache() setObject:[tempArray copy] forKey:NSStringFromClass(aClass)];
    return [tempArray copy];
}

//void DCSwizzleMethod(Class class, SEL originalSelector, SEL swizzledSelector)
//{
//    ({
//        // the method might not exist in the class, but in its superclass
//        Method originalMethod = class_getInstanceMethod(class, originalSelector);
//        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
//        
//        // class_addMethod will fail if original method already exists
//        BOOL didAddMethod = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
//        
//        // the method doesn’t exist and we just added one
//        if (didAddMethod) {
//            class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
//        }
//        else {
//            method_exchangeImplementations(originalMethod, swizzledMethod);
//        }
//    });
//}

BOOL dc_SwizzleInstanceMethod(Class aClass, SEL originalSel, SEL newSel)
{
    Method originalMethod = class_getInstanceMethod(aClass, originalSel);
    Method newMethod = class_getInstanceMethod(aClass, newSel);
    if (!originalMethod || !newMethod) return NO;
    
    class_addMethod(aClass,
                    originalSel,
                    class_getMethodImplementation(aClass, originalSel),
                    method_getTypeEncoding(originalMethod));
    class_addMethod(aClass,
                    newSel,
                    class_getMethodImplementation(aClass, newSel),
                    method_getTypeEncoding(newMethod));
    
    method_exchangeImplementations(class_getInstanceMethod(aClass, originalSel),
                                   class_getInstanceMethod(aClass, newSel));
    return YES;
}

BOOL dc_SwizzleClassMethod(Class aClass, SEL originalSel, SEL newSel)
{
    Method originalMethod = class_getInstanceMethod(aClass, originalSel);
    Method newMethod = class_getInstanceMethod(aClass, newSel);
    if (!originalMethod || !newMethod) return NO;
    method_exchangeImplementations(originalMethod, newMethod);
    return YES;
}

void dc_SetAssociateValue(id instance, id value , void *key)
{
    objc_setAssociatedObject(instance, key, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

void dc_SetAssociateWeakValue(id instance, id value , void *key)
{
    objc_setAssociatedObject(instance, key, value, OBJC_ASSOCIATION_ASSIGN);
}

void dc_RemoveAssociatedValues(id instance) {
    objc_removeAssociatedObjects(instance);
}

id dc_GetAssociatedValueForKey(id instance, void *key) {
    return objc_getAssociatedObject(instance, key);
}

id dc_DeepCopy(id data)
{
    if (data == nil) return nil;
    id copyData = nil;
    @try {
        copyData = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:data]];
    } @catch (NSException *exception) {
        NSLog(@"%@", exception);
    }
    return copyData;
}


