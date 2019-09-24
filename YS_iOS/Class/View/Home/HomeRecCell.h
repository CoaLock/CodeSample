//
//  HomeRecCell.h
//  YS_iOS
//
//  Created by 崔露凯 on 16/11/26.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import <UIKit/UIKit.h>


@class GArticleModel;

/* 推荐 与屏幕等宽*/
@interface HomeRecCell : UICollectionViewCell


@property (nonatomic, strong) GArticleModel *articleModel;


@property (weak, nonatomic) IBOutlet UIButton *shareBtn;

@property (weak, nonatomic) IBOutlet UIButton *commentBtn;

@property (weak, nonatomic) IBOutlet UIButton *praiseBtn;

@property (weak, nonatomic) IBOutlet UIButton *headerBtn;



@end
