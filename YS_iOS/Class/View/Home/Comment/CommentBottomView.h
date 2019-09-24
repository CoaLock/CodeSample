//
//  CommentBottomView.h
//  YS_iOS
//
//  Created by 崔露凯 on 16/11/28.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentBottomView : UIView


@property (weak, nonatomic) IBOutlet UITextField *textField;


@property (nonatomic, strong) void (^touchBlock) ();

@end
