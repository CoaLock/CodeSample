//
//  FeedbackApi.h
//  YS_iOS
//
//  Created by 崔露凯 on 16/12/23.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "BaseApi.h"

@interface FeedbackApi : BaseApi



/*  2.8.6 意见反馈
 *  xiaocao.other.feedback
 */

- (void)feedbackWithContents:(NSString*)contents callback:(ApiRequestCallBack)callback;





@end
