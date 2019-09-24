//
//  TopicModel.h
//  YS_iOS
//
//  Created by 崔露凯 on 16/12/20.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "BaseModel.h"
#import "GArticleModel.h"



@interface TopicModel : BaseModel


@property (nonatomic, strong) NSString *topicId;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSString *fansNum;

@property (nonatomic, strong) NSString *basePic;
@property (nonatomic, strong) NSString *backgroundPic;
@property (nonatomic, strong) NSString *isLogin;
@property (nonatomic, strong) NSString *isFollow;


@property (nonatomic, strong) NSArray  <GArticleModel*> *articleList;

@property (nonatomic, strong) GArticleListModel *articleListModel;




@end




@interface TopicListModel : BaseModel



@property (nonatomic, strong) NSMutableArray  <TopicModel*> *topicList;

// 关注列表
@property (nonatomic, strong) NSMutableArray  <TopicModel*> *followList;



@end
