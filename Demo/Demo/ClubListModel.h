//
//  ClubListModel.h
//  城俱杯
//
//  Created by xqq on 16/3/4.
//  Copyright © 2016年 xqq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClubListModel : NSObject

@property (copy, nonatomic) NSString *club_applicant_name;
@property (copy, nonatomic) NSString *club_id;
@property (copy, nonatomic) NSString *club_name;
@property (copy, nonatomic) NSString *user_id;
@property (copy, nonatomic) NSString *club_description;
@property (copy, nonatomic) NSString *club_image;
@property (copy, nonatomic) NSString *club_status;
@property (copy, nonatomic) NSString *club_rank;
- (instancetype)initWithDic:(NSDictionary *)dic;
+ (instancetype)initWithClub:(NSDictionary *)dic;

@end
