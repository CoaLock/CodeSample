//
//  DetailPopView.h
//  YS_iOS
//
//  Created by 崔露凯 on 16/11/28.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void (^PopoverCellBlock) (NSInteger indexRow);


@interface DetailPopView : UIView


- (instancetype)initWithTitles:(NSArray*)titles images:(NSArray*)images cellBlock:(PopoverCellBlock)cellBlock;

- (void)replaceTitle:(NSString*)title images:(NSString*)image index:(NSInteger)index;



@end
