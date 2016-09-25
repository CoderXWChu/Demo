//
//  DCSqliteHandle.h
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
#import <sqlite3.h>

NS_ASSUME_NONNULL_BEGIN

@interface DCSqliteHandle : NSObject

/*!
 *  打开数据库句柄
 *  @param database 数据库句柄
 *  @return 返回结果
 */
- (BOOL)openDatabase:(sqlite3 * _Nonnull * _Nonnull)database;

/*!
 *  关闭数据库句柄
 *  @param database 数据库句柄
 *  @return 返回结果
 */
- (BOOL)closeDatabase:(sqlite3 *)database;

/*!
 *  移除数据库
 *  @return 返回移除结果
 */
- (BOOL)deleteDatabase;

/*!
 *  判断数据库中是否存在表
 *  @param classname 表名，类名
 *  @param database  数据库句柄
 *  @return 返回是否存在
 */
- (BOOL)tableExistsWithClassName:(NSString *)classname database:(sqlite3 *)database;

/*!
 *  获取数据行数
 *  @param classname 表名，类名
 *  @return 返回行数
 */
- (NSUInteger)dataRowsWithClassName:(NSString *)classname database:(sqlite3 *)database;


/*!
 *  创建表格
 *  @param classname 类名称
 *  @param database  数据库句柄
 *  @return 返回创建结果
 */
- (BOOL)creatTableWithName:(NSString *)classname database:(sqlite3 *)database;

/*!
 *  插入数据，若表格不存在，创建表格
 *  @param object   数据对象
 *  @param database 数据库句柄
 *  @return 返回插入数据结果
 */
- (BOOL)insertDataWithObject:(id)object database:(sqlite3 *)database;


#pragma mark - delete data

/*!
 *  根据条件表达式获取该模型的数据 适用于 WHERE
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
- (BOOL)deleteDataWithClassName:(NSString *)classname database:(sqlite3 *)database condition:(NSString *)conditionString;

/*!
 *  删除表内的所有数据
 *  @param classname 表名称，类名
 *  @param database  数据库句柄
 *  @return 返回删除结果
 */
- (BOOL)deleteAllDataWithClassName:(NSString *)classname database:(sqlite3 *)database;

/*!
 *  删除数据
 *  @param sqlString SQL 语句的 NSString类型 对象
 *  @param database  数据库句柄
 *  @return 返回删除结果
 */
- (BOOL)deleteDataWithSqlString:(NSString *)sqlString database:(sqlite3 *)database;

/*!
 *  删除表格
 *  @param classname 表名，类名
 *  @return 返回删除结果
 */
- (BOOL)delteTableWithClassName:(NSString *)classname database:(sqlite3 *)database;

#pragma mark - update data


/*!
 *  根据条件、属性值 更新数据 （WHERE）
 *  @param calssname       表名，类名
 *  @param database        数据库句柄
 *  @param attribute       属性名（列名称）
 *  @param toValue         新值
 *  @param conditionString 过滤条件
 *  @return 返回操作
 */
- (BOOL)updateDataWithClassName:(NSString *)classname database:(sqlite3 *)database attribute:(NSString *)attribute toValue:(id)toValue condition:(NSString *)conditionString;


/*!
 *  执行非查询SQL语句(创建表/添加/删除/修改)
 *  @param sqlString SQL 语句的 NSString类型 对象
 *  @param database  数据库句柄
 *  @return 返回执行结果
 */
- (BOOL)executeSqlString:(NSString *)sqlString database:(sqlite3 *)database;

#pragma mark - select data

/*!
 *  获取表内的所有数据
 *  @param classname 表名
 *  @param database 数据库句柄
 *  @return 返回查询到的表内数据
 */
- (NSArray  * _Nullable )selectAllWithClassName:(NSString *)classname
                                       database:(sqlite3 *)database;


/*!
 *  根据条件获取表内的数据, 适用于表达式为 WHERE 类型
 *  @param classname 表名
 *  @param database 数据库句柄
 *  @param conditionString @"age > 18"
 *  例如： SELECT * FROM t_student WHERE name like '%wei%';
          conditionString = @" name like '%wei%' "
          classname = @" student ";
 *  例如： SELECT * FROM t_teacher WHERE age < 27;
          conditionString = @" age < 27 "
          classname = @" teacher ";
 *  @return 返回
 */
- (NSArray *_Nullable)selectWithClassName:(NSString *)classname database:(sqlite3 *)database condition:(NSString *)conditionString;

/*!
 *  根据属性名称获取表内排序后的数据, 适用于表达式为 ORDER BY 类型
 *  @param classname 表名
 *  @param database 数据库句柄
 *  @param attributeString @"age"
 *  @param isRise YES / NO  升序/降序
 *  例如：SELECT * FROM "t_student" ORDER BY age;       isRise = YES
         SELECT * FROM "t_student" ORDER BY age DESC;  isRise = NO
 *  @return 返回
 */
- (NSArray *_Nullable)selectWithClassName:(NSString *)classname database:(sqlite3 *)database attribute:(NSString *)attributeString isRise:(BOOL)isRise;

/*!
 *  执行查询 SQL 语句
 *  @param sqlString 查询 SQL 语句的 NSString 类型对象
 *  @param database  数据库句柄
 *  @param className 类名
 *  @return 查询到的数据数组
 */
- (NSArray  * _Nullable )executeQuerySqlString:(NSString *)sqlString
                                      database:(sqlite3 *)database
                                     className:(NSString *)className;


@end

NS_ASSUME_NONNULL_END
