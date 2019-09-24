//
//  DetailTableHeaderView.h
//
//
//  Created by 张阳 on 16/11/23.
//  Copyright © 2016年 崔露凯. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^FocusDetailButtoBlock) (UIButton *button);


@class TopicModel;

@interface DetailTableHeaderView : UIView


@property (nonatomic , copy) FocusDetailButtoBlock focusButtonBlock;

@property (nonatomic, strong) TopicModel *topicModel;



- (instancetype)initWithFrame:(CGRect)frame focusButtonBlock:(FocusDetailButtoBlock)focusButtonBlock;


@end
