//
//  BindMobileApi.h
//  ArtInteract
//
//  Created by 张阳 on 16/8/29.
//  Copyright © 2016年 崔露凯. All rights reserved.
//

#import "BaseApi.h"

@interface BindMobileApi : BaseApi


/**
 * 绑定手机 xiaocao.user.bindMobile
 */
- (void)userBindMobileWithThirdId:(NSString*)thirdId mobile:(NSString*)mobile verifyCode:(NSString*)verifyCode callback:(ApiRequestCallBack)callback;


@end
