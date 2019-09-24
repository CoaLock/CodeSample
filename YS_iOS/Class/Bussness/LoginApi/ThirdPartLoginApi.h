//
//  ThirdPartLoginApi.h
//  ArtInteract
//
//  Created by 张阳 on 16/8/28.
//  Copyright © 2016年 崔露凯. All rights reserved.
//

#import "BaseApi.h"

@interface ThirdPartLoginApi : BaseApi

/**
 *  第三方登录 xiaocao.user.thirdPartLogin
 *  @type    1.微信  2.qq  3.微博
 */
- (void)getThirdPartLoginType:(NSInteger)type detail:(NSString*)detail callback:(ApiRequestCallBack)callback;



@end
