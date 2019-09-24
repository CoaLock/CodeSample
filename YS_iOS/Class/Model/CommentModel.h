//
//  CommentModel.h
//  YS_iOS
//
//  Created by 崔露凯 on 16/12/17.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "BaseModel.h"



@class CommentModel;

@interface CommentListModel : BaseModel


@property (nonatomic, strong) NSMutableArray <CommentModel*> *commentList;


@end



@interface CommentModel : BaseModel


@property (nonatomic, strong) NSString *nickname;
@property (nonatomic, strong) NSString *headimgurl;
@property (nonatomic, strong) NSString *commentId;
@property (nonatomic, strong) NSString *addtime;
@property (nonatomic, strong) NSString *zanNum;
@property (nonatomic, strong) NSString *contents;
@property (nonatomic, strong) NSString *pid;
@property (nonatomic, strong) NSString *addtimeStr;
@property (nonatomic, strong) NSString *isLogin;
@property (nonatomic, strong) NSString *isZan;
@property (nonatomic, strong) CommentModel *parentInfo;


// 消息
@property (nonatomic, strong) NSString *articleId;



@end


/*
"nickname": "tale",
"headimgurl": "http://img.pannationalarts.com/Uploads/image/config/2016-11/20161130091817_28108.jpg",
"comment_id": "1",
"addtime": "1481609760",
"zan_num": "100",
"contents": "adfasdfasdfasdf",
"pid": "0",
"addtime_str": "12月13日",
"is_login": 1,
"is_zan": 0,
"parent_info": null

*/



