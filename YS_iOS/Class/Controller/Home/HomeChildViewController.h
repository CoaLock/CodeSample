//
//  HomeChildViewController.h
//  YS_iOS
//
//  Created by 崔露凯 on 16/11/26.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "BaseViewController.h"


@class GArticleListModel;

@interface HomeChildViewController : BaseViewController


@property (nonatomic, assign) NSInteger tag;


@property (nonatomic, assign) BOOL isSelect;


- (void)reloadData;


- (void)startLoadingDataWithTopModel:(GArticleListModel*)topModel;



@end
