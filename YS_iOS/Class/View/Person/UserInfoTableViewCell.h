//
//  UserInfoTableViewCell.h
//  YS_iOS
//
//  Created by 蔡卓越 on 2016/11/23.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserInfoTableViewCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (nonatomic, strong) NSString *content;




@end
