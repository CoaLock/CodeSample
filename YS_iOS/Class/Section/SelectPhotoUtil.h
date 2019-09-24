//
//  SelectPhotoUtil.h
//  b2c_user_ios
//
//  Created by 崔露凯 on 16/11/9.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void (^SuccessBlock)(UIImage *image, NSDictionary *info);


@class BaseViewController;

@interface SelectPhotoUtil : NSObject 


+ (instancetype)shareInstance;

- (void)selectImageViewWithViewController:(BaseViewController*)viewController success:(SuccessBlock)success;



@end
