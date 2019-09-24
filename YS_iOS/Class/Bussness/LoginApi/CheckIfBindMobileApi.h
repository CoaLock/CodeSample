//
//  CheckIfBindMobileApi.h
//  ArtInteract
//
//  Created by 蔡卓越 on 2016/10/11.
//  Copyright © 2016年 崔露凯. All rights reserved.
//

#import "BaseApi.h"

@interface CheckIfBindMobileApi : BaseApi


/**
 检测当前用户是否已绑定手机号(artist.user.checkIfBindMobile)
 */

- (void)checkIfBindMobileWithCallBack:(ApiRequestCallBack)callBack;

@end
