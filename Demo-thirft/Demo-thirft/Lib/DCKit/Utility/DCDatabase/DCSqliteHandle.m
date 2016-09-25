//
//  DCSqliteHandle.m
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

#import "DCSqliteHandle.h"
#import "DCClassHandle.h"

@implementation DCSqliteHandle
{
    const char *sqlitePath;
    NSMutableDictionary *tables;
    CFMutableDictionaryRef stmts;
    BOOL tableColumnFlag;
}

- (instancetype)init{
    if (self = [super init]) {
        tables = [[NSMutableDictionary alloc]initWithCapacity:0];
        tableColumnFlag = NO;
    }
    return self;
}

///< 打开数据库
- (BOOL)openDatabase:(sqlite3 **)database
{
    if (*database) {
        return YES;
    }
    // 设置为多线程模式，多个线程不同时使用 Connection 时，是线程安全的；
    // 禁用数据库连接和prepared statement
    sqlite3_config(SQLITE_CONFIG_MULTITHREAD);
    int rc = sqlite3_open_v2([self sqlitePath], database, SQLITE_OPEN_CREATE | SQLITE_OPEN_READWRITE, NULL);
    //============================================================
    // 采用sqlite3_open()，出现 rc == SQLITE_CANTOPEN 的情况，
    // /* Unable to open the database file */  无法打开数据库文件。
    // 采用 sqlite3_open_v2() 解决问题。不存在就创建，
    // 参考地址: http://stackoverflow.com/questions/11250870/sqlite3-open-unable-to-open-database-file
    //============================================================
    if( rc == SQLITE_OK) //  || rc == SQLITE_CANTOPEN
    {
        CFDictionaryKeyCallBacks keyCallbacks = kCFCopyStringDictionaryKeyCallBacks;
        CFDictionaryValueCallBacks valueCallbacks = {0};
        stmts = CFDictionaryCreateMutable(CFAllocatorGetDefault(), 0, &keyCallbacks, &valueCallbacks);
        return YES;
    }
    NSLog(@"%s line:%d sqlite open failed: %s.", __FUNCTION__, __LINE__, sqlite3_errmsg(*database));
    *database = 0x00;
    return NO;
}

- (BOOL)closeDatabase:(sqlite3 *)database
{
    if (!database) {
        return YES;
    }
    
    if (stmts) CFRelease(stmts);
    stmts = NULL;
    
    int  result;
    BOOL retry;
    BOOL triedFinalized = NO;
    do {
        retry   = NO;
        result  = sqlite3_close_v2(database);
        if (SQLITE_BUSY == result || SQLITE_LOCKED == result) {
            if (!triedFinalized) {
                triedFinalized = YES;
                sqlite3_stmt *stmt;
                while ((stmt = sqlite3_next_stmt(database, nil)) !=0) {
                    sqlite3_finalize(stmt);
                    retry = YES;
                }
            }
        }
        else if (SQLITE_OK != result) {
            NSLog(@"%s line:%d sqlite close failed: %s .", __FUNCTION__, __LINE__, sqlite3_errmsg(database));
        }
    }
    while (retry);
    database = 0x00;
    return YES;
}

- (BOOL)deleteDatabase
{
    NSString *filePath = [self filePath];
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        [tables removeAllObjects];
        
        return YES;
    }
    NSError *error = nil;
    [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
    if (error) {
        NSLog(@"%s line:%d  remove database failed: %@.", __FUNCTION__, __LINE__, error.localizedDescription);
        return NO;
    }
    [tables removeAllObjects];
    if (stmts) CFRelease(stmts);
    stmts = NULL;
    return YES;
    
}

