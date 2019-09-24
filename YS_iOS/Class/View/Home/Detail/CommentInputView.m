//
//  CommentInputView.m
//  YS_iOS
//
//  Created by 崔露凯 on 16/11/28.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "CommentInputView.h"

@implementation CommentInputView



- (void)awakeFromNib {

    [super awakeFromNib];
    
    
    _submitBtn.lk_attribute
    .backgroundColor(kAppCustomMainColor);
    
    [_submitBtn setEnlargeEdge:10];
}


@end
