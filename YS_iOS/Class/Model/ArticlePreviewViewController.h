//
//  ArticlePreviewViewController.h
//  YS_iOS
//
//  Created by 崔露凯 on 16/12/13.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "BaseViewController.h"

@interface ArticlePreviewViewController : BaseViewController


@property (nonatomic, assign) NSInteger articleId;



@property (nonatomic, strong) NSString *htmlStr;


@property (nonatomic, strong) NSString *articleTitle;

@property (nonatomic, strong) NSString *tagList;

@property (nonatomic, strong) NSString *tagStr;

@property (nonatomic, strong) NSString *textList;



@end
