//
//  TagModel.h
//  YS_iOS
//
//  Created by 崔露凯 on 16/12/13.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "BaseModel.h"

@interface TagModel : BaseModel


@property (nonatomic, strong) NSString *isFollow;
@property (nonatomic, strong) NSString *tagId;
@property (nonatomic, strong) NSString *tagName;


@end


@interface TagListModel : BaseModel


@property (nonatomic, strong) NSMutableArray *followList;


@end