- (BOOL)tableExistsWithClassName:(NSString *)classname database:(sqlite3 *)database
{
    NSString *tableName = [NSString stringWithFormat:@"t_%@", classname];
    if ([tables valueForKey:tableName]) {
        return YES;
    }
    NSString *sqlString = [NSString stringWithFormat:@"SELECT COUNT(*) FROM sqlite_master where type='table' and name='%@';", tableName];
    NSUInteger count = 0;
    sqlite3_stmt *stmt;
    if(sqlite3_prepare_v2(database, sqlString.UTF8String, -1, &stmt, NULL) == SQLITE_OK){
        while(sqlite3_step(stmt) == SQLITE_ROW){
            count = (NSUInteger)sqlite3_column_int(stmt, 0);
        }
        if (count == 1) {
            [tables setValue:@(YES) forKey:tableName];
        }
        sqlite3_finalize(stmt);
        return count == 1;
    }
    NSLog(@"%s line:%d checkout the table %@ isExists failed: %s.", __FUNCTION__, __LINE__, tableName, sqlite3_errmsg(database));
    sqlite3_finalize(stmt);
    return NO;
}

- (NSUInteger)dataRowsWithClassName:(NSString *)classname database:(sqlite3 *)database
{
    if (![self openDatabase:&database]) return 0;
    NSUInteger count = 0;
    sqlite3_stmt *stmt;
    int  result;
    BOOL retry;
    BOOL triedFinalizd = NO;
    
    do {
        retry   = NO;
        NSString *string = [NSString stringWithFormat:@"SELECT count(*) FROM \"t_%@\";",classname];
        result = sqlite3_prepare_v2(database, string.UTF8String, -1, &stmt, NULL);
        if (SQLITE_BUSY == result || SQLITE_LOCKED == result) {
            if (!triedFinalizd) {
                triedFinalizd = YES;
                sqlite3_stmt *pStmt;
                while ((pStmt = sqlite3_next_stmt(database, nil)) !=0) {
                    sqlite3_finalize(pStmt);
                    retry = YES;
                }
            }
        }
        else if (SQLITE_OK != result) {
            NSLog(@"checkout the rows of table t_%@ failed: %s : %@.", classname, sqlite3_errmsg(database), retry ? @"将再次尝试": @"");
        }else{
            while(sqlite3_step(stmt) == SQLITE_ROW){
                count = (NSUInteger)sqlite3_column_int(stmt, 0);
            }
        }
        sqlite3_finalize(stmt);
    }
    while (retry);

    return count;
}

///< 创建表格
- (BOOL)creatTableWithName:(NSString *)classname database:(sqlite3 *)database
{
    NSString *sqlString = [self dc_sqlStringForCreatTableWithClassName:classname];
    BOOL flag = [self executeSqlString:sqlString database:database];
    if (!flag) {
        NSLog(@"%s line:%d sqlite creat table (t_%@) failed: %s", __FUNCTION__, __LINE__, classname, sqlite3_errmsg(database));
    }
    return flag;
}


#pragma mark - insert data

