//
//  ApnsModel.h
//  YS_iOS
//
//  Created by 崔露凯 on 16/12/29.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "BaseModel.h"


@interface ApsTxtModel : BaseModel


@property (nonatomic, strong)  NSString *noticeId;

@property (nonatomic, strong)  NSString *articleId;

@property (nonatomic, strong)  NSString *pushLogId;




@end


@interface ApsModel : BaseModel



@property (nonatomic, strong)  NSString *alert;
@property (nonatomic, strong)  NSString *badge;
@property (nonatomic, strong)  NSString *sound;


@end

@interface ApnsModel : BaseModel


@property (nonatomic, strong)  ApsModel    *aps;

@property (nonatomic, strong)  ApsTxtModel *txt;


@property (nonatomic, strong)  NSString *type;
@property (nonatomic, strong)  ApsModel *JMsgid;


@end
