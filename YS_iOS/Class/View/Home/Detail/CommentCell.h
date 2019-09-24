//
//  CommentCell.h
//  YS_iOS
//
//  Created by 崔露凯 on 16/11/26.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import <UIKit/UIKit.h>


@class CommentModel;

@interface CommentCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIButton *praiseBtn;


@property (nonatomic, strong) CommentModel *commentModel;


+ (CGFloat)getCellHeightWithContent:(NSString*)content parentContent:(NSString*)parentStr;



@end
