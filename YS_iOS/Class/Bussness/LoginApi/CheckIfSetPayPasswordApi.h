//
//  CheckIfSetPayPasswordApi.h
//  ArtInteract
//
//  Created by 蔡卓越 on 2016/10/11.
//  Copyright © 2016年 崔露凯. All rights reserved.
//

#import "BaseApi.h"

@interface CheckIfSetPayPasswordApi : BaseApi


/**
 检测当前用户是否已设置支付密码(artist.user.checkIfSetPayPassword)
 */

- (void)checkIfSetPayPasswordWithCallBack:(ApiRequestCallBack)callBack;
@end
