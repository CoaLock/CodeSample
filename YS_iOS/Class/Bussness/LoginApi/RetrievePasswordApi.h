//
//  RetrievePasswordApi.h
//  YS_iOS
//
//  Created by 崔露凯 on 16/12/3.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "BaseApi.h"

@interface RetrievePasswordApi : BaseApi



/**
 * xiaocao.user.retrievePassword
 */

- (void)retrievePasswordWithMobile:(NSString*)mobile verifyCode:(NSString*)verifyCode newPassword:(NSString*)newPassword callback:(ApiRequestCallBack)callback;


@end
