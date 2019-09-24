//
//  BaseWKWebview.h
//  YS_iOS
//
//  Created by 崔露凯 on 16/12/15.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import <WebKit/WebKit.h>

@interface BaseWKWebview : UIView


@property (nonatomic, strong) NSString *htmlStr;


@property (nonatomic, copy) void (^loadEndBlock) (CGFloat webHeight);


@end
