//
//  Utils.h
//  PublicChips
//
//  Created by 王虎 on 15/9/15.
//  Copyright (c) 2015年 上海泓智信息科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utils : NSObject
#pragma mark- 字典添加元素
+(void)Dictionary:(NSMutableDictionary *)dic setobject:(id)object Forkey:(NSString *)Key;
+(BOOL)validateMobile:(NSString *)mobileNum;

+ (NSMutableDictionary *)getHbpDic;
+ (NSString *)Dic2json:(NSDictionary *)dic;
//判断字符串是否为空,为空返回无
+(BOOL)is_string_null:(NSString *)string;
//判断对象是否为空,为空返回无
+(BOOL)is_object_not_NSNull:(id)object;
//判断对象不为为空
+(BOOL)is_object_NSNull:(id)object;
//判断字符串不为空,为空返回无
+(BOOL)is_string_not_null:(NSString *)string;
+ (NSString *)toString:(id)string;
+ (NSString *)getLanguage;
#pragma mark -  判断字符串是否为纯数字
+ (BOOL)isPureNumandCharacters:(NSString *)string;
#pragma mark - 是否是纯字母
+ (BOOL)PureLetters:(NSString*)str;

#pragma mark - 判断字符串是否为纯汉字
+ (BOOL)isPureHanZi:(NSString *)string;

#pragma mark - 控制姓名只能输入汉字 A-Z a-z .
+ (BOOL)controlUserNameInputFormat:(NSString *)input;
@end
