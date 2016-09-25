//
//  DCDatabase.m
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

#import "DCDatabase.h"
#import "DCSqliteHandle.h"
#import "DCClassHandle.h"

static DCDatabase *_instance;

@implementation DCDatabase
{
    sqlite3 *db;
    dispatch_semaphore_t lock;
    dispatch_queue_t queue;
    DCSqliteHandle *sqliteHandle;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        lock = dispatch_semaphore_create(1);
        queue = dispatch_queue_create("com.DCDatabase.queue", DISPATCH_QUEUE_CONCURRENT);
        sqliteHandle = [[DCSqliteHandle alloc]init];
    }
    return self;
}

+ (instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[[self class] alloc] init];
    });
    return _instance;
}

- (void)dealloc
{
    [self closeDatabase];
}

#pragma mark - Public

- (BOOL)openDatabase
{
    dispatch_semaphore_wait(lock, DISPATCH_TIME_FOREVER);
    BOOL flag = [sqliteHandle openDatabase:&db];
    dispatch_semaphore_signal(lock);
    return flag;
}
- (BOOL)closeDatabase
{
    dispatch_semaphore_wait(lock, DISPATCH_TIME_FOREVER);
    BOOL flag = [sqliteHandle closeDatabase:db];
    if (flag) {
        db = 0X00;
        dispatch_semaphore_signal(lock);
        return YES;
    }
    dispatch_semaphore_signal(lock);
    return NO;
}

- (NSUInteger)dataRowsWithClassName:(NSString *)classname
{
    if (![self openDatabase]) return NO;
    dispatch_semaphore_wait(lock, DISPATCH_TIME_FOREVER);
    NSUInteger count = [sqliteHandle dataRowsWithClassName:classname database:db];
    dispatch_semaphore_signal(lock);
    return count;
}

- (BOOL)cleanDatabase
{
    [self closeDatabase];
    dispatch_semaphore_wait(lock, DISPATCH_TIME_FOREVER);
    BOOL flag = [sqliteHandle deleteDatabase];
    dispatch_semaphore_signal(lock);
    return flag;
}


#pragma mark - insert

- (BOOL)saveToDatabaseWithObject:(id)object
{
    return [self saveToDatabaseWithArray:@[object] autoRollback:YES];
}

- (void)saveToDatabaseWithObject:(id)object callBack:(DCDatabaseUnQueryHandle)callback
{ 
    [self saveToDatabaseWithArray:@[object] autoRollback:YES callBack:callback];
}

- (BOOL)saveToDatabaseWithArray:(NSArray *)models autoRollback:(BOOL)isRollback
{
    if (![self openDatabase]) return NO;
    NSArray *copyModels = [models copy];
    if (copyModels.count == 0) return NO;
    dispatch_semaphore_wait(lock, DISPATCH_TIME_FOREVER);
    BOOL flag = YES;
    if (isRollback) {
        
        @try {
            if(SQLITE_OK == sqlite3_exec(db, "BEGIN", nil, nil, nil))
            {
                for (id obj in copyModels) {
                    flag = [sqliteHandle insertDataWithObject:obj database:db];
                    if (!flag) {
                        @throw [NSException exceptionWithName:@"数据处理错误！" reason:@"-insertDataWithObject:database:执行错误" userInfo: nil];
                    }
                }
            }
            sqlite3_exec(db, "COMMIT", nil, nil, nil);
        } @catch (NSException *exception) {
            sqlite3_exec(db, "ROLLBACK", nil, nil, nil);
        } @finally {}
    }else
    {
        for (id obj in copyModels) {
            flag = [sqliteHandle insertDataWithObject:obj database:db];
            if (!flag) {
                dispatch_semaphore_signal(lock);
                return NO;
            }
        }
    }
    dispatch_semaphore_signal(lock);
    return flag;
}


