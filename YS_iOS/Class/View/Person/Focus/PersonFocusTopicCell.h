//
//  PersonFocusTopicCell.h
//  YS_iOS
//
//  Created by 崔露凯 on 16/12/1.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import <UIKit/UIKit.h>



@class TopicModel;

@interface PersonFocusTopicCell : UITableViewCell


@property (nonatomic, strong) TopicModel *topicModel;

@property (weak, nonatomic) IBOutlet UIButton *attentBtn;


@end

