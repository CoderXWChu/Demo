//
//  DCFileManager.m
//
//  Created by DanaChu on 16/7/29.
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

#import "DCFileManager.h"

@implementation DCFileManager

+ (NSString *)CacheDir
{
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@""];
}

+ (NSString *)DocumentDir
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@""];
}

+ (NSString *)TempDir
{
    return NSTemporaryDirectory();
}

+ (NSString *)PreferencesDir
{
    return [NSSearchPathForDirectoriesInDomains(NSPreferencePanesDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@""];
}

+ (NSString *)CachePathWithFilename:(NSString *)name
{
    return [[self CacheDir] stringByAppendingPathComponent:name];
}

+ (NSString *)DocumentPathWithFilename:(NSString *)name
{
    return [[self DocumentDir] stringByAppendingPathComponent:name];
}

+ (NSString *)TempPathWithFilename:(NSString *)name
{
    return [[self TempDir] stringByAppendingPathComponent:name];
}

+ (NSString *)PreferencesPathWithFilename:(NSString *)name
{
    return [[self PreferencesDir] stringByAppendingPathComponent:name];
}

+ (NSString *)CachePathWithRandomName:(NSString *)name type:(NSString *)type
{
    NSString *filename = [NSString stringWithFormat:@"%@_%ju%@%@",name , (uintmax_t)time(NULL),[type containsString:@"."]?@"":@".",type];
    return [self CachePathWithFilename:filename];
}

+ (NSString *)DocumentPathWithRandomName:(NSString *)name type:(NSString *)type
{
    NSString *filename = [NSString stringWithFormat:@"%@_%ju%@%@",name , (uintmax_t)time(NULL),[type containsString:@"."]?@"":@".",type];
    return [self DocumentPathWithFilename:filename];
}

+ (NSString *)TempPathWithRandomName:(NSString *)name type:(NSString *)type
{
    NSString *filename = [NSString stringWithFormat:@"%@_%ju%@%@",name , (uintmax_t)time(NULL),[type containsString:@"."]?@"":@".",type];
    return [self TempPathWithFilename:filename];
}

+ (NSString *)PreferencesPathWithRandomName:(NSString *)name type:(NSString *)type
{
    NSString *filename = [NSString stringWithFormat:@"%@_%ju%@%@",name , (uintmax_t)time(NULL),[type containsString:@"."]?@"":@".",type];
    return [self PreferencesPathWithFilename:filename];
}

+ (NSString *)creatDirectoryInPath:(NSString *)path WithName:(NSString *)dirName
{
    NSString *dirPath = [path stringByAppendingPathComponent:dirName];
    BOOL flag = [[NSFileManager defaultManager] createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:nil];
    if (!flag) {
        return nil;
    }
    return dirPath;
}

+ (NSString *)creatDirectoryInTempWithName:(NSString *)dirName
{
    return [self creatDirectoryInPath:[self TempDir] WithName:dirName];
}
+ (NSString *)creatDirectoryInCacheWithName:(NSString *)dirName
{
    return [self creatDirectoryInPath:[self CacheDir] WithName:dirName];
}
+ (NSString *)creatDirectoryInDocumentWithName:(NSString *)dirName
{
    return [self creatDirectoryInPath:[self DocumentDir] WithName:dirName];
}
+ (NSString *)creatDirectoryInPreferencesWithName:(NSString *)dirName
{
    return [self creatDirectoryInPath:[self PreferencesDir] WithName:dirName];
}

+ (BOOL)isExistFileWithFilePath:(NSString *)filepath
{
    return [[NSFileManager defaultManager] fileExistsAtPath:filepath];
}

+ (BOOL)isExistFileWithFilePath:(NSString *)filepath autoCreate:(BOOL)isCreateIfNo
{
    BOOL flag = [self isExistFileWithFilePath:filepath];
    if (!flag && isCreateIfNo) {
        [self creatDirectoryInPath:filepath WithName:nil];
        return YES;
    }
    return flag;
}

@end
