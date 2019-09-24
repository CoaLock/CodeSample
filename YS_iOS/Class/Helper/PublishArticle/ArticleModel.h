//
//  PublishModel.h
//  b2c_user_ios
//
//  Created by 崔露凯 on 16/11/11.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import <Foundation/Foundation.h>


@class PublishModel;

@interface ArticleModel : NSObject


@property (nonatomic, strong) NSMutableArray <PublishModel*> *modelList;



@end




@interface PublishModel : NSObject

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSString *content;

@property (nonatomic, strong) NSString *imgUrl;

// 图片相对于屏幕的高度
@property (nonatomic, assign) CGFloat  *imgH;

// 图片真实宽高
@property (nonatomic, assign) CGFloat  *imgRealH;

@property (nonatomic, assign) CGFloat  *imgRealW;





@end
