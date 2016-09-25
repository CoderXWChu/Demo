//
//  DCRuntimeHelper.h
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

#import <Foundation/Foundation.h>

/*!
 *  @brief 根据类名获取类的属性列表
 *
 *  @param aClass 类
 *
 *  @return 类的属性列表
 */
NSArray *dc_ClassPropertyList(Class aClass);

/*!
 *  @brief 根据类名获取类的成员属性列表
 *
 *  @param aClass 类
 *
 *  @return 类的成员属性列表
 */
NSArray *dc_ClassIvarList(Class aClass);

/*!
 *  @brief 交换方法实现
 *
 *  @param class            交换方法的类
 *  @param originalSelector 原方法 SEL
 *  @param swizzledSelector 现方法 SEL
 */
//void DCSwizzleMethod(Class class, SEL originalSelector, SEL swizzledSelector);

BOOL dc_SwizzleInstanceMethod(id instance, SEL originalSel, SEL newSel);

/*!
 *  @brief 交换方法实现
 *
 *  @param aClass            交换方法的类
 *  @param originalSel 原方法 SEL
 *  @param newSel      现方法 SEL
 */
BOOL dc_SwizzleClassMethod(Class aClass, SEL originalSel, SEL newSel);

/*!
 *  @brief 设置添加属性关联(assign以外)
 *
 *  @param instance 当前添加属性的对象
 *  @param value    属性值
 *  @param key      属性健
 */
void dc_SetAssociateValue(id instance, id value , void *key);

/*!
 *  @brief 设置添加属性关联(assign)
 *
 *  @param instance 当前添加属性的对象
 *  @param value    属性值
 *  @param key      属性健
 */
void dc_SetAssociateWeakValue(id instance, id value , void *key);

/*!
 *  @brief 获取属性关联
 *
 *  @param instance 当前属性所属的对象
 *  @param key      属性健
 *  @retrurn id     返回属性值
 */
id dc_GetAssociatedValueForKey(id instance, void *key);

/*!
 *  @brief 移除属性关联
 *
 *  @param instance 当前属性所属的对象
 */
void dc_RemoveAssociatedValues(id instance);

/*!
 *  @brief 深拷贝(遵守 NSCoding 协议的数据)
 *
 *  @param data 需要深拷贝的对象
 *
 *  @return 返回深拷贝后的数据
 */
id dc_DeepCopy(id data);

