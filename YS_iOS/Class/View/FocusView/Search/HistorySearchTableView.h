//
//  HistorySearchTableView.h
//  BS
//
//  Created by 张阳 on 16/4/14.
//  Copyright © 2016年 崔露凯. All rights reserved.
//

#import "BaseTableView.h"





typedef void (^TagListBlock) (NSString *tagText);



typedef void(^ClearSearchBlock)();



@interface HistorySearchTableView : BaseTableView



/** 关键词列表*/
@property (nonatomic, strong) NSMutableArray *recordList;


/** 热门词列表*/
@property (nonatomic, strong) NSMutableArray *hotList;



/** 搜索标签button*/
@property (nonatomic , copy) TagListBlock tagClickBlock;




/** 删除历史记录*/
@property (nonatomic , copy) ClearSearchBlock clearSearchBlock;




- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style clearSearchBlock:(ClearSearchBlock)clearSearchBlock;


- (void)reloadRecordList:(NSMutableArray*)recordList hotList:(NSMutableArray*)hotlist;



@end
