//
//  ChangeMobileApi.h
//  YS_iOS
//
//  Created by 崔露凯 on 16/12/2.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "BaseApi.h"

@interface ChangeMobileApi : BaseApi


/**
 * 绑定手机 xiaocao.user.changeMobile
 */
- (void)userBindMobileWithOldVerifyCode:(NSString*)oldVerifyCode newMobile:(NSString*)newMobile newVerifyCode:(NSString*)newVerifyCode callback:(ApiRequestCallBack)callback;




@end
