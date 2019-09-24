//
//  ArticleModel.h
//  YS_iOS
//
//  Created by 崔露凯 on 16/12/16.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "BaseModel.h"


#import "TagModel.h"
#import "CommentModel.h"
#import "UserModel.h"


@interface GArticleModel : BaseModel

// 个人文章
@property (nonatomic, strong) NSString *articleId;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *smallPic;
@property (nonatomic, strong) NSString *bigPic;
@property (nonatomic, strong) NSString *status;

@property (nonatomic, strong) NSString *shareNum;
@property (nonatomic, strong) NSString *commentNum;
@property (nonatomic, strong) NSString *zanNum;

@property (nonatomic, strong) NSString *addtime;
@property (nonatomic, strong) NSString *statusStr;
@property (nonatomic, strong) NSString *addtimeStr;


// 通用文章详情
@property (nonatomic, strong) NSString *userId;

@property (nonatomic, strong) NSString *passTime;
@property (nonatomic, strong) NSString *passTimeStr;

@property (nonatomic, strong) NSString *contents; //html详情

@property (nonatomic, strong) NSString *isLogin;

@property (nonatomic, strong) NSString *isCollect;
@property (nonatomic, strong) NSString *isZan;
@property (nonatomic, strong) NSString *isFollow;

@property (nonatomic, strong) NSString *zanNumStr;

@property (nonatomic, strong) NSString *desc;


// 作者信息
@property (nonatomic, strong) UserModel *authorInfo;


// 文章作者信息
@property (nonatomic, strong) UserModel *userInfo;



@property (nonatomic, strong) NSMutableArray *textList;

// 文章标签列表
@property (nonatomic, strong) NSArray <TagModel*> *tagList;


// 其他文章列表
@property (nonatomic, strong) NSMutableArray <GArticleModel*> *otherArticleList;


// 打赏列表
@property (nonatomic, strong) UserListModel *articleRewardList;


// 评论列表
@property (nonatomic, strong) CommentListModel *articleCommentList;


@end


/* 文章类型
 * 1. 草稿 2.审核中  3.审核通过  4.审核未通过
 *
 */



@interface GArticleListModel : BaseModel

// 个人文章
@property (nonatomic, strong) NSMutableArray <GArticleModel*> *articleList;



@end









