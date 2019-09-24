//
//  ShareView.h
//  b2c_user_ios
//
//  Created by 崔露凯 on 16/11/8.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSUInteger, ShareType) {
    ShareTypeDefault,
    ShareTypeWX,
    ShareTypeTimeLine,
};

typedef void (^ShareEventBlock)(ShareType);


@interface ShareView : UIControl


+ (instancetype)shareView;


@property (nonatomic, copy) ShareEventBlock shareBlock;

- (void)showWithAnimation;

- (void)hideWithAnimation;




@end
