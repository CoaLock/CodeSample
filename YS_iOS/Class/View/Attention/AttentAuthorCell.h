//
//  AttentAuthorCell.h
//  YS_iOS
//
//  Created by 崔露凯 on 16/11/30.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import <UIKit/UIKit.h>


#import "UserModel.h"

@interface AttentAuthorCell : UITableViewCell

@property (nonatomic, strong) UserModel *userModel;


@property (weak, nonatomic) IBOutlet UIButton *attentBtn;


@end