///< 插入数据
- (BOOL)insertDataWithObject:(id)object database:(sqlite3 *)database
{
    NSString *className = NSStringFromClass([(NSObject *)object class]);
    
    if (![self tableExistsWithClassName:className database:database]){
        if (![self creatTableWithName:className database:database])
            return NO;
    }
    
    NSDictionary *propertyInfo = [[DCClassHandle shareInstance] getClassPropertyInfoWithClassname:className];
    NSMutableString *insertSqlString = [[NSString stringWithFormat:@"INSERT INTO 't_%@' (", className] mutableCopy];
    NSMutableString *valueSqlString = [[NSString stringWithFormat:@") VALUES ("] mutableCopy];
    NSString *type = nil;
    NSString *name = nil;
    int count  = (int)propertyInfo.allKeys.count;
    NSArray *allkeys = propertyInfo.allKeys;
    for (int i = 0; i < count; i++) {
        name = allkeys[i];
        type = propertyInfo[name];
        [insertSqlString appendFormat:@"%@, ", name];
        [valueSqlString appendFormat:@"?%d, ", i+1];
    }
    [insertSqlString deleteCharactersInRange:NSMakeRange(insertSqlString.length - 2, 2)];
    [valueSqlString deleteCharactersInRange:NSMakeRange(valueSqlString.length - 2, 2)];
    [valueSqlString appendString:@");"];
    [insertSqlString appendString:[valueSqlString copy]];
    sqlite3_stmt *stmt = [self dc_preparedStmtWithClassname:className sql:[insertSqlString copy] database:database];
    if (!stmt) return NO;
    
    for (int i = 0; i < count; i++) {
        name = allkeys[i];
        type = propertyInfo[name];
        if ([type isEqualToString:@"TEXT"]) {
            
            NSString *value = [object valueForKeyPath:name];
            sqlite3_bind_text(stmt, i+1, value.UTF8String, -1, NULL);
            
        }else if ([type isEqualToString:@"INTEGER"]) {
            
            int value = (int)[(NSNumber *)[object valueForKeyPath:name] integerValue];
            sqlite3_bind_int(stmt, i+1, value);
            
        }else if ([type isEqualToString:@"REAL"]) {
            
            double value = [(NSNumber *)[object valueForKeyPath:name] doubleValue];
            sqlite3_bind_double(stmt, i+1, value);
            
        }else if ([type isEqualToString:@"ARRAY"] ||
                  [type isEqualToString:@"DICTIONARY"]) {
            
            NSString *string = [object valueForKeyPath:name];
            if (string) {
                NSData *data = [NSJSONSerialization dataWithJSONObject:string options:0 error:nil];
                NSString * value = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                sqlite3_bind_text(stmt, i+1, value.UTF8String, -1, NULL);
            }else{
                sqlite3_bind_text(stmt, i+1, NULL, 0, NULL);
            }
        }else if ([type isEqualToString:@"BLOB"]) {
            NSData *data = [object valueForKeyPath:name];
            if (data.length > 0) {
                sqlite3_bind_blob(stmt, i+1, data.bytes, (int)data.length, NULL);
            }else{
                sqlite3_bind_blob(stmt, i+1, NULL, 0, NULL);
            }
        }
    }
        
    if (sqlite3_step(stmt) != SQLITE_DONE) {
        NSLog(@"%s line:%d sqlite insert data failed : %s.", __FUNCTION__, __LINE__, sqlite3_errmsg(database));
        return NO;
    }
    return YES;
}


#pragma mark - delete data

- (BOOL)deleteDataWithClassName:(NSString *)classname database:(sqlite3 *)database condition:(NSString *)conditionString
{
    if (![self tableExistsWithClassName:classname database:database]){
        return YES;
    }
    NSString *deleteString = [NSString stringWithFormat:@"DELETE FROM t_%@ WHERE %@",classname, conditionString];
    return [self deleteDataWithSqlString:deleteString database:database];
}

///< 删除数据
- (BOOL)deleteAllDataWithClassName:(NSString *)classname database:(sqlite3 *)database
{
    if (![self tableExistsWithClassName:classname database:database]){
        return YES;
    }
    NSString *sqlString = [NSString stringWithFormat:@"DELETE FROM t_%@ ;", classname];
    return [self deleteDataWithSqlString:sqlString database:database];
}



- (BOOL)deleteDataWithSqlString:(NSString *)sqlString database:(sqlite3 *)database
{
    return [self executeSqlString:sqlString database:database];
}

- (BOOL)delteTableWithClassName:(NSString *)classname database:(sqlite3 *)database
{
    NSString *tableName = [NSString stringWithFormat:@"t_%@", classname];
    NSString *sqlString = [NSString stringWithFormat:@"DROP TABLE IF EXISTS %@;",tableName];
    BOOL flag = [self executeSqlString:sqlString database:database];
    if (flag) {
        [tables removeObjectForKey:tableName];
        CFDictionaryRemoveValue(stmts, (__bridge const void *)(classname));
    }
    return flag;
}

#pragma mark - updata data


