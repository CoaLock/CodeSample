//
//  AddTagViewController.h
//  YS_iOS
//
//  Created by 崔露凯 on 16/12/13.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "BaseViewController.h"

@interface AddTagViewController : BaseViewController

@property (nonatomic, strong) void (^sureBlock) (NSArray *tagList, NSString *tagIdStr, NSString *tagNameStr);

@end
