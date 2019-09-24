//
//  EditNameViewController.h
//  YS_iOS
//
//  Created by 蔡卓越 on 2016/11/24.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "BaseViewController.h"

typedef NS_ENUM(NSInteger, EditNameType) {

    EditNameTypeNickName,
    EditNameTypeRealName,
};

typedef void(^EditNameBlock)(NSString *textStr);

@interface EditNameViewController : BaseViewController


@property (nonatomic, strong) NSString *originName;


@property (nonatomic, assign) EditNameType editNameType;

@property (nonatomic, copy) EditNameBlock editNameBlock;

@end
