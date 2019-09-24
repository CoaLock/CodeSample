//
//  BlankDisplayView.h
//  YS_iOS
//
//  Created by 崔露凯 on 16/12/17.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BlankDisplayView : UIView



@property (nonatomic, weak) UIView *bindedView;

@property (nonatomic, strong) UIButton *skipBtn;


- (instancetype)initWithFrame:(CGRect)frame img:(NSString*)imgName title:(NSString*)title bgColor:(UIColor*)color;

- (void)shouldShow:(BOOL)shouldShow;




@end
