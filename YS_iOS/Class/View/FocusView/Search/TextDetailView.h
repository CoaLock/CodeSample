//
//  TextDetailView.h
//  BS
//
//  Created by 张阳 on 16/4/8.
//  Copyright © 2016年 崔露凯. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TextDetailView : UIView

/** 标题*/

@property (nonatomic , strong) UILabel *textLabel;

- (instancetype)initWithFrame:(CGRect)frame text:(NSString *)text;

@end
