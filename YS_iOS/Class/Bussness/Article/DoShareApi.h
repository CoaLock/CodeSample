//
//  DoShareApi.h
//  YS_iOS
//
//  Created by 崔露凯 on 16/12/22.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "BaseApi.h"

@interface DoShareApi : BaseApi


/* 2.5.10 分享
 * xiaocao.socialArticle.doShare
 */

- (void)doShareWithArticleId:(NSInteger)articleId callback:(ApiRequestCallBack)callback;



@end
