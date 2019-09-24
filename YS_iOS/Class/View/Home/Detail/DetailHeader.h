//
//  DetailHeader.h
//  YS_iOS
//
//  Created by 崔露凯 on 16/11/26.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RewardListView.h"



@class GArticleModel;

@interface DetailHeader : UIView


@property (weak, nonatomic) IBOutlet UIButton *attentBtn;

@property (weak, nonatomic) IBOutlet UIButton *rewardBtn;

@property (weak, nonatomic) IBOutlet UIButton *praiseBtn;

@property (weak, nonatomic) IBOutlet UILabel *praiseLabel;


@property (nonatomic, strong) GArticleModel *articleModel;


@property (weak, nonatomic) IBOutlet RewardListView *rewardListView;



- (void)changeRewardList:(GArticleModel*)articleModel;


@property (nonatomic, assign) BOOL isPraised;


@end
