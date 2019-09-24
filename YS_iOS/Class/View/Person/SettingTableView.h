//
//  SettingTableView.h
//  YS_iOS
//
//  Created by 蔡卓越 on 2016/11/24.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "BaseTableView.h"

typedef NS_ENUM(NSInteger, SettingType) {

    SettingTypeChangePassword,
    SettingTypeChangeMobile,
    SettingTypePush,
    SettingTypeClearCache,
    SettingTypeShare,
    SettingTypeMobile,
    SettingTypeFeedback,
    SettingTypeAboutGrass,
    SettingTypeSignOut,
    SettingTypeNoPush,
};

typedef void(^SettingBlock)(SettingType settingType, id obj);

@interface SettingTableView : BaseTableView


@property (nonatomic, assign) BOOL isPush;


@property (nonatomic, copy) SettingBlock settingBlock;

@property (nonatomic, assign) SettingType settingType;

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style settingBlock:(SettingBlock)settingBlock;

@end
