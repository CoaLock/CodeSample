//
//  DetailTable.h
//  YS_iOS
//
//  Created by 崔露凯 on 16/11/26.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "BaseTableView.h"


@class GArticleModel;

@interface DetailTable : BaseTableView


@property (nonatomic, strong) GArticleModel *articleModel;


@property (nonatomic, strong) UIButton *searchMoreComment;


//
@property (nonatomic, assign, readonly) BOOL isRecommend;



@end
