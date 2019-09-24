//
//  SystemNoticeCell.h
//  YS_iOS
//
//  Created by 崔露凯 on 16/12/5.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import <UIKit/UIKit.h>



@class MessageModel;

@interface SystemNoticeCell : UITableViewCell



@property (nonatomic, strong) MessageModel *messageModel;


+ (CGFloat)getCellHeight:(NSString*)text;



@end
