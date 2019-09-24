//
//  SaveArticleaPI.h
//  YS_iOS
//
//  Created by 崔露凯 on 16/12/13.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "BaseApi.h"

@interface SaveArticleaPI : BaseApi


/*
 *  2.3.4 用户保存文章  xiaocao.userArticle.saveArticle
 */

- (void)saveArticleWithArticleId:(NSInteger)articleId title:(NSString*)title tagList:(NSString*)tagList textList:(NSString*)textList callback:(ApiRequestCallBack)callback;






@end
