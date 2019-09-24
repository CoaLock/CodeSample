//
//  GetMessageListApi.h
//  YS_iOS
//
//  Created by 崔露凯 on 16/12/25.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "BaseApi.h"

@interface GetMessageListApi : BaseApi


/* 2.8.1 获取用户消息列表
 * xiaocao.other.getMessageList
 * 列表类型：1系统通知，2文章动态，3推送好文。	
 
   type
    1                         推送好文
 
    2               文章被点赞
 
    3               文章被评论
    
    4               文章被打赏
    
    5               文章被收藏
    
    6               评论被点赞
    
    7               评论被评论
    
    8   文章审核通过
   
    9   文章审核未通过
    
    10  被用户关注
     
    11  群发公告
    
    12  一句话通知
 
 */



- (void)getMessageListWithType:(NSInteger)type firstRow:(NSInteger)firstRow fetchNum:(NSInteger)fetchNum callback:(ApiRequestCallBack)callback;




@end
