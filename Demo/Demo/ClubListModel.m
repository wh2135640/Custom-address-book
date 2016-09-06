//
//  ClubListModel.m
//  城俱杯
//
//  Created by xqq on 16/3/4.
//  Copyright © 2016年 xqq. All rights reserved.
//

#import "ClubListModel.h"

@implementation ClubListModel

- (instancetype)initWithDic:(NSDictionary *)dic {
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

+ (instancetype)initWithClub:(NSDictionary *)dic {
    return [[self alloc] initWithDic:dic];
}

- (void) setValue:(id)value forUndefinedKey:(NSString *)key {
    NSLog(@"%@",key);
}


@end
