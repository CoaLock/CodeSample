//
//  RecommondCell.h
//  YS_iOS
//
//  Created by 崔露凯 on 16/11/26.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import <UIKit/UIKit.h>


@class GArticleModel;

@interface RecommondCell : UITableViewCell


@property (nonatomic, strong) GArticleModel *leftModel;

@property (nonatomic, strong) GArticleModel *rightModel;


@property (weak, nonatomic) IBOutlet UIButton *leftBtn;

@property (weak, nonatomic) IBOutlet UIButton *rightBtn;



@property (weak, nonatomic) IBOutlet UIButton *shareBtn1;
@property (weak, nonatomic) IBOutlet UILabel *shareLabel1;

@property (weak, nonatomic) IBOutlet UIButton *commentBtn1;
@property (weak, nonatomic) IBOutlet UILabel *commnetLabel1;

@property (weak, nonatomic) IBOutlet UIButton *praiseBtn1;

@property (weak, nonatomic) IBOutlet UILabel *praiseL1;
@property (weak, nonatomic) IBOutlet UIButton *headerBtn1;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel1;


@property (weak, nonatomic) IBOutlet UIButton *shareBtn2;
@property (weak, nonatomic) IBOutlet UILabel *shareLabel2;

@property (weak, nonatomic) IBOutlet UIButton *commentBtn2;
@property (weak, nonatomic) IBOutlet UILabel *commnetLabel2;

@property (weak, nonatomic) IBOutlet UIButton *praiseBtn2;

@property (weak, nonatomic) IBOutlet UILabel *praiseL2;


@property (weak, nonatomic) IBOutlet UIButton *headerBtn2;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel2;



@end
