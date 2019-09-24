//
//  FocusTopicsTableView.h
//  YS_iOS
//
//  Created by 张阳 on 16/11/22.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "BaseTableView.h"
#import "TopicModel.h"



//typedef void (^FocusCellClickBlock) (UIButton *button);



@interface FocusTopicsTableView : BaseTableView

/** scroll中的index的回调*/
//@property (nonatomic , copy) FocusCellClickBlock indexClickBlock;



@property (nonatomic, strong) TopicListModel *topicListModel;


@end
