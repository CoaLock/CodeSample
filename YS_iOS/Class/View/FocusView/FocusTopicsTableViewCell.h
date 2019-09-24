//
//  FocusTopicsTableViewCell.h
//  YS_iOS
//
//  Created by 张阳 on 16/11/22.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopicModel.h"


@interface FocusTopicsTableViewCell : UITableViewCell <UIScrollViewDelegate>


/** 关注按钮*/
@property (nonatomic , strong) UIButton *focusButton;


/** 分享*/
@property (nonatomic , strong) NSMutableArray *shareButtonArray;

/** 回话*/
@property (nonatomic , strong) NSMutableArray *imAnswerButtonArray;


/** scrollView中的元素数组*/
@property (nonatomic , strong) NSMutableArray *scrollImageArray;

@property (nonatomic, strong) TopicModel *topicModel;






@end