- (BOOL)updateDataWithClassName:(NSString *)classname database:(sqlite3 *)database attribute:(NSString *)attribute toValue:(id)toValue condition:(NSString *)conditionString
{
    NSString *tableName = [NSString stringWithFormat:@"t_%@", classname];
    if (![self tableExistsWithClassName:classname database:database]){
        return NO;
    }
    NSString *temp = @"";
    if (conditionString) {
        temp = [NSString stringWithFormat:@"WHERE %@", conditionString];
    }
    NSString *updateString = [NSString stringWithFormat:@"UPDATE %@ SET %@ = '%@' %@;", tableName, attribute, toValue, temp];
    return [self executeSqlString:updateString database:database];
}


#pragma mark - main method

- (BOOL)executeSqlString:(NSString *)sqlString database:(sqlite3 *)database
{
    if (![self openDatabase:&database]) return NO;
    char *error = NULL;
    int flag = sqlite3_exec(database, sqlString.UTF8String, NULL, NULL, &error);
    if (flag == SQLITE_OK) {
        return YES;
    }else
    {
        NSLog(@"%s line:%d sqlite SQL string [%@] error (%d): %s", __FUNCTION__, __LINE__, sqlString, flag, error);
        sqlite3_free(error);
        return NO;
    }
}

#pragma mark - select data

- (NSArray *)selectAllWithClassName:(NSString *)classname
                           database:(sqlite3 *)database
{
    if (![self tableExistsWithClassName:classname database:database]){
        return nil;
    }
    NSString *selectString = [NSString stringWithFormat:@"SELECT * FROM t_%@",classname];
    return [self executeQuerySqlString:selectString database:database className:classname];
}


- (NSArray *)selectWithClassName:(NSString *)classname database:(sqlite3 *)database condition:(NSString *)conditionString
{
    if (![self tableExistsWithClassName:classname database:database]){
        return nil;
    }
    NSString *selectString = [NSString stringWithFormat:@"SELECT * FROM t_%@ WHERE %@",classname, conditionString];
    return [self executeQuerySqlString:selectString database:database className:classname];
}


- (NSArray *)selectWithClassName:(NSString *)classname database:(sqlite3 *)database attribute:(NSString *)attributeString isRise:(BOOL)isRise
{
    if (![self tableExistsWithClassName:classname database:database]){
        return nil;
    }
    NSString *selectString = [NSString stringWithFormat:@"SELECT * FROM t_%@ ORDER BY %@",classname, attributeString];
    if (!isRise) {
        selectString = [NSString stringWithFormat:@"%@ DESC", selectString];
    }
    return [self executeQuerySqlString:selectString database:database className:classname];
}


- (NSArray *)executeQuerySqlString:(NSString *)sqlString
                          database:(sqlite3 *)database
                         className:(NSString *)className;
{
    if (![self openDatabase:&database]) {
        NSLog(@"[Error] : execute SQL Query string failed, because open database failed！");
        return nil;
    }
    sqlite3_stmt *stmt;
    if (sqlite3_prepare_v2(database, sqlString.UTF8String, -1, &stmt, nil) != SQLITE_OK)
        return @[];
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
    while (sqlite3_step(stmt) == SQLITE_ROW) {
        [array addObject:[self getRecodeWithStmt:stmt className:className]];
    }
    sqlite3_finalize(stmt);
    return [array copy];
}



#pragma mark - private

- (sqlite3_stmt *)dc_preparedStmtWithClassname:(NSString *)classname sql:(NSString *)sql database:(sqlite3 *)database
{
    if (sql.length == 0) return NULL;
    sqlite3_stmt *stmt = (sqlite3_stmt *)CFDictionaryGetValue(stmts, (__bridge const void *)(classname));
    if (!stmt) {
        BOOL result = sqlite3_prepare_v2(database, sql.UTF8String, -1, &stmt, NULL);
        if (result != 0) {
            NSLog(@"%s line:%d sqlite create statement failed : %s.", __FUNCTION__, __LINE__, sqlite3_errmsg(database));
            return NULL;
        }else
        {
            CFDictionarySetValue(stmts, (__bridge const void *)(classname), stmt);
        }
    }else{
        sqlite3_reset(stmt);
    }
    return stmt;
}


