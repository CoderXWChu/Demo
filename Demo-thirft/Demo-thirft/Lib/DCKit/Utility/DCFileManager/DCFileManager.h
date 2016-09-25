//
//  DCFileManager.h
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

#import <Foundation/Foundation.h>

@interface DCFileManager : NSObject

+ (NSString *)TempDir;
+ (NSString *)CacheDir;
+ (NSString *)DocumentDir;
+ (NSString *)PreferencesDir;

+ (NSString *)TempPathWithFilename:(NSString *)name;
+ (NSString *)CachePathWithFilename:(NSString *)name;
+ (NSString *)DocumentPathWithFilename:(NSString *)name;
+ (NSString *)PreferencesPathWithFilename:(NSString *)name;

+ (NSString *)TempPathWithRandomName:(NSString *)name type:(NSString *)type;
+ (NSString *)CachePathWithRandomName:(NSString *)name type:(NSString *)type;
+ (NSString *)DocumentPathWithRandomName:(NSString *)name type:(NSString *)type;
+ (NSString *)PreferencesPathWithRandomName:(NSString *)name type:(NSString *)type;

+ (NSString *)creatDirectoryInTempWithName:(NSString *)dirName;
+ (NSString *)creatDirectoryInCacheWithName:(NSString *)dirName;
+ (NSString *)creatDirectoryInDocumentWithName:(NSString *)dirName;
+ (NSString *)creatDirectoryInPreferencesWithName:(NSString *)dirName;
+ (NSString *)creatDirectoryInPath:(NSString *)path WithName:(NSString *)dirName;

+ (BOOL)isExistFileWithFilePath:(NSString *)filepath;
+ (BOOL)isExistFileWithFilePath:(NSString *)filepath autoCreate:(BOOL)isCreateIfNo;

@end
