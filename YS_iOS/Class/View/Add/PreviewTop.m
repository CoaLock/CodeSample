//
//  PreviewTop.m
//  YS_iOS
//
//  Created by 崔露凯 on 16/12/20.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "PreviewTop.h"


@interface PreviewTop ()


@property (weak, nonatomic) IBOutlet UILabel *authorIcon;



@end

@implementation PreviewTop


- (void)awakeFromNib {
    
    [super awakeFromNib];

    
    _authorIcon.lk_attribute
    .corner(2)
    .border(kTextThirdLevelColor, 1);
    
    
    
}


@end
