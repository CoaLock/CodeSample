//
//  UMLoginUtil.h
//  YS_iOS
//
//  Created by 崔露凯 on 16/12/3.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UMSocialCore/UMSocialCore.h>


typedef NS_ENUM(NSUInteger, HandleStatus) {
    HandleStatusCanle,
    HandleStatusFailure,
    HandleStatusSuccess,
};

typedef void (^CompletionHandle) (NSDictionary *userInfo, NSString *errorStr, HandleStatus handleStatus);

@interface UMLoginUtil : NSObject


- (void)getUserInfoWithPlatform:(UMSocialPlatformType)loginType completion:(CompletionHandle)completion;



@end
