//
//  FollowGroupModel.m
//  剧能玩2.1
//
//  Created by 大兵布莱恩特  on 15/11/11.
//  Copyright © 2015年 大兵布莱恩特 . All rights reserved.
//

#import "FollowGroupModel.h"
#import "PinYinForObjc.h"
#import "modeObject.h"
#import "GetFirstLetter.h"
#import "ClubListModel.h"
@implementation FollowGroupModel

+ (instancetype)getGroupsWithArray:(NSMutableArray*)dataArray groupTitle:(NSString*)title
{
    NSMutableArray *tempArray = [NSMutableArray array];
    FollowGroupModel *group = [[FollowGroupModel alloc] init];
    //    NSMutableArray * array = [[NSMutableArray alloc]init];
    for (ClubListModel *model in dataArray) {
        NSString *str = model.club_name;
        char header1 = [GetFirstLetter getFirstWord:[str characterAtIndex:0] ];
        
        NSString *header = [[NSString stringWithFormat:@"%c",header1]uppercaseString];
        
        if ([header isEqualToString:title])
        {
            
            
            [tempArray addObject:model];
        }
    }
    group.groupTitle = title;
    group.follows = tempArray;
    
    
    return group;
}
#pragma mark -  判断字符串是否为纯数字
- (BOOL)isPureNumandCharacters:(NSString *)string{
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
    if(string.length > 0)
    {
        return NO;
    }
    return YES;
}



@end