- (void)saveToDatabaseWithArray:(NSArray *)models autoRollback:(BOOL)isRollback callBack:(DCDatabaseUnQueryHandle)callback
{
    dispatch_async(queue, ^{     
        BOOL flag =[self saveToDatabaseWithArray:models autoRollback:isRollback];
        if (callback) {
            dispatch_async(dispatch_get_main_queue(), ^{
                callback(flag);
            });
        }    
    });
}


- (BOOL)refreshDataWithArray:(NSArray *)models autoRollback:(BOOL)isRollback
{
    if (![self openDatabase]) return NO;
    NSString *className = NSStringFromClass([(NSObject *)models[0] class]);
    [self removeAllWithClassName:className];
    BOOL flag = [self saveToDatabaseWithArray:models autoRollback:isRollback];
    return flag;
}

- (void)refreshDataWithArray:(NSArray *)models autoRollback:(BOOL)isRollback callBack:(DCDatabaseUnQueryHandle)callback
{
    dispatch_async(queue, ^{     
        BOOL flag =[self refreshDataWithArray:models autoRollback:isRollback];
        if (callback) {
            dispatch_async(dispatch_get_main_queue(), ^{
                callback(flag);
            });
        }    
    });
}

#pragma mark - update

- (BOOL)updateDataWithClassName:(NSString *)classname attribute:(NSString *)attribute toValue:(id)toValue condition:(NSString *)conditionString
{
    if (![self openDatabase]) return NO;
    dispatch_semaphore_wait(lock, DISPATCH_TIME_FOREVER);
    BOOL flag = [sqliteHandle updateDataWithClassName:classname database:db attribute:attribute toValue:toValue condition:conditionString];
    dispatch_semaphore_signal(lock);
    return flag;
}

- (void)updateDataWithClassName:(NSString *)classname attribute:(NSString *)attribute toValue:(id)toValue condition:(NSString *)conditionString callBack:(DCDatabaseUnQueryHandle)callback
{ 
    dispatch_async(queue, ^{     
        BOOL flag =[self updateDataWithClassName:classname attribute:attribute toValue:toValue condition:conditionString];
        if (callback) {
            dispatch_async(dispatch_get_main_queue(), ^{
                callback(flag);
            });
        }    
    });
}

#pragma mark - delete

- (BOOL)removeDataWithClassName:(NSString *)classname condition:(NSString *)conditionString
{
    if (![self openDatabase]) return NO;
    dispatch_semaphore_wait(lock, DISPATCH_TIME_FOREVER);
    BOOL flag = [sqliteHandle deleteDataWithClassName:classname database:db condition:conditionString];
    dispatch_semaphore_signal(lock);
    return flag;
}


- (void)removeDataWithClassName:(NSString *)classname condition:(NSString *)conditionString callBack:(DCDatabaseUnQueryHandle)callback
{ 
    dispatch_async(queue, ^{     
        BOOL flag =[self removeDataWithClassName:classname condition:conditionString];
        if (callback) {
            dispatch_async(dispatch_get_main_queue(), ^{
                callback(flag);
            });
        }    
    });
}



- (BOOL)removeAllWithClassName:(NSString *)classname
{
    if (![self openDatabase]) return NO;
    dispatch_semaphore_wait(lock, DISPATCH_TIME_FOREVER);
    BOOL flag = [sqliteHandle deleteAllDataWithClassName:classname database:db];
    dispatch_semaphore_signal(lock);
    return flag;
}

- (void)removeAllWithClassName:(NSString *)classname callBack:(DCDatabaseUnQueryHandle)callback
{ 
    dispatch_async(queue, ^{     
        BOOL flag =[self removeAllWithClassName:classname];
        if (callback) {
            dispatch_async(dispatch_get_main_queue(), ^{
                callback(flag);
            });
        }    
    });
}



- (BOOL)deleteTableWithClassName:(NSString *)classname
{
    if (![self openDatabase]) return NO;
    dispatch_semaphore_wait(lock, DISPATCH_TIME_FOREVER);
    BOOL flag = [sqliteHandle delteTableWithClassName:classname database:db];
    dispatch_semaphore_signal(lock);
    return flag;
}

