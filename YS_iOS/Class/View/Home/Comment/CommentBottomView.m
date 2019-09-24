//
//  CommentBottomView.m
//  YS_iOS
//
//  Created by 崔露凯 on 16/11/28.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "CommentBottomView.h"

@implementation CommentBottomView


- (void)awakeFromNib {

    [super awakeFromNib];
    
    _textField.userInteractionEnabled = NO;
    

}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

    if (_touchBlock) {
        _touchBlock();
    }
    
}



@end
