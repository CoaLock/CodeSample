//
//  PersonView.h
//  YS_iOS
//
//  Created by 蔡卓越 on 2016/11/23.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, PersonType) {

    PersonTypeCancel = 0,
    PersonTypeInfo,
    PersonTypeMessage,
    PersonTypeMoney,
    PersonTypeArticle,
    PersonTypeCollect,
    PersonTypeFollow,
    PersonTypeHelpCenter,
    PersonTypeSetting,
    
};

@class UserModel;

typedef void (^PersonBlock) (PersonType personType);

@interface PersonView : UIView

@property (nonatomic, copy) PersonBlock personBlock;


@property (nonatomic, strong) UIView *msgDot;



- (instancetype)initWithFrame:(CGRect)frame personBlock:(PersonBlock)personBlock;


- (void)loadUserInfo:(UserModel*)userInfo;



@end
