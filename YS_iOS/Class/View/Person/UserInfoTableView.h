//
//  UserInfoTableView.h
//  YS_iOS
//
//  Created by 蔡卓越 on 2016/11/23.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "BaseTableView.h"

#import "UserModel.h"

typedef NS_ENUM(NSInteger, UserInfoType) {

    UserInfoTypeNickName = 0,
    UserInfoTypeRealName,
    UserInfoTypeSex,
    UserInfoTypeBirthday,
    UserInfoTypeCity,
    UserInfoTypeHeadIcon,
};

typedef void(^UserInfoBlock)(UserInfoType userInfoType);

@interface UserInfoTableView : BaseTableView

@property (nonatomic, copy) UserInfoBlock userInfoBlock;

@property (nonatomic, strong) UIImageView *headIcon;

@property (nonatomic, strong) UITextView *signTF;

@property (nonatomic, strong) UILabel *signPlaceHLabel;

@property (nonatomic, strong) UserModel *userModel;


- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style userInfoBlock:(UserInfoBlock)userInfoBlock;



@end
