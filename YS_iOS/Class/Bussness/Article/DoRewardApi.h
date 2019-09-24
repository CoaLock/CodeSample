//
//  DoRewardApi.h
//  YS_iOS
//
//  Created by 崔露凯 on 16/12/22.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "BaseApi.h"

@interface DoRewardApi : BaseApi



/* 2.5.3 打赏
 * xiaocao.socialArticle.doReward
 */

- (void)doRewardWithArticleId:(NSInteger)articleId money:(NSInteger)money callback:(ApiRequestCallBack)callback;





@end