- (void)deleteTableWithClassName:(NSString *)classname callBack:(DCDatabaseUnQueryHandle)callback
{ 
    dispatch_async(queue, ^{     
        BOOL flag =[self deleteTableWithClassName:classname];
        if (callback) {
            dispatch_async(dispatch_get_main_queue(), ^{
                callback(flag);
            });
        }    
    });
}

#pragma mark - select

- (NSArray *)getDataWithClassName:(NSString *)classname condition:(NSString *)conditionString
{
    if (![self openDatabase]) return @[];
    dispatch_semaphore_wait(lock, DISPATCH_TIME_FOREVER);
    NSArray *datas = [sqliteHandle selectWithClassName:classname database:db condition:conditionString];
    dispatch_semaphore_signal(lock);
    if (!datas || datas.count == 0) return @[];
    return [self dc_convertDataToModelsWithClassName:classname dataArray:datas];
}


- (void)getDataWithClassName:(NSString *)classname condition:(NSString *)conditionString callBack:(DCDatabaseQueryHandle)callback
{ 
    dispatch_async(queue, ^{     
        NSArray *datas =[self getDataWithClassName:classname condition:conditionString];
        if (callback) {
            dispatch_async(dispatch_get_main_queue(), ^{
                callback(datas);
            });
        }    
    });
}


- (NSArray *)getDataWithClassName:(NSString *)classname attribute:(NSString *)attributeString isRise:(BOOL)isRise
{
    if (![self openDatabase]) return @[];
    dispatch_semaphore_wait(lock, DISPATCH_TIME_FOREVER);
    NSArray *datas = [sqliteHandle selectWithClassName:classname database:db attribute:attributeString isRise:isRise];
    dispatch_semaphore_signal(lock);
    if (!datas || datas.count == 0) return @[];
    return [self dc_convertDataToModelsWithClassName:classname dataArray:datas];
}

- (void)getDataWithClassName:(NSString *)classname attribute:(NSString *)attributeString isRise:(BOOL)isRise callBack:(DCDatabaseQueryHandle)callback
{ 
    dispatch_async(queue, ^{     
        NSArray *datas =[self getDataWithClassName:classname attribute:attributeString isRise:isRise];
        if (callback) {
            dispatch_async(dispatch_get_main_queue(), ^{
                callback(datas);
            });
        }    
    });
}


- (NSArray *)getAllWithClassName:(NSString *)classname
{
    if (![self openDatabase]) return nil;
    dispatch_semaphore_wait(lock, DISPATCH_TIME_FOREVER);
    NSArray *datas = [sqliteHandle selectAllWithClassName:classname database:db];
    dispatch_semaphore_signal(lock);
    if (!datas || datas.count == 0) return nil;
    return [self dc_convertDataToModelsWithClassName:classname dataArray:datas];
}

- (void)getAllWithClassName:(NSString *)classname callBack:(DCDatabaseQueryHandle)callback
{ 
    dispatch_async(queue, ^{     
        NSArray *datas =[self getAllWithClassName:classname];
        if (callback) {
            dispatch_async(dispatch_get_main_queue(), ^{
                callback(datas);
            });
        }    
    });
}

#pragma mark - private

- (NSArray *)dc_convertDataToModelsWithClassName:(NSString *)classname dataArray:(NSArray *)datas
{
    NSDictionary *typeIfo = [[DCClassHandle shareInstance] getClassPropertyInfoWithClassname:classname];
    NSMutableArray *modelArray = [[NSMutableArray alloc]initWithCapacity:0];
    Class C = NSClassFromString(classname);
    for (NSDictionary *info in datas) {
        id model = [[C alloc]init];
        for (NSString *key in info.allKeys) {
            id value = info[key];
            NSString *type = typeIfo[key];
            if ([type isEqualToString:@"INTEGER"]){
                value = @([(NSString *)value integerValue]);
            }else if ([type isEqualToString:@"REAL"]){
                value = @([(NSString *)value doubleValue]);
            }
            [model setValue:value forKeyPath:key];
        }
        [modelArray addObject:model];
    }
    return [modelArray copy];
}


@end
