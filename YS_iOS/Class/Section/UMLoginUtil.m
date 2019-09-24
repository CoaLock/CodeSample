//
//  UMLoginUtil.m
//  YS_iOS
//
//  Created by 崔露凯 on 16/12/3.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "UMLoginUtil.h"

@implementation UMLoginUtil



- (void)getUserInfoWithPlatform:(UMSocialPlatformType)loginType completion:(CompletionHandle)completion {

    [[UMSocialManager defaultManager] getUserInfoWithPlatform:loginType currentViewController:nil completion:^(id result, NSError *error) {
        
        // UMSocialPlatformErrorDomain
        NSString *errorStr = @"";
        if (error) {

            NSInteger code = error.code;
            
            if (code == 2009) {
                completion(nil, errorStr, HandleStatusCanle);
                return ;
            }
            
            if (code == 2010) {
                errorStr = @"网络异常";
            }
            else if (code == 2002) {
                errorStr = @"授权失败";
            }
            else if (code == 2011) {
                errorStr = @"第三方错误";
            }
            else {
                errorStr = @"获取信息失败";
            }
            
            completion(nil, errorStr, HandleStatusFailure);
            
            return ;
        }
        
        // UMSResponseCodeSuccess
        /*
         * user_id icon nickname  gender  address
         */
        UMSocialUserInfoResponse *userInfo = result;
        
        NSString *user_id    = userInfo.uid;
        NSString *icon       = userInfo.iconurl;
        NSString *nickname   = userInfo.name;
        
        NSString *gender     = @"0";
        NSString *address    = @"";
        
        //UMSocialResponse   0不详  1男 2女
        NSDictionary *originInfo = userInfo.originalResponse;
        if (loginType == UMSocialPlatformType_QQ) {
            
            NSString *genderStr = userInfo.name;
            if ([genderStr isEqualToString:@"男"]) {
                gender = @"1";
            }
            else if ([genderStr isEqualToString:@"女"]) {
                gender = @"2";
            }
            
            NSString *province = PASS_NULL_TO_NIL(originInfo[@"province"]) ? originInfo[@"province"] : @"";
            NSString *city = PASS_NULL_TO_NIL(originInfo[@"city"]) ? originInfo[@"city"] : @"";
            address = [NSString stringWithFormat:@"%@ %@", province, city];
        }
        else if (loginType == UMSocialPlatformType_WechatSession) {
            
            NSString *genderStr = userInfo.gender;
            if ([genderStr isEqualToString:@"m"]) {
                gender = @"1";
            }
            else if ([genderStr isEqualToString:@"f"]) {
                gender = @"2";
            }
            
            
            NSString *province = PASS_NULL_TO_NIL(originInfo[@"province"]) ? originInfo[@"province"] : @"";
            NSString *city = PASS_NULL_TO_NIL(originInfo[@"city"]) ? originInfo[@"city"] : @"";
            address = [NSString stringWithFormat:@"%@ %@", province, city];
        }
        else if (loginType == UMSocialPlatformType_Sina) {
            
            NSString *genderStr = userInfo.gender;
            if ([genderStr isEqualToString:@"m"]) {
                gender = @"1";
            }
            else if ([genderStr isEqualToString:@"f"]) {
                gender = @"2";
            }
            
            address = PASS_NULL_TO_NIL(originInfo[@"location"]) ? originInfo[@"location"] : @"";
        }
        
        NSDictionary *detail = @{@"third_id": user_id,
                                 @"headimgurl": icon,
                                 @"nickname": nickname,
                                 @"sex": gender,
                                 @"address": address,
                                 };
        
        completion(detail, nil, HandleStatusSuccess);
    }];
    
    
}



@end
