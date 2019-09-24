//
//  UserModel.h
//  YS_iOS
//
//  Created by 崔露凯 on 16/12/12.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "BaseModel.h"

@interface UserModel : BaseModel

@property (nonatomic, strong) NSString *leftMoney;
@property (nonatomic, strong) NSString *isRec;
@property (nonatomic, strong) NSString *fansNum;
@property (nonatomic, strong) NSString *sex;
@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, strong) NSString *realname;
@property (nonatomic, strong) NSString *userId; 
@property (nonatomic, strong) NSString *headimgurl;
@property (nonatomic, strong) NSString *signature;
@property (nonatomic, strong) NSString *birthday;
@property (nonatomic, strong) NSString *nickname;
@property (nonatomic, strong) NSString *isPush;

@property (nonatomic, strong) NSString *provinceName;
@property (nonatomic, strong) NSString *cityName;
@property (nonatomic, strong) NSString *provinceId;
@property (nonatomic, strong) NSString *cityid;


// 用于打赏
@property (nonatomic, strong) NSString *money;

@property (nonatomic, strong) NSString *isFollow;

@property (nonatomic, strong) NSString *articleNumStr;

@property (nonatomic, strong) NSString *addtimeStr;

@property (nonatomic, strong) NSString *addtime;

//

@end



@interface UserListModel : BaseModel


// 打赏列表
@property (nonatomic, strong) NSMutableArray *rewardList;


@property (nonatomic, strong) NSMutableArray *followList;

@property (nonatomic, strong) NSMutableArray *userList;

@end











