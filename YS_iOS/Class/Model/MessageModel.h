//
//  MessageModel.h
//  YS_iOS
//
//  Created by 崔露凯 on 16/12/26.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "BaseModel.h"



#import "UserModel.h"
#import "GArticleModel.h"





@interface NoticeInfoModel : BaseModel


@property (nonatomic, strong) NSString *noticeId;
@property (nonatomic, strong) NSString *title;


@end



@interface MessageModel : BaseModel


// 1.推送文章
@property (nonatomic, strong) NSString *pushLogId;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *triggerId;
@property (nonatomic, strong) NSString *relationId;
@property (nonatomic, strong) NSString *addtime;
@property (nonatomic, strong) NSString *isRead;
@property (nonatomic, strong) NSString *contents;
@property (nonatomic, strong) NSString *addtimeStr;

@property (nonatomic, strong) NSString *articleId;




@property (nonatomic, strong) GArticleModel *articleInfo;


/****文章动态*****/
// 2. 文章被点赞
@property (nonatomic, strong) UserModel *triggerInfo;


// 3.文章被评论
@property (nonatomic, strong) CommentModel *commentInfo;


// 4.文章被打赏


// 5.文章被收藏


// 6.评论被点赞


// 7评论被评论


/****系统通知*****/

// 8.文章审核通过

// 9.文章审核未通过

// 10.被用户关注

// 11.群发公告
@property (nonatomic, strong) NoticeInfoModel *noticeInfo;



// 12.一句话通知



// 处理系统通知 类型 8  9  11  12
@property (nonatomic, strong) NSString *showStr;
@property (nonatomic, assign) BOOL      isShowMoreBtn;
@property (nonatomic, assign) CGFloat   cellHeight;


+ (void)hanleModelData:(MessageModel*)messageModel;

+ (void)hanleModelListData:(NSMutableArray*)modelList;



@end



@interface MessageListModel : BaseModel



@property (nonatomic, strong) NSMutableArray *pushLogList;



@end
