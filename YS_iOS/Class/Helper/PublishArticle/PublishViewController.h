//
//  PublishViewController.h
//  b2c_user_ios
//
//  Created by 崔露凯 on 16/11/11.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "BaseViewController.h"


typedef NS_ENUM(NSUInteger, PushlishType) {
    PushlishTypeAdd,
    PushlishTypeEdit,
};

@interface PublishViewController : BaseViewController


@property (nonatomic, assign) NSInteger articleId;


@property (nonatomic, assign) PushlishType pushlishType;



@end
