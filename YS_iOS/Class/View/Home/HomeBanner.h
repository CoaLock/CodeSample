//
//  HomeBanner.h
//  YS_iOS
//
//  Created by 崔露凯 on 16/11/21.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import <UIKit/UIKit.h>



typedef void (^ImageOnClicked) (NSInteger index);



@interface HomeBanner : UIView <UIScrollViewDelegate>




// 更新图片数据
@property (nonatomic, strong) NSArray  *imageNames;


// 图片点击回调
@property (nonatomic, copy) ImageOnClicked imgClickBlock;


// 指定初始页面
@property (nonatomic, assign) NSInteger pageCounter;


- (void)hide;




@end
