//
//  TopicModel.m
//  YS_iOS
//
//  Created by 崔露凯 on 16/12/20.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "TopicModel.h"

@implementation TopicModel


+ (NSDictionary *)objectClassInArray {
    
    return @{@"articleList" : [GArticleModel class],
             @"articleListModel" : [GArticleListModel class]};
}


+ (NSString *)mj_replacedKeyFromPropertyName121:(NSString *)propertyName {

    if ([propertyName isEqualToString:@"desc"]) {
        
        return @"description";
    }
    if ([propertyName isEqualToString:@"articleListModel"]) {
        
        return @"article_list";
    }
    return [super mj_replacedKeyFromPropertyName121:propertyName];
}


@end


@implementation TopicListModel


+ (NSDictionary *)objectClassInArray {
    
    return @{@"topicList" : [TopicModel class],
             @"followList": [TopicModel class]};
}


@end
