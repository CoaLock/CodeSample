//
//  NavLeftHeader.h
//  YS_iOS
//
//  Created by 崔露凯 on 16/11/21.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import <UIKit/UIKit.h>


@class UserModel;

@interface NavLeftHeader : UIControl



- (void)loadUserInfo:(UserModel*)userModel;

@property (nonatomic, strong) UILabel *msgDot;



@end
