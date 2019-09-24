//
//  PersonFocusAuthorCell.h
//  YS_iOS
//
//  Created by 崔露凯 on 16/12/1.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import <UIKit/UIKit.h>


@class UserModel;
@interface PersonFocusAuthorCell : UITableViewCell


@property (nonatomic, strong) UserModel *userModel;

@property (weak, nonatomic) IBOutlet UIButton *attentBtn;


@end
