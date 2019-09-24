//
//  SignUpApi.h
//  ArtInteract
//
//  Created by 张阳 on 16/8/28.
//  Copyright © 2016年 崔露凯. All rights reserved.
//

#import "BaseApi.h"

@interface SignUpApi : BaseApi

/**
 * 注册 xiaocao.user.signup
 */
- (void)userSignupMobile:(NSString*)mobile password:(NSString*)password verifyCode:(NSString*)verifyCode callback:(ApiRequestCallBack)callback;



@end
