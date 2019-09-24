//
//  ArticlePushCell.h
//  YS_iOS
//
//  Created by 崔露凯 on 16/12/5.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import <UIKit/UIKit.h>


@class MessageModel;

@interface ArticlePushCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIButton *shareBtn;

@property (weak, nonatomic) IBOutlet UIButton *commentBtn;

@property (weak, nonatomic) IBOutlet UIButton *praiseBtn;


@property (weak, nonatomic) IBOutlet UIButton *headerBtn;


@property (nonatomic, strong) MessageModel *messageModel;




@end
