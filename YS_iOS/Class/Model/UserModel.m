//
//  UserModel.m
//  YS_iOS
//
//  Created by 崔露凯 on 16/12/12.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel



@end


@implementation UserListModel


+ (NSDictionary *)objectClassInArray {
    
    return @{@"rewardList" : [UserModel class],
             @"followList" : [UserModel class],
             @"userList" :   [UserModel class]};
}

@end
