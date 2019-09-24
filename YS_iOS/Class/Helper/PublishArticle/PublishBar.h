//
//  PublishBar.h
//  b2c_user_ios
//
//  Created by 崔露凯 on 16/11/14.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import <UIKit/UIKit.h>



typedef NS_ENUM(NSUInteger, PublishBarEvent) {
    
    PublishBarEventSelectImg,  // 选择图片
    
};

typedef void (^BarEventBlock)(PublishBarEvent eventType);


@interface PublishBar : UIView


@property (nonatomic, strong) BarEventBlock eventBlock;


//- (instancetype)initWithFrame:(CGRect)frame eventBlock:(BarEventBlock)eventBlock;


@end
