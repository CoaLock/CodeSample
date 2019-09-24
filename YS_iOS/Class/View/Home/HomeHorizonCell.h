//
//  HomeHorizonCell.h
//  YS_iOS
//
//  Created by 崔露凯 on 16/11/26.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import <UIKit/UIKit.h>



@class GArticleModel;

@interface HomeHorizonCell : UICollectionViewCell



@property (weak, nonatomic) IBOutlet UIButton *shareBtn;

@property (weak, nonatomic) IBOutlet UIButton *commentBtn;

@property (weak, nonatomic) IBOutlet UIButton *praiseBtn;


@property (weak, nonatomic) IBOutlet UIButton *headerBtn;


@property (nonatomic, strong) GArticleModel *articleModel;




@end
