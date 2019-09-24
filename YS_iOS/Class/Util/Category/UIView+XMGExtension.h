//
//  UIView+XMGExtension.h
//
//  Copyright (c)  . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (XMGExtension)
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;

@property (nonatomic , assign) CGFloat centerX;
@property (nonatomic , assign) CGFloat centerY;

/**白色label*/
- (UIView*)itemTitleView:(NSString *)title;
@end
