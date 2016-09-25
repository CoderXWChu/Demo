//
//  DCCache.h
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

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

//============================================================
// DCCache 是基于 DCDatabse 的缓存类, 你可以使用它完成对 支持<NSCoding>
// 协议的 对象 或者 文件数据 进行缓存和提取;
// 你可以使用 NSObject+DCAutoCoding 分类很方便的完成对 NSCoding 的支持;
//============================================================


@class DCCacheItem;

@interface DCCache : NSObject

#pragma mark - 缓存 对象/文件数据
/*!
 *  缓存支持<NSCoding>协议的对象
 *  @param object 支持<NSCoding>协议的对象
 *  @param key    该对象对应的 key
 *  @return  是否成功
 */
+ (BOOL)setObject:(id<NSCoding>)object forKey:(NSString *)key;
/*!
 *  缓存文件数据到数据库
 *  @param fileData 文件数据
 *  @param key  该文件数据对应的 key
 *  @return  是否成功
 */
+ (BOOL)setFile:(NSData *)fileData forKey:(NSString *)key;

/*!
 *  缓存文件数据到数据库
 *  @param fileData 文件数据
 *  @param key      key
 *  @param name     文件名称
 *  @param type     文件类型
 *  @return 是否成功
 */
+ (BOOL)setFile:(NSData *)fileData
         forKey:(NSString *)key
       withName:(NSString * _Nullable )name
           type:(NSString * _Nullable )type;

#pragma mark - 提取

/*!
 *  根据 key 从数据库提取缓存的对象
 *  @param key 存储对象时设置的 key
 *  @return  缓存的对象
 */
+ (id)objectForKey:(NSString *)key;

/*!
 *  根据 key 从数据库提取缓存的文件数据
 *  @param key  存储文件数据时对应的 key
 *  @return 返回文件数据
 */
+ (NSData *)fileForKey:(NSString *)key;


/*!
 *  根据 key 从数据库提取缓存的对象模型
 *  @param key 存储对象时设置的 key
 *  @return  缓存的对象模型
 */
+ (DCCacheItem *)objectItemForKey:(NSString *)key;

/*!
 *  根据 key 从数据库提取缓存的文件数据模型
 *  @param key  存储文件数据时对应的 key
 *  @return 返回文件数据模型
 */
+ (DCCacheItem *)fileItemForKey:(NSString *)key;

#pragma mark - 移除缓存

/*!
 *  根据 key 移除缓存的对象
 *  @return 是否成功
 */
+ (BOOL)removeObjectForKey:(NSString *)key;
/*!
 *  根据 key 移除缓存的文件数据
 *  @return 是否成功
 */
+ (BOOL)removeFileForKey:(NSString *)key;


@end

@interface DCCacheItem : NSObject

@property (nonatomic, strong) NSData *data; ///< file/object data
@property (nonatomic, copy) NSString *key; ///< file/object key
@property (nonatomic, copy) NSString *name; ///< file/object name
@property (nonatomic, copy) NSString *type; ///< file/objec type
@property (nonatomic, assign) NSUInteger length; ///< size of data
@property (nonatomic, assign) NSTimeInterval lastModifierTime; ///< 最后修改时间

- (instancetype)initWithData:(NSData *)data key:(NSString *)key;
- (instancetype)initWithData:(NSData *)data
                         key:(NSString *)key
                        name:(NSString * _Nullable)name
                        type:(NSString * _Nullable)type;
@end

NS_ASSUME_NONNULL_END



