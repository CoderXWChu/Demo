//
//  DCDatabase.h
//
//  Created by xiaoweiChu on 15/2/03.
//  Copyright © 2015年 xiaoweiChu. All rights reserved.
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
#import "NSObject+Database.h"

#ifndef KEYPATH
#define KEYPATH(obj,keyPath) @(((void)obj.keyPath, #keyPath))
#endif

NS_ASSUME_NONNULL_BEGIN

//============================================================
// DCDatabase设计目的是用来缓存项目中需要存储到本地的模型数据，支持直接
// 存储模型或模型数组，支持获取数据库信息时，直接获取到模型。支持数据处理
// 的并发执行()。批量写入时，支持自动回滚。
//============================================================

///</////////////////////////////////////////
/// <<<使用注意>>>
///</////////////////////////////////////////
//
//  1. 需导入框架 libsqlite3.tdb
//  2. 若模型中部分属性不需要存储到数据库，需要导入头文件 NSObject+Database.h
//     或 DCDatabase.h 实现方法 - (NSArray *)dc_noNeedSavePropertys;
//  3. 异步函数调用时，并未对最大并发数进行处理，若需要，可以使用信号量
//     dispatch_semaphore_t 控制最大并发量；
//
///</////////////////////////////////////////
/// <<<建议>>>
///</////////////////////////////////////////
//
//  1. 处理数据量大、耗时操作建议使用异步函数(带有 callback 代码块的方法)；
//
///

typedef void (^DCDatabaseQueryHandle)(NSArray * _Nullable models);
typedef void (^DCDatabaseUnQueryHandle)(BOOL isFinish);

@interface DCDatabase : NSObject

- (instancetype)init UNAVAILABLE_ATTRIBUTE;
+ (instancetype)new UNAVAILABLE_ATTRIBUTE;

+ (instancetype)shareInstance;

///< 打开、关闭数据库句柄
- (BOOL)openDatabase;
- (BOOL)closeDatabase;

/*!
 *  获取数据行数
 *  @param classname 表名，类名
 *  @return 返回行数
 */
- (NSUInteger)dataRowsWithClassName:(NSString *)classname;

/*!
 *  清除数据库，将数据库文件整体删除
 *  @return 返回操作结果
 */
- (BOOL)cleanDatabase;


#pragma mark - 保存数据

/*!
 *  将模型对象保存(插入)到数据库
 *  @param object 模型对象
 *  @return 返回保存操作结果
 *  线程：在调用该接口线程中执行
 */
- (BOOL)saveToDatabaseWithObject:(id)object;

/*!
 *  将模型对象保存(插入)到数据库
 *  @param object 模型对象
 *  @param callback 回调代码块
 *  异步执行，回调传入 BOOL 操作结果
 */
- (void)saveToDatabaseWithObject:(id)object callBack:(DCDatabaseUnQueryHandle _Nullable)callback;

/*!
 *  将模型数组保存(插入)到数据库, 若其中一条发生错误，自动回滚；
 *  @param models 模型数组
 *  @param isRollback 发生错误时是否自动回滚
 *  @return 返回保存操作结果
 *  线程：在调用该接口线程中执行
 */
- (BOOL)saveToDatabaseWithArray:(NSArray *)models autoRollback:(BOOL)isRollback;

/*!
 *  将模型数组保存(插入)到数据库,
 *  @param models 模型数组
 *  @param isRollback 发生错误时是否自动回滚
 *  @param callback 回调代码块
 *  异步执行，回调传入 BOOL 操作结果
 */
- (void)saveToDatabaseWithArray:(NSArray *)models autoRollback:(BOOL)isRollback callBack:(DCDatabaseUnQueryHandle _Nullable)callback;

#pragma mark - 刷新数据

/*!
 *  将该模型之前的数据删除，重新写入
 *  @param models 模型数组
 *  @param isRollback 发生错误时是否自动回滚
 *  @return 返回保存操作结果
 *  线程：在调用该接口线程中执行
 */
- (BOOL)refreshDataWithArray:(NSArray *)models autoRollback:(BOOL)isRollback;

/*!
 *  将该模型之前的数据删除，重新写入
 *  @param models 模型数组
 *  @param isRollback 发生错误时是否自动回滚
 *  @param callback 回调代码块
 *  异步执行，回调传入 BOOL 操作结果
 */
- (void)refreshDataWithArray:(NSArray *)models autoRollback:(BOOL)isRollback callBack:(DCDatabaseUnQueryHandle _Nullable)callback;

#pragma mark - 删除数据


/*!
 *  根据条件表达式获取该模型的数据 适用于 (WHERE)
 *  @param classname 表格名称，类名
 *  @param conditionString 添加表达式：
 *  例如： DELETE * FROM t_student WHERE name like '%wei%';
          conditionString = @" name like '%wei%' "
          classname = @" student ";
 *  例如： DELETE * FROM t_teacher WHERE age < 27;
          conditionString = @" age < 27 "
          classname = @" teacher ";
 *  @return 返回获取操作结果
 *  线程：在调用该接口线程中执行
 */
