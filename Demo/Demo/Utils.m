//
//  Utils.m
//  PublicChips
//
//  Created by 王虎 on 15/9/15.
//  Copyright (c) 2015年 上海泓智信息科技有限公司. All rights reserved.
//

#import "Utils.h"

@implementation Utils
#pragma mark- 字典添加元素
+(void)Dictionary:(NSMutableDictionary *)dic setobject:(id)object Forkey:(NSString *)Key{
    //如果不为空则添加
    if ((object!=nil) & ![object isEqual:[NSNull null]]) {
        [dic setObject:(NSString *)object forKey:(NSString *)Key];
    }
    
}


+(BOOL)validateMobile:(NSString *)mobileNum
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    //    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    NSString * CM = @"^1(3[0-9]|(4[0-9]|5[0-9]|8[0-9])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    //    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    
    NSString * CU = @"^1(3[0-9]|(4[0-9]|5[0-9]|8[0-9])\\d)\\d{7}$";
    
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CT = @"^1((33|53|70|8[09])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

+ (NSMutableDictionary *)getHbpDic{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:@"01" forKey:@"黄浦区"];
    [dic setObject:@"04" forKey:@"徐汇区"];
    [dic setObject:@"05" forKey:@"长宁区"];
    [dic setObject:@"06" forKey:@"静安区"];
    [dic setObject:@"07" forKey:@"普陀区"];
    [dic setObject:@"08" forKey:@"闸北区"];
    [dic setObject:@"09" forKey:@"虹口区"];
    [dic setObject:@"10" forKey:@"杨浦区"];
    [dic setObject:@"12" forKey:@"闵行区"];
    [dic setObject:@"13" forKey:@"宝山区"];
    [dic setObject:@"14" forKey:@"嘉定区"];
    [dic setObject:@"15" forKey:@"浦东新区"];
    [dic setObject:@"16" forKey:@"金山区"];
    [dic setObject:@"17" forKey:@"松江区"];
    [dic setObject:@"18" forKey:@"青浦区"];
    [dic setObject:@"20" forKey:@"奉贤区"];
    [dic setObject:@"30" forKey:@"崇明县"];
    return dic;
}

+ (NSArray *)getHbpKeyArray{
    return @[@"01",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"20",@"30",];
}


+ (NSArray *)getHbpValuesArray{
    return @[@"黄浦区",@"徐汇区",@"长宁区",@"静安区",@"普陀区",@"闸北区",@"虹口区",@"杨浦区",@"闵行区",@"宝山区",@"嘉定区",@"浦东新区",@"金山区",@"松江区",@"青浦区",@"奉贤区",@"崇明县",];
}



+(BOOL)checkPhoneNumInput:(NSString *)mobileNum{
    
    
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    //    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    NSString * CM = @"^1(3[0-9]|(4[0-9]|5[0-9]|8[0-9])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    //    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    
    NSString * CU = @"^1(3[0-9]|(4[0-9]|5[0-9]|8[0-9])\\d)\\d{7}$";
    
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CT = @"^1((33|53|70|8[09])[0-9]|349)\\d{7}$";
    
    
    NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    NSPredicate *regextestPHS = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", PHS];
    
    
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES)
        || ([regextestPHS evaluateWithObject:mobileNum] == YES))
    {
        
        
        return YES;
        
    }
    
    else
        
    {
        
        return NO;
        
    }
    
    
    
}


//判断字符串是否为空,为空返回无
+(NSString *)stringisNOTnull:(NSString *)string{
    NSString  *getcs_tel=[[NSString alloc]init];
    if (string==nil ||(string=NULL) ||[string isEqual:[NSNull new]] ||[string isEqualToString:@""]) {
        getcs_tel=@"";
    } else {
        getcs_tel= string;
    }
    
    return getcs_tel;
}
//判断字符串是否为空,为空返回无
+(BOOL)is_string_null:(NSString *)string{
    if (string==nil||[string isEqual:[NSNull new]] ||(string=NULL) ||[string isEqualToString:@""]) {
        return YES;
    } else {
        return NO;
    }
}
//判断对象是否为空,为空返回无
+(BOOL)is_object_not_NSNull:(id)object{
    if ((object== nil) ||[object isEqual:[NSNull new]] ||(object==NULL)) {
        return NO;
    } else {
        return YES;
    }
}
//判断对象不为为空
+(BOOL)is_object_NSNull:(id)object{
    if ((object== nil) ||[object isEqual:[NSNull new]] ||(object==NULL)) {
        return YES;
    } else {
        return NO;
    }
}


//判断字符串是否为空,为空返回无
+(BOOL)is_string_not_null:(NSString *)string{
    if (string==nil||[string isEqual:[NSNull new]]||(string=NULL) ||[string isEqualToString:@""]) {
        return NO;
    } else {
        
        return YES;
    }
}
+ (NSString *)toString:(id)string{

    if ([string isKindOfClass:[NSNumber class]]) {
        
        return [NSString stringWithFormat:@"%@",string];
    }
    if (![string isKindOfClass:[NSString class]]) {
        
        return @"";
    }
    if (string==nil||[string isEqual:[NSNull new]] ) {
        return @"";
    }
    return [NSString stringWithFormat:@"%@",string];


}
+ (NSString *)getLanguage {
//    UIDevice *currentDevice = [UIDevice currentDevice];
//    
////    NSString *model = [currentDevice model];
//    
////    NSString *systemVersion = [currentDevice systemVersion];
////    
//    NSArray *languageArray = [NSLocale preferredLanguages];
//    
//    NSString *language = [languageArray objectAtIndex:0];
    
//    NSLocale *locale = [NSLocale currentLocale];
    
//    NSString *country = [locale localeIdentifier];
    
//    NSString *appVersion = [[NSBundle mainBundle]
//                            
//                            objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey];
    return @"zh";
}

#pragma mark- 显示label时赋值

+(NSString *)Label_name:(id)string{
    if (string==nil||[string isEqual:[NSNull new]] ) {
        return @"";
    } else  if ([string isKindOfClass:[NSString class]] &[string isEqualToString:@""]) {
        
        return [NSString stringWithFormat:@"%@",string];
    }else  if ([string isKindOfClass:[NSNumber class]]) {
        
        return [NSString stringWithFormat:@"%@",string];
    }
    return [NSString stringWithFormat:@"%@",string];
}
+ (NSString *)Dic2json:(NSDictionary *)dic{
    
    if ([NSJSONSerialization isValidJSONObject:dic]) {
        NSError *error = nil;
        NSData *data = [NSJSONSerialization dataWithJSONObject:dic
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
        return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }else
        return nil;
}
#pragma mark -  判断字符串是否为纯数字
+ (BOOL)isPureNumandCharacters:(NSString *)string{
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
    if(string.length > 0)
    {
        return NO;
    }
    return YES;
}
#pragma mark - 是否是纯字母
+ (BOOL)PureLetters:(NSString*)str{
    
    for(int i=0;i<str.length;i++){
        
        unichar c=[str characterAtIndex:i];
        
        if((c<'A'||c>'Z')&&(c<'a'||c>'z'))
            
            return NO;
    }
    return YES;
    
}

+ (BOOL)isPureHanZi:(NSString *)string {
    NSString *regex = @"^[\u4e00-\u9fa5]+";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    if (![pred evaluateWithObject:string]) {
        return NO;
    } else {
        return YES;
    }
}

+ (BOOL)controlUserNameInputFormat:(NSString *)input {
    NSString *regex = @"^[a-zA-Z.\u4e00-\u9fa5]+";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    if (![pred evaluateWithObject:input]) {
        return NO;
    } else {
        return YES;
    }
}

@end
