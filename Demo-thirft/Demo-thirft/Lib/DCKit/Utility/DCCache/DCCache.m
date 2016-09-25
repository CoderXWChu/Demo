//
//  DCCache.m
//
//  Created by DanaChu on 16/4/28.
//  Copyright © 2016年 DanaChu. All rights reserved.
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

#import "DCCache.h"
#import "DCDatabase.h"

@implementation DCCache

+ (BOOL)setObject:(id<NSCoding>)object forKey:(NSString *)key
{
    if(!key || key.length==0) return NO;
    if (!object) {
        // removeItem
        return [self removeObjectForKey:key];
    }
    NSData *value = nil;
    @try {
        value = [NSKeyedArchiver archivedDataWithRootObject:object];
    } @catch (NSException *exception) {
        // to do nothing...
    }
    if (!value) {
        return NO;
    }else{
        if ([self objectForKey:key]) [self removeObjectForKey:key];
        DCCacheItem *item = [[DCCacheItem alloc]initWithData:value key:key];
        return [[DCDatabase shareInstance] saveToDatabaseWithObject:item];
    }
}

+ (BOOL)setFile:(NSData *)fileData forKey:(NSString *)key
{
    return [self setFile:fileData forKey:key withName:nil type:nil];
}

+ (BOOL)setFile:(NSData *)fileData
         forKey:(NSString *)key
       withName:(NSString *)name
           type:(NSString *)type
{
    if(!key || key.length==0) return NO;
    if (!fileData || fileData.length == 0) {
        // removeItem
        return [self removeObjectForKey:key];
    }
    if ([self fileForKey:key]) [self removeFileForKey:key];
    DCCacheItem *item = [[DCCacheItem alloc]initWithData:fileData key:key name:name type:type];
    return [[DCDatabase shareInstance] saveToDatabaseWithObject:item];
}


+ (BOOL)removeObjectForKey:(NSString *)key
{
    return [[DCDatabase shareInstance]removeDataWithClassName:NSStringFromClass(DCCacheItem.class) condition:[NSString stringWithFormat:@"key == '%@'", key]];
}

+ (BOOL)removeFileForKey:(NSString *)key
{
    return [[DCDatabase shareInstance]removeDataWithClassName:NSStringFromClass(DCCacheItem.class) condition:[NSString stringWithFormat:@"key == '%@'", key]];
}

+ (id)objectForKey:(NSString *)key
{
    DCCacheItem *item = [self objectItemForKey:key];
    id value = nil;
    @try {
        value = [NSKeyedUnarchiver unarchiveObjectWithData:[item data]];
    } @catch (NSException *exception) {
        // to do nothing...
    }
    if (!value) {
        value = [item data];
    }
    return value;
}

+ (DCCacheItem *)objectItemForKey:(NSString *)key
{
    NSArray *items = [[DCDatabase shareInstance]getDataWithClassName:NSStringFromClass(DCCacheItem.class) condition:[NSString stringWithFormat:@"key =='%@'", key]];
    if (!items || items.count == 0) {
        return nil;
    }else if (items.count > 1){
        [self removeFileForKey:key];
        return nil;
    }
    return [items firstObject];
}


+ (DCCacheItem *)fileItemForKey:(NSString *)key
{
    NSArray <DCCacheItem *>*items = [[DCDatabase shareInstance]getDataWithClassName:NSStringFromClass(DCCacheItem.class) condition:[NSString stringWithFormat:@"key == '%@'", key]];
    if (!items || items.count == 0) {
        return nil;
    }else if (items.count > 1){
        [self removeFileForKey:key];
        return nil;
    }
    return [items firstObject];
}

+ (NSData *)fileForKey:(NSString *)key
{
    DCCacheItem *fileItem = [self fileItemForKey:key];
    return fileItem ? fileItem.data : nil;
}

@end

@implementation DCCacheItem

- (instancetype)initWithData:(NSData *)data
                         key:(NSString *)key
                        name:(NSString *)name
                        type:(NSString *)type
{
    if (self = [self init]) {
        _data = data;
        _length = data.length;
        _lastModifierTime = (uintmax_t)time(NULL);
        _key = key;
        _name = name;
        _type = type;
    }
    return self;
}
- (instancetype)initWithData:(NSData *)data key:(NSString *)key
{
    return [self initWithData:data key:key name:nil type:nil];
}

@end
