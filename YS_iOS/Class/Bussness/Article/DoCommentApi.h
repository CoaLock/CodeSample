//
//  DoCommentApi.h
//  YS_iOS
//
//  Created by 崔露凯 on 16/12/20.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "BaseApi.h"

@interface DoCommentApi : BaseApi

/* 2.5.1 评论
 * xiaocao.socialArticle.doComment
 */

- (void)doCommentWithArticleId:(NSInteger)articleId contents:(NSString*)contents commentId:(NSInteger)commentId callback:(ApiRequestCallBack)callback;


@end
