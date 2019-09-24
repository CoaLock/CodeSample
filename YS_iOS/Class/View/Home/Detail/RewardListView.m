//
//  RewardListView.m
//  YS_iOS
//
//  Created by 崔露凯 on 16/12/17.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "RewardListView.h"

#import "GArticleModel.h"

#import "UserModel.h"

#import "UIButton+SetImageWithURL.h"


@interface RewardListView ()




@end

@implementation RewardListView



- (void)awakeFromNib {
    [super awakeFromNib];
    
    
    UILabel *title = [[UILabel alloc] init];
    title.lk_attribute
    .text(@"打赏人员")
    .font(10)
    .textColor(kTextSecondLevelColor)
    .superView(self);
    
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_offset(12);
        make.centerY.mas_offset(0);
    }];
    
    self.clipsToBounds = YES;
}


- (void)setRewardList:(NSArray *)rewardList {

    _rewardList = rewardList;
    
    // 移除原有视图
    for (id btn in self.subviews) {
        if ([btn isKindOfClass:[UIButton class]]) {
            
            [btn removeFromSuperview];
        }
    }
    
    
    NSInteger maxCount = (kScreenWidth -62 -43)/40;
    NSInteger count = MIN(rewardList.count, maxCount);
    
    for (NSInteger i =0; i < count; i++) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.lk_attribute
        .corner(15)
        .backgroundColor([UIColor redColor])
        .superView(self);
        
        button.layer.masksToBounds = YES;
        
        button.userInteractionEnabled = NO;
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.mas_equalTo(62+ 40*i);
            make.width.height.mas_equalTo(30);
            make.centerY.mas_equalTo(0);
        }];
        
        
        UserModel *userModel = _rewardList[i];
        
        [button setYSImageWithURL:userModel.headimgurl placeHolderImage:[UIImage imageNamed:@"pl_header"]];
    }
    
}




@end
