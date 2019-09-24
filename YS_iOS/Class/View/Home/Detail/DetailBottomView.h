//
//  DetailBottomView.h
//  YS_iOS
//
//  Created by 崔露凯 on 16/11/28.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import <UIKit/UIKit.h>


@class GArticleModel;

@interface DetailBottomView : UIView


@property (weak, nonatomic) IBOutlet UIButton *editBtn;


@property (weak, nonatomic) IBOutlet UITextField *textView;

@property (weak, nonatomic) IBOutlet UIButton *commentBtn;

@property (weak, nonatomic) IBOutlet UIButton *shareBtn;

@property (weak, nonatomic) IBOutlet UIButton *collectBtn;


@property (weak, nonatomic) IBOutlet UIButton *standbyBtn;

@property (nonatomic, strong) GArticleModel *articleModel;



@end
