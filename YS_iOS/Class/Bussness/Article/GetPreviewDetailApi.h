//
//  GetPreviewDetailApi.h
//  YS_iOS
//
//  Created by 崔露凯 on 16/12/13.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "BaseApi.h"

@interface GetPreviewDetailApi : BaseApi



/**
 * 2.3.3 获取用户文章的预览详情 xiaocao.userArticle.getPreviewDetail
 */

- (void)getPreviewDetailWithTextList:(NSString*)textList callback:(ApiRequestCallBack)callback;





@end
