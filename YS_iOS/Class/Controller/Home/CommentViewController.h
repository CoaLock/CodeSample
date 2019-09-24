//
//  CommentViewController.h
//  YS_iOS
//
//  Created by 崔露凯 on 16/11/28.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "BaseViewController.h"



@class GArticleModel;

@interface CommentViewController : BaseViewController



@property (nonatomic, strong) GArticleModel *articleModel;


@property (nonatomic, assign) NSInteger articleId;




@end
