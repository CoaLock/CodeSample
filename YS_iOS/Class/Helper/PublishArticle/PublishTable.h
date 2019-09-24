//
//  PublishTable.h
//  b2c_user_ios
//
//  Created by 崔露凯 on 16/11/11.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "BaseTableView.h"
#import "ArticleModel.h"
#import "PublishTextCell.h"



@interface PublishTable : BaseTableView


// TextView end edit
@property (nonatomic, copy) CellEditBlock editBlock;


// 回调当前响应textView的frame
@property (nonatomic, copy) void (^cellDidChangeEdit) (CGRect textViewFrame);


// callback when tableView begin drag
@property (nonatomic, copy) void (^scrollBlock) ();



- (void)updateTableDatasSource:(ArticleModel*)articleModel;



@end
