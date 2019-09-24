//
//  RecTagViewController.h
//  YS_iOS
//
//  Created by 崔露凯 on 16/11/29.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "BaseViewController.h"

@interface RecTagViewController : BaseViewController


@property (nonatomic, copy) void (^returnBlock) (NSMutableArray *tagList);



@end
