//
//  CommentHeader.h
//  YS_iOS
//
//  Created by 崔露凯 on 16/11/28.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import <UIKit/UIKit.h>



@class GArticleModel;

@interface CommentHeader : UIView


@property (weak, nonatomic) IBOutlet UIButton *detailBtn;

@property (nonatomic, strong) GArticleModel *articleModel;


@end