- (BOOL)removeDataWithClassName:(NSString *)classname condition:(NSString *)conditionString;


/*
 *  @param callback 回调代码块
 *  异步执行，回调传入NSArray 操作结果
 */
- (void)removeDataWithClassName:(NSString *)classname condition:(NSString *)conditionString callBack:(DCDatabaseUnQueryHandle _Nullable)callback;



/*!
 *  将该模型的数据全部删除，保留表格
 *  @param classname 表格名称，类名
 *  @return 返回删除操作结果
 *  线程：在调用该接口线程中执行
 */
- (BOOL)removeAllWithClassName:(NSString *)classname;

/*!
 *  将该模型的数据全部删除，保留表格
 *  @param classname 表格名称，类名
 *  @param callback 回调代码块
 *  异步执行，回调传入 BOOL 操作结果
 */
- (void)removeAllWithClassName:(NSString *)classname callBack:(DCDatabaseUnQueryHandle _Nullable)callback;

/*!
 *  获取该模型的表格
 *  @param classname 表格名称，类名
 *  @return 返回删除操作结果
 *  线程：在调用该接口线程中执行
 */
- (BOOL)deleteTableWithClassName:(NSString *)classname;

/*!
 *  获取该模型的表格
 *  @param classname 表格名称，类名
 *  @param callback 回调代码块
 *  异步执行，回调传入 BOOL 操作结果
 */
- (void)deleteTableWithClassName:(NSString *)classname callBack:(DCDatabaseUnQueryHandle _Nullable)callback;


#pragma mark - 获取数据

 /*!
 *  根据条件表达式获取该模型的数据 （WHERE）
 *  @param classname 表格名称，类名
 *  @param conditionString 添加表达式：
 *  例如： SELECT * FROM t_student WHERE name like '%wei%'; 
          conditionString = @" name like '%wei%' "
          classname = @" student ";
 *  例如： SELECT * FROM t_teacher WHERE age < 27;
          conditionString = @" age < 27 "
          classname = @" teacher ";
 *  @return 返回获取操作结果
 *  线程：在调用该接口线程中执行
 */
- (NSArray *_Nullable)getDataWithClassName:(NSString *)classname condition:(NSString *)conditionString;


/*
 *  @param callback 回调代码块
 *  异步执行，回调传入NSArray 操作结果
 */
- (void)getDataWithClassName:(NSString *)classname condition:(NSString *)conditionString callBack:(DCDatabaseQueryHandle _Nullable)callback;



/*!
 *  根据属性名称排序后的所有数据, 适用于表达式为 ORDER BY 类型
 *  @param classname 表名
 *  @param attributeString @"age"
 *  @param isRise YES / NO  升序/降序
 *  例如：SELECT * FROM "t_student" ORDER BY age;       isRise = YES
         SELECT * FROM "t_student" ORDER BY age DESC;  isRise = NO
 *  @return 返回
 */
- (NSArray *_Nullable)getDataWithClassName:(NSString *)classname attribute:(NSString *)attributeString isRise:(BOOL)isRise;

/*
 *  @param callback 回调代码块
 *  异步执行，回调传入NSArray 操作结果
 */
- (void)getDataWithClassName:(NSString *)classname attribute:(NSString *)attributeString isRise:(BOOL)isRise callBack:(DCDatabaseQueryHandle _Nullable)callback;



/*!
 *  获取该模型的全部数据
 *  @param classname 表格名称，类名
 *  @return 返回获取操作结果
 *  线程：在调用该接口线程中执行
 */
- (NSArray *_Nullable)getAllWithClassName:(NSString *)classname;

/*!
 *  获取该模型的全部数据
 *  @param classname 表格名称，类名
 *  @param callback 回调代码块
 *  异步执行，回调传入NSArray 操作结果
 */
- (void)getAllWithClassName:(NSString *)classname callBack:(DCDatabaseQueryHandle _Nullable)callback;

#pragma mark - 更新数据


/*!
 *  根据条件、属性值 更新数据 （WHERE）
 *  @param calssname       表名，类名
 *  @param attribute       属性名（列名称）
 *  @param toValue         新值
 *  @param conditionString 过滤条件 nil 时，更新表内所有数据
 *  @return 返回操作
 */
- (BOOL)updateDataWithClassName:(NSString *)classname attribute:(NSString *)attribute toValue:(id)toValue condition:(NSString *_Nullable)conditionString;

/*!
 *  根据条件、属性值 更新数据 （WHERE）
 *  @param calssname       表名，类名
 *  @param attribute       属性名（列名称）
 *  @param toValue         新值
 *  @param conditionString 过滤条件 nil 时，更新表内所有数据
 *  @param callback 回调代码块
 *  异步执行，回调传入 BOOL 操作结果
 */
- (void)updateDataWithClassName:(NSString *)classname attribute:(NSString *)attribute toValue:(id)toValue condition:(NSString *_Nullable)conditionString callBack:(DCDatabaseUnQueryHandle _Nullable)callback;

@end


NS_ASSUME_NONNULL_END

