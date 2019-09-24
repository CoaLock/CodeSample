//
//  TopicMeController.h
//  YS_iOS
//
//  Created by 崔露凯 on 16/12/20.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "BaseViewController.h"

@interface TopicMeController : BaseViewController



- (void)startLoadData;


@property (nonatomic, copy) void (^followTopicBlock) (void);


@end