- (NSDictionary *)getRecodeWithStmt:(sqlite3_stmt *)stmt className:(NSString *)classname
{
    NSDictionary *propertyDict = [[DCClassHandle shareInstance]
                                  getClassPropertyInfoWithClassname:classname];
    if (propertyDict.allKeys.count == 0)
        return nil;
    NSMutableDictionary *tempDict = [[NSMutableDictionary alloc]initWithCapacity:0];
    int count = (int)propertyDict.allKeys.count;
    
    if (!tableColumnFlag) {
        tableColumnFlag = YES;
        NSAssert(sqlite3_column_count(stmt) == count + 1, @"[Error] : Get recode failed , because the count of [table] 's column is changed, this table must be abandoned . please delete this table first.");
    }
    
    for (int i = 1; i < count + 1; i++) {
        // 从i = 1开始，建表的时候就决定了第0列为主键 _mainKey_tableName，不需要取出
        
        const char *name = sqlite3_column_name(stmt, i);
        NSString *propertyName = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
        NSString *type = propertyDict[propertyName];
        id value = nil;
        
        if ([type isEqualToString:@"TEXT"]) {
            char *text = (char *)sqlite3_column_text(stmt,i);
            if (text) {
                value = [[NSString alloc] initWithUTF8String:text];
            }
        }else if ([type isEqualToString:@"ARRAY"] ||
                  [type isEqualToString:@"DICTIONARY"]) {
            
            char *text = (char *)sqlite3_column_text(stmt,i);
            if (text) {
                value = [[NSString alloc] initWithUTF8String:text];
                value = [NSJSONSerialization JSONObjectWithData:
                         [(NSString *)value dataUsingEncoding:NSUTF8StringEncoding]
                                                        options:NSJSONReadingMutableContainers error:nil];
            }
        }else if ([type isEqualToString:@"INTEGER"]) {
            value = [NSString stringWithFormat:@"%i",sqlite3_column_int(stmt,i)];
        }else if ([type isEqualToString:@"REAL"]) {
            value = [NSString stringWithFormat:@"%f",sqlite3_column_double(stmt,i)];
        }else if ([type isEqualToString:@"BLOB"]) {
            const void *data = sqlite3_column_blob(stmt,i);
            int length = sqlite3_column_bytes(stmt, i);
            value = [NSData dataWithBytes:data length:length];
        }
        [tempDict setValue:value forKey:propertyName];
    }
    
    return [tempDict copy];
}

- (NSString *)dc_sqlStringForCreatTableWithClassName:(NSString *)classname
{
    NSMutableString *creatTableSqlString = [[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS 't_%@'( '_mainKey_%@' INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,", classname,classname] mutableCopy];
    NSDictionary *propertyInfo = [[DCClassHandle shareInstance] getClassPropertyInfoToAbsoluteSqliteTypeWithClassname:classname];
    for (NSString *name in propertyInfo.allKeys) {
        [creatTableSqlString appendString:[NSString stringWithFormat:@"'%@' %@,", name, propertyInfo[name]]];
    }
    [creatTableSqlString deleteCharactersInRange:NSMakeRange(creatTableSqlString.length - 1, 1)];
    [creatTableSqlString appendString:@")"];
    return [creatTableSqlString copy];
}


- (const char *)sqlitePath
{
    if (sqlitePath) {
        return sqlitePath;
    }
    sqlitePath = [self filePath].UTF8String;
    return sqlitePath;
}

- (NSString *)filePath
{
    NSString *filename = [[NSBundle mainBundle].infoDictionary
                          valueForKey:(NSString *)kCFBundleNameKey] ;
    filename = [NSString stringWithFormat:@"%@.db",filename];
    NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject
                          stringByAppendingPathComponent:[filename lastPathComponent]];
    return filePath;
}


@end
