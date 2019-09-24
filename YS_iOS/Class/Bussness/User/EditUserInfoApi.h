//
//  EditUserInfoApi.h
//  B2CShop
//
//  Created by 张阳 on 16/7/19.
//  Copyright © 2016年 beyondin. All rights reserved.
//

#import "BaseApi.h"

@interface EditUserInfoApi : BaseApi


/**
 *  修改用户信息(xiaocao.user.editUserInfo)
 *  允许修改的字段
 *  is_push, nickname, realname, headimgurl, sex, birthday, city_id, signature
 */
- (void)editUserInfoWithField:(NSString*)field value:(NSString*)value callback:(ApiRequestCallBack)callback;



@end
