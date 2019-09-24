//
//  CommentListApi.h
//  YS_iOS
//
//  Created by 崔露凯 on 16/12/20.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "BaseApi.h"

@interface CommentListApi : BaseApi


/* 2.5.2 获取文章评论列表
 * xiaocao.socialArticle.getCommentList
 */

- (void)getCommentListWithArticleId:(NSInteger)articleId firstRow:(NSInteger)firstRow fetchNum:(NSInteger)fetchNum callback:(ApiRequestCallBack)callback;


@end
