//
//  ArticleModel.m
//  YS_iOS
//
//  Created by 崔露凯 on 16/12/16.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "GArticleModel.h"

@implementation GArticleModel


+ (NSDictionary *)objectClassInArray{
    return @{@"tagList" : [TagModel class],
             @"otherArticleList" : [GArticleModel class]};
}


@end



@implementation GArticleListModel

+ (NSDictionary *)objectClassInArray{
    
    return @{@"articleList" : [GArticleModel class]};
}


@end






