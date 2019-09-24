//
//  ReportApi.h
//  YS_iOS
//
//  Created by 崔露凯 on 16/12/22.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "BaseApi.h"

@interface ReportApi : BaseApi



/* 2.5.11 举报
 * xiaocao.socialArticle.report
 */

- (void)reportWithType:(NSInteger)type relationId:(NSInteger)relationId description:(NSString*)description callback:(ApiRequestCallBack)callback;


@end
