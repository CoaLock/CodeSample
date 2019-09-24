//
//  ArticleDynamicCell.h
//  YS_iOS
//
//  Created by 崔露凯 on 16/12/5.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import <UIKit/UIKit.h>


@class MessageModel;

@interface ArticleDynamicCell : UITableViewCell



@property (nonatomic, strong) MessageModel *messageModel;


+ (CGFloat)getCommentForArtcileCellHeight:(NSString*)text;

+ (CGFloat)getCommentForCommentCellHeight:(NSString*)contentText parentText:(NSString*)parentText;


@end
