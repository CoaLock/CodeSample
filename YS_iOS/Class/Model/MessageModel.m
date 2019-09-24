//
//  MessageModel.m
//  YS_iOS
//
//  Created by 崔露凯 on 16/12/26.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "MessageModel.h"
#import "SystemNoticeCell.h"
#import "ArticleDynamicCell.h"

@implementation NoticeInfoModel



@end


@implementation MessageModel


+ (void)hanleModelData:(MessageModel*)messageModel {

    NSInteger type = [PASS_NULL_TO_NIL(messageModel.type) integerValue];
    
    
   // 处理系统通知
    NSString *showStr = @"";
    if (type == 8) {

        showStr = [NSString stringWithFormat:@"您的文章《%@》,已经通过审核，您可以在个人中心我的文章中查询您的发表记录。", messageModel.articleInfo.title];
    }
    else if (type == 9) {

        showStr = [NSString stringWithFormat:@"您的文章《%@》未通过审核，您可以在个人中心我的文章中查询您的发表记录。", messageModel.articleInfo.title];
    }
    else if (type == 11) {

        showStr = messageModel.noticeInfo.title;
    }
    else if (type == 12) {

        showStr = messageModel.contents;
    }
    
    messageModel.showStr = showStr;

    CGFloat cellHeight  = [SystemNoticeCell getCellHeight:showStr];
    messageModel.cellHeight = cellHeight;
   
    messageModel.isShowMoreBtn = (cellHeight > 90);
    
    
    if (type == 3) {
        
        messageModel.cellHeight = [ArticleDynamicCell getCommentForArtcileCellHeight:messageModel.commentInfo.contents];
        
    }
    
    if (type == 7) {
        NSString *parentStr = messageModel.commentInfo.parentInfo.contents;
        NSString *linkedStr = [NSString stringWithFormat:@"我的评论: %@", parentStr];
        
        messageModel.cellHeight = [ArticleDynamicCell getCommentForCommentCellHeight:messageModel.commentInfo.contents parentText:linkedStr];
    }
    
    
}

+ (void)hanleModelListData:(NSMutableArray*)modelList {

    for (MessageModel *messageModel  in modelList) {
     
        [MessageModel hanleModelData:messageModel];
    }
}


@end




@implementation MessageListModel


+ (NSDictionary *)objectClassInArray {
    
    return @{@"pushLogList" : [MessageModel class]};
    
}
    


@end
